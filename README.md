# PinPredict Homebrew Tap

Homebrew formulae for PinPredict's CLI tools.

> [!IMPORTANT]
> The upstream tool repos (`pinpredict/cloudctl`, `pinpredict/cwlogs`, `pinpredict/k4a`, `pinpredict/k5s`, `pinpredict/pp-tui`) are **private**, so downloads must authenticate. If you're logged in to the [GitHub CLI](https://cli.github.com) (`gh auth login`) this Just Works — the download strategy uses your `gh` credentials automatically. Only used to fetch release tarballs; the formulae themselves live in this public tap.
>
> To use a dedicated token instead, export one and it takes precedence over `gh`:
>
> ```sh
> export HOMEBREW_GITHUB_API_TOKEN=ghp_xxx
> ```
>
> Create it at <https://github.com/settings/tokens> (classic, `repo` scope) or <https://github.com/settings/personal-access-tokens/new> (fine-grained, `Contents: Read` on every repo in the [Available formulae](#available-formulae) table below, **resource owner: pinpredict** — a fine-grained PAT owned by your personal account cannot see org repos and fails with a 404).

## Install

```sh
brew tap pinpredict/tap
brew install cloudctl
brew install cwlogs
brew install k4a
brew install k5
brew install pp-tui
```

Or in one shot:

```sh
brew install pinpredict/tap/cloudctl
brew install pinpredict/tap/cwlogs
brew install pinpredict/tap/k4a
brew install pinpredict/tap/k5
brew install pinpredict/tap/pp-tui
```

> **`k5s` was renamed to `k5`.** Both commands work. `brew install k5` gives you
> `k5`; `brew install k5s` gives you `k5` **plus** `k5s` as a link to it, because
> `k5s` is now a transitional formula that depends on `k5`.
>
> **If you already have `k5s` installed, just `brew update && brew upgrade k5s`** —
> it upgrades in place and pulls `k5` in. If the upgrade stops on a link conflict
> over `k5s` or `exec-scenario` (the old keg owns those paths), clear it once with
> `brew uninstall k5s && brew install k5s`. That is a one-time step.
>
> If you have `chaos-lab` installed from this tap, `brew uninstall chaos-lab` —
> use `k5` instead.

## Available formulae

| Formula | Description | Source |
|---------|-------------|--------|
| [cloudctl](Formula/cloudctl.rb) | Declarative IaC CLI for multi-cloud account management | [pinpredict/cloudctl](https://github.com/pinpredict/cloudctl) |
| [cwlogs](Formula/cwlogs.rb) | Tail AWS CloudWatch container logs with colorized output | [pinpredict/cwlogs](https://github.com/pinpredict/cwlogs) |
| [k4a](Formula/k4a.rb) | Interactive TUI for exploring Kafka clusters | [pinpredict/k4a](https://github.com/pinpredict/k4a) |
| [k5](Formula/k5.rb) | Kubernetes dev environments + polyglot chaos verification — one CLI/TUI | [pinpredict/k5s](https://github.com/pinpredict/k5s) |
| [k5s](Formula/k5s.rb) | Transitional — installs `k5` and provides `k5s` as a link to it | [pinpredict/k5s](https://github.com/pinpredict/k5s) |
| [pp-tui](Formula/pp-tui.rb) | Read-only TUI for watching PinPredict trading activity in real time | [pinpredict/pp-tui](https://github.com/pinpredict/pp-tui) |

## How it works

Each upstream repo publishes its formula here on release via GoReleaser's `brews:` block. Formula updates are committed by a GitHub Actions bot using a PAT stored as `HOMEBREW_TAP_TOKEN` in each upstream repo.

**A pushed tag with no GitHub release produces no formula bump.** GoReleaser runs off the release, not the tag, so tagging alone leaves the formula on the previous version. `cloudctl` is the live example: `v0.3.0` is tagged upstream but was never released, which is why `Formula/cloudctl.rb` correctly sits at `0.2.1`. If a formula looks stale, check `gh release list --repo pinpredict/<tool>` before assuming the publish job broke.

## Upgrading

```sh
brew update
brew upgrade cloudctl cwlogs k4a k5 pp-tui
```

## Renamed tools

`k5s` was renamed to `k5`. The old name is kept as a **transitional formula**
(`Formula/k5s.rb`) that depends on `k5` and contributes only the `k5s` link:

| Old name | New name | Shape |
|---|---|---|
| `k5s` | `k5` | `Formula/k5s.rb` — `depends_on "pinpredict/tap/k5"`, installs `bin/k5s` |

**Why a formula and not an `Aliases/k5s` symlink**, which is the more obvious
answer: an alias makes `brew install k5s` *resolve* to `k5`, but it does nothing
for a keg that is **already installed**. Everyone had a `k5s` keg; under an alias
each of those would sit orphaned and never upgrade until someone noticed and
reinstalled by hand. A real formula upgrades in place.

**Two formulae must never own the same path.** `bin/k5s` is installed by
`k5s.rb` only — `k5.rb` owns `k5` and `exec-scenario` and nothing else. Homebrew
refuses to link the second owner of a path and leaves it half-installed, which is
exactly what happened when `k5` also tried to claim `bin/k5s` alongside an
installed `k5s` keg. Keep new transitional formulae to the same rule.

A transitional formula carries a **fixed version (1.0.0) and a pinned-git `url`**
— the url only exists because Homebrew rejects a formula without one
(*"formula requires at least a URL"*), and a pinned revision avoids a sha256 that
would need re-checksumming. Nothing is built from it, so it never needs bumping;
`brew upgrade k5s` upgrades the *dependency*, where the real versions live.
