# PinPredict Homebrew Tap

Homebrew formulae for PinPredict's CLI tools.

> [!IMPORTANT]
> The upstream tool repos (`pinpredict/cloudctl`, `pinpredict/cwlogs`, `pinpredict/k4a`) are **private**, so downloads must authenticate. If you're logged in to the [GitHub CLI](https://cli.github.com) (`gh auth login`) this Just Works — the download strategy uses your `gh` credentials automatically. Only used to fetch release tarballs; the formulae themselves live in this public tap.
>
> To use a dedicated token instead, export one and it takes precedence over `gh`:
>
> ```sh
> export HOMEBREW_GITHUB_API_TOKEN=ghp_xxx
> ```
>
> Create it at <https://github.com/settings/tokens> (classic, `repo` scope) or <https://github.com/settings/personal-access-tokens/new> (fine-grained, `Contents: Read` on the three repos, **resource owner: pinpredict** — a fine-grained PAT owned by your personal account cannot see org repos and fails with a 404).

## Install

```sh
brew tap pinpredict/tap
brew install cloudctl
brew install cwlogs
brew install k4a
```

Or in one shot:

```sh
brew install pinpredict/tap/cloudctl
brew install pinpredict/tap/cwlogs
brew install pinpredict/tap/k4a
```

## Available formulae

| Formula | Description | Source |
|---------|-------------|--------|
| [cloudctl](Formula/cloudctl.rb) | Declarative IaC CLI for multi-cloud account management | [pinpredict/cloudctl](https://github.com/pinpredict/cloudctl) |
| [cwlogs](Formula/cwlogs.rb) | Tail AWS CloudWatch container logs with colorized output | [pinpredict/cwlogs](https://github.com/pinpredict/cwlogs) |
| [k4a](Formula/k4a.rb) | Interactive TUI for exploring Kafka clusters | [pinpredict/k4a](https://github.com/pinpredict/k4a) |

## How it works

Each upstream repo publishes its formula here on release via GoReleaser's `brews:` block. Formula updates are committed by a GitHub Actions bot using a PAT stored as `HOMEBREW_TAP_TOKEN` in each upstream repo.

## Upgrading

```sh
brew update
brew upgrade cloudctl cwlogs k4a
```
