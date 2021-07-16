Color schemes are set using [base16-universal-manager](https://github.com/pinpox/base16-universal-manager).

# Installation

```shell
go get github.com/pinpox/base16-universal-manager
```

# Configuration

base16-univeral-manager configuration can be found in `~/.config/base16-universal-manager/config.yaml`.

# Usage

Generate color scheme configurations for configured applications:

```shell
base16-universal-manager
```

Use a different colorscheme than the one in the config file:

```shell
base16-universal-manager --scheme=horizon-dark
```

## Why am I getting a 404?

You may need to add a GitHub Personal Access Token to get around some ratelimits. See [here](https://github.com/pinpox/base16-universal-manager#github-token-optional).

tl;dr create a token and don't give it any permissions. Add it to `~/.config/base16-universal-manager/config.yaml`, like this:

```yaml
GithubToken: <token-goes-here>
```
