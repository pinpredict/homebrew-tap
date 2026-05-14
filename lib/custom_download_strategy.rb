require "download_strategy"

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from a
# GitHub Release on a *private* repository via the GitHub REST API, using the
# user's HOMEBREW_GITHUB_API_TOKEN. The default CurlDownloadStrategy hits
# https://github.com/.../releases/download/... which returns 404 anonymously
# for private repos and does not pick up the token.
#
# To use:
#
#   class Foo < Formula
#     url "https://github.com/OWNER/REPO/releases/download/vX.Y.Z/foo_Darwin_arm64.tar.gz",
#         using: GitHubPrivateRepositoryReleaseDownloadStrategy
#     ...
#   end
#
# Requires HOMEBREW_GITHUB_API_TOKEN to be set to a token with `repo` scope (or
# a fine-grained PAT with Contents: Read on the source repo).
class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  require "utils/formatter"
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid URL pattern for GitHub Release"
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download download_url, "--header", "Accept: application/octet-stream", to: temporary_path
  end

  def set_github_token
    @github_token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
    if @github_token.nil? || @github_token.empty?
      raise CurlDownloadStrategyError,
            "HOMEBREW_GITHUB_API_TOKEN must be set to a GitHub PAT with read access on the source repo."
    end
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found: #{@filename}" if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    GitHub.get_release(@owner, @repo, @tag)
  end
end
