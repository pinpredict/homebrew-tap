# PinPredict Homebrew Tap

Homebrew formulae for PinPredict's CLI tools.

> [!IMPORTANT]
> The upstream tool repos (`pinpredict/cloudctl`, `pinpredict/cwlogs`, `pinpredict/k4a`, `pinpredict/pp-tui`, `pinpredict/chaos-lab`) are **private**, so downloads must authenticate. If you're logged in to the [GitHub CLI](https://cli.github.com) (`gh auth login`) this Just Works — the download strategy uses your `gh` credentials automatically. Only used to fetch release tarballs; the formulae themselves live in this public tap.
>
> To use a dedicated token instead, export one and it takes precedence over `gh`:
>
> ```sh
> export HOMEBREW_GITHUB_API_TOKEN=ghp_xxx
> ```
>
> Create it at <https://github.com/settings/tokens> (classic, `repo` scope) or <https://github.com/settings/personal-access-tokens/new> (fine-grained, `Contents: Read` on all five repos, **resource owner: pinpredict** — a fine-grained PAT owned by your personal account cannot see org repos and fails with a 404).

## Install

```sh
brew tap pinpredict/tap
brew install cloudctl
brew install cwlogs
brew install k4a
brew install pp-tui
brew install chaos-lab
```

Or in one shot:

```sh
brew install pinpredict/tap/cloudctl
brew install pinpredict/tap/cwlogs
brew install pinpredict/tap/k4a
brew install pinpredict/tap/pp-tui
brew install pinpredict/tap/chaos-lab
```

## Available formulae

| Formula | Description | Source |
|---------|-------------|--------|
| [cloudctl](Formula/cloudctl.rb) | Declarative IaC CLI for multi-cloud account management | [pinpredict/cloudctl](https://github.com/pinpredict/cloudctl) |
| [cwlogs](Formula/cwlogs.rb) | Tail AWS CloudWatch container logs with colorized output | [pinpredict/cwlogs](https://github.com/pinpredict/cwlogs) |
| [k4a](Formula/k4a.rb) | Interactive TUI for exploring Kafka clusters | [pinpredict/k4a](https://github.com/pinpredict/k4a) |
| [pp-tui](Formula/pp-tui.rb) | Read-only TUI for watching PinPredict trading activity in real time | [pinpredict/pp-tui](https://github.com/pinpredict/pp-tui) |
| [chaos-lab](Formula/chaos-lab.rb) | Polyglot chaos orchestrator — scenarios in any language, one CLI/TUI | [pinpredict/chaos-lab](https://github.com/pinpredict/chaos-lab) |

## How it works

Each upstream repo publishes its formula here on release via GoReleaser's `brews:` block. Formula updates are committed by a GitHub Actions bot using a PAT stored as `HOMEBREW_TAP_TOKEN` in each upstream repo.

## Upgrading

```sh
brew update
brew upgrade cloudctl cwlogs k4a pp-tui chaos-lab
```
