# PinPredict Homebrew Tap

Homebrew formulae for PinPredict's CLI tools.

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
