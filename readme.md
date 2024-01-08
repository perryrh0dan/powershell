<h1 align="center">
  Powershell shortcuts
</h1>

<h4 align="center">
  Powershell profile with useful functions
</h4>

## Description

Adds some shortcuts and usefull commands to the PowerShell

## Contents

- [Description](#description)
- [Contents](#contents)
- [Install](#install)
- [Usage](#usage)
  - [watch](#watch)
  - [find\_port](#find_port)
  - [reload](#reload)
  - [remote\_branches](#remote_branches)
  - [dev](#dev)
- [Next](#next)
- [Team](#team)
- [License](#license)

## Install

1. Copy `PowerShell_profile.ps1` to your `$profile` path
2. Create a `variables.ps1` file in the same directory
3. Reload profile with `. $profile`

## Usage

### watch

``` bash
watch <command>
watch kubectl get pods
```

### find_port

Shows the process that is listening on a given port

``` bash
find_port <port>
```

### reload

Reloads the path environment variable, so newly installed programs can be used directly

``` bash
reload
```

### remote_branches

List all remote branches of the current git directory together with the author

### dev

Spin up your dev environment as a docker container, either by specifying a directory via `dev .` or by specifying a docker volume name such as `dev avatar`, or by entering your `REMOTE_DEV_ENV` via the `dev` command.

#### Parameters

| parameter | descrption | example |
| --------- | ---------- | ------- |
| port      | specifiy which ports should be exposed to the host system | dev . -Port 4200 |

## Options

Following variables can be set in the `variables.ps1`.

| name | description | example | 
| ---- | ----------- | ------- |
| DOCKER_DEV_ENV | docker image to use for the dev environment | registry.tpoe.dev/dev |
| REMOTE_DEV_ENV | comma seperated list of 'ssh connection' strings | 192.168.0.1,192.168.0.2 |
| SSH_DIRECTORY | directory that include ssh keys to be used in the dev container | C:/Users/thomas/.ssh |

## Next

- [] Find a way to mount the docker credentials from the windows credentials manager into the docker container

## Team

- Thomas Pöhlmann [(@perryrh0dan)](https://github.com/perryrh0dan)

## License

[MIT](https://github.com/perryrh0dan/passline/blob/master/license.md)

This repository was generated by [charon](https://github.com/perryrh0dan/charon)
