# typed: false
# frozen_string_literal: true

# HAND-WRITTEN STOPGAP — GoReleaser regenerates this file on the next k5 release
# and everything below goes away. Do not hand-edit it after that point; edit
# `brews:` in pinpredict/k5s's .goreleaser.yaml instead.
#
# The tool was renamed k5s -> k5. The rename lands in the upstream repo first, so
# until a release ships under the new name the only archives that exist are the
# v0.0.77 ones, which carry a binary called `k5s`. Rather than gate this formula
# on a release — which would leave `brew install k5` broken in the meantime — it
# installs the existing archive and renames the binary on the way in with
# `bin.install "k5s" => "k5"`. Same bytes, same sha256s, new name.
#
# ⚠ This formula owns `k5` and `exec-scenario` and NOTHING ELSE. The old `k5s`
# command is a separate formula (Formula/k5s.rb) that depends on this one and
# lays that name down itself. It is NOT a `bin.install_symlink` here: two
# formulae may not own the same path, and with a k5s keg installed — which
# everyone on the team has — a k5 that also claimed bin/k5s failed to link.
# See the comment in k5s.rb for the measured failure.
require_relative "../lib/custom_download_strategy"
class K5 < Formula
  desc "Kubernetes dev environments + polyglot chaos verification — one CLI/TUI"
  homepage "https://github.com/pinpredict/k5s"
  version "0.0.77"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/pinpredict/k5s/releases/download/v0.0.77/k5s_Darwin_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "947f1afc400076bebc6e1466a0a220d1f48d8f26da4e4f4255962c14568fabe4"

      define_method(:install) do
        bin.install "k5s" => "k5"
        bin.install "exec-scenario"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/pinpredict/k5s/releases/download/v0.0.77/k5s_Darwin_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "1131572ba7c0b144a20c3af04ea42c87c59bed77ff357f3386266f7b24bf2ea5"

      define_method(:install) do
        bin.install "k5s" => "k5"
        bin.install "exec-scenario"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/pinpredict/k5s/releases/download/v0.0.77/k5s_Linux_x86_64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "051f6094d4a6df20cff80b70a451810bbdbb3c3d075a5ec99890c17cc8abe116"
      define_method(:install) do
        bin.install "k5s" => "k5"
        bin.install "exec-scenario"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/pinpredict/k5s/releases/download/v0.0.77/k5s_Linux_arm64.tar.gz", using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "462b66a755af588feea4b8d52e1e0eaef9479e361b5678cfea4b498f982a55cc"
      define_method(:install) do
        bin.install "k5s" => "k5"
        bin.install "exec-scenario"
      end
    end
  end

  test do
    system "#{bin}/k5", "version"
    assert_predicate bin/"exec-scenario", :executable?
  end
end
