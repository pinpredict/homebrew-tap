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
brew install k5s
brew install pp-tui
```

Or in one shot:

```sh
brew install pinpredict/tap/cloudctl
brew install pinpredict/tap/cwlogs
brew install pinpredict/tap/k4a
brew install pinpredict/tap/k5s
brew install pinpredict/tap/pp-tui
```

> If you have `chaos-lab` installed from this tap, `brew uninstall chaos-lab` —
> it has been replaced by `k5s`.

## Available formulae

| Formula | Description | Source |
|---------|-------------|--------|
| [cloudctl](Formula/cloudctl.rb) | Declarative IaC CLI for multi-cloud account management | [pinpredict/cloudctl](https://github.com/pinpredict/cloudctl) |
| [cwlogs](Formula/cwlogs.rb) | Tail AWS CloudWatch container logs with colorized output | [pinpredict/cwlogs](https://github.com/pinpredict/cwlogs) |
| [k4a](Formula/k4a.rb) | Interactive TUI for exploring Kafka clusters | [pinpredict/k4a](https://github.com/pinpredict/k4a) |
| [k5s](Formula/k5s.rb) | Kubernetes dev environments + polyglot chaos verification — one CLI/TUI | [pinpredict/k5s](https://github.com/pinpredict/k5s) |
| [pp-tui](Formula/pp-tui.rb) | Read-only TUI for watching PinPredict trading activity in real time | [pinpredict/pp-tui](https://github.com/pinpredict/pp-tui) |

## How it works

Each upstream repo publishes its formula here on release via GoReleaser's `brews:` block. Formula updates are committed by a GitHub Actions bot using a PAT stored as `HOMEBREW_TAP_TOKEN` in each upstream repo.

**A pushed tag with no GitHub release produces no formula bump.** GoReleaser runs off the release, not the tag, so tagging alone leaves the formula on the previous version. `cloudctl` is the live example: `v0.3.0` is tagged upstream but was never released, which is why `Formula/cloudctl.rb` correctly sits at `0.2.1`. If a formula looks stale, check `gh release list --repo pinpredict/<tool>` before assuming the publish job broke.

## Upgrading

```sh
brew update
brew upgrade cloudctl cwlogs k4a k5s pp-tui
```
