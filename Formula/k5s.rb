# typed: false
# frozen_string_literal: true

# TRANSITIONAL PACKAGE. k5s was renamed to k5; this formula exists so that the
# old name keeps working, and it is HAND-MAINTAINED — GoReleaser only ever
# writes Formula/k5.rb.
#
# It should never need touching again. It carries no version of its own (1.0.0,
# forever) and no copy of the binary: `brew upgrade k5s` upgrades its DEPENDENCY,
# which is where the real versions live.
#
# The url is a pinned TARBALL of this tap, and nothing is built from it — it
# exists only because Homebrew refuses to load a formula with no url at all
# ("formula requires at least a URL").
#
# ⚠ IT MUST NOT BE A `url ..., using: :git` / `.git` SOURCE, which is what this
# formula shipped first and which FAILED for everyone in this org. Homebrew
# clones a git url, our git config rewrites github.com HTTPS to SSH via
# `insteadOf`, and brew's sandbox denies reading ~/.ssh/known_hosts:
#
#     hostkeys_find_by_key_hostfile: hostkeys_foreach failed for
#     /Users/<user>/.ssh/known_hosts: Operation not permitted
#     Host key verification failed.
#     fatal: Could not read from remote repository.
#
# `brew upgrade k5s` then did nothing at all. A tarball is fetched with curl, so
# no git config and no SSH is involved. The tap is public, so no auth either.
#
# Why this instead of an Aliases/k5s symlink, which is the more obvious answer:
# an alias makes `brew install k5s` RESOLVE to k5, but it does not migrate a keg
# that is already installed. Everyone on the team has a k5s keg today; under an
# alias it would sit there orphaned, never upgraded, until each person noticed
# and ran `brew uninstall k5s && brew install k5` by hand. As a real formula it
# upgrades in place like anything else.
#
# ⚠ WHY THE k5s SYMLINK LIVES HERE AND NOT IN k5.rb. Two formulae may not own
# the same path — Homebrew refuses to link the second and leaves it half
# installed. Measured: with the old k5s keg linked, installing a k5 that also
# laid down bin/k5s failed with "Could not symlink bin/k5s ... is a symlink
# belonging to k5s", and the same for bin/exec-scenario. Keeping bin/k5s solely
# here means k5 and k5s never contend for a path.
class K5s < Formula
  desc "Transitional package: k5s was renamed to k5, which this installs"
  homepage "https://github.com/pinpredict/k5s"
  url "https://github.com/pinpredict/homebrew-tap/archive/69f915a1f0471666c1aa005b234ff9be2f90a6dc.tar.gz"
  sha256 "0f4c5d4da03289892443ddef4cc40ec43c7d54503f716efd85d06077d74ac006"
  version "1.0.0"
  license "MIT"

  depends_on "pinpredict/tap/k5"

  def install
    # The binary itself is k5's. This only re-exposes it under its old name.
    # A symlink and not a wrapper script on purpose: k5 names itself after
    # argv[0], so through this link `k5s --help` still says k5s. A
    # `exec k5 "$@"` wrapper would rewrite argv[0] and the help would
    # start talking about a command the user did not type.
    bin.install_symlink Formula["pinpredict/tap/k5"].opt_bin/"k5" => "k5s"
    (prefix/"README.md").write <<~TEXT
      k5s was renamed to k5.

      This package installs k5 and provides `k5s` as a link to it. Both
      commands work and both are supported; k5 is the name to prefer in new
      scripts. Nothing else has to change: k5s.yaml, k5s.config.yaml, rig
      namespaces, kube-contexts and labels are all untouched by the rename.
    TEXT
  end

  test do
    system "#{bin}/k5s", "version"
  end
end
