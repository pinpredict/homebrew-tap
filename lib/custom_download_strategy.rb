require "download_strategy"

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from a
# GitHub Release on a *private* repository via the GitHub REST API. The default
# CurlDownloadStrategy hits https://github.com/.../releases/download/... which
# returns 404 anonymously for private repos and does not pick up any token.
#
# To use:
#
#   class Foo < Formula
#     url "https://github.com/OWNER/REPO/releases/download/vX.Y.Z/foo_Darwin_arm64.tar.gz",
#         using: GitHubPrivateRepositoryReleaseDownloadStrategy
#     ...
#   end
#
# Credentials, in order of precedence:
#
#   1. HOMEBREW_GITHUB_API_TOKEN — a PAT with `repo` scope (classic) or
#      Contents: Read on the source repo (fine-grained, resource owner must be
#      the org that owns the repo).
#   2. The GitHub CLI's stored login (`gh auth token`), so anyone who has run
#      `gh auth login` can install without any extra setup.
class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  require "json"
  require "utils/formatter"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid URL pattern for GitHub Release"
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download download_url,
                  "--header", "Authorization: token #{github_token}",
                  "--header", "Accept: application/octet-stream",
                  to: temporary_path
  end

  # Resolved lazily so that credentials are only required when a download
  # actually happens — a tarball already in the download cache installs
  # without any GitHub access.
  def github_token
    @github_token ||= begin
      token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
      token = gh_cli_token if token.nil? || token.empty?
      if token.nil? || token.empty?
        raise CurlDownloadStrategyError,
              "No GitHub credentials found. Run `gh auth login`, or set " \
              "HOMEBREW_GITHUB_API_TOKEN to a PAT with read access on the source repo."
      end

      token
    end
  end

  def gh_cli_token
    gh = gh_executable
    return if gh.nil?

    token = Utils.popen_read(gh, "auth", "token").chomp
    token.empty? ? nil : token
  rescue StandardError
    nil
  end

  # brew sanitizes PATH (shims + /usr/bin:/bin:...), which hides gh installed
  # under the brew prefix or elsewhere on the user's PATH. The original PATH
  # survives in HOMEBREW_PATH, so search there plus the brew prefix.
  def gh_executable
    dirs = ["#{HOMEBREW_PREFIX}/bin"] +
           ENV.fetch("HOMEBREW_PATH", ENV.fetch("PATH", "")).split(File::PATH_SEPARATOR)
    dirs.map { |dir| File.join(dir, "gh") }.find { |path| File.executable?(path) }
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata.fetch("assets", []).select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found: #{@filename}" if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    output, _, status = curl_output(
      "--header", "Authorization: token #{github_token}",
      "--header", "Accept: application/vnd.github+json",
      release_url
    )
    body = status.success? ? JSON.parse(output) : {}
    if body["assets"].nil?
      raise CurlDownloadStrategyError,
            "Failed to fetch release #{@tag} of #{@owner}/#{@repo}: " \
            "#{body.fetch("message", "no response")}. " \
            "Check that your GitHub credentials can read the repo."
    end

    body
  rescue JSON::ParserError
    raise CurlDownloadStrategyError,
          "Failed to parse GitHub release metadata for #{@owner}/#{@repo} #{@tag}"
  end
end
