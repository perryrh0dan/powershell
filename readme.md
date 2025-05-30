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
  - [find_port](#find_port)
  - [reload](#reload)
  - [remote_branches](#remote_branches)
  - [dev](#dev)
- [Next](#next)
- [Team](#team)
- [License](#license)

## Install

1. Clone the repository into your `$profile` directory without creating a new folder `git clone https://github.com/perryrh0dan/powershell .`
2. Update windows execution policy `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. (Optional) Create a `variables.ps1` file next to the entrypoint script
4. Run `Install-Module PSReadLine -RequiredVersion 2.3.5` to install PSReadLine
5. Reload profile with `. $profile`
6. (Optional) Create a `custom.ps1` file to add custom code next to the entrypoint script

## Usage

### watch

```bash
watch <command>
watch kubectl get pods
```

### find_port

Shows the process that is listening on a given port

```bash
find_port <port>
```

### reload

Reloads the path environment variable, so newly installed programs can be used directly

```bash
reload
```

### remote_branches

List all remote branches of the current git directory together with the author

### dev (volumeOrDirectoy)

Spin up your dev environment as a docker container, either by specifying a directory e.g. `dev .` to mount the current directory into the development environment or by specifying a docker volume name such as `dev avatar`, or by entering your `REMOTE_DEV_ENV` with the `dev` command without a parameter.

### dev_attach <containerId | name>

Connect to a running dev container.

### dev_backup <name>

Backup the workspace, history and zoxide directory of the given environment into a local tar archive.

### dev_copy <name> <path>

Copy the current text content from the clipboard into a file at the specified path inside the specified container.

### dev_create <name>

Creates a new volume with the specified <name> and sets a label so that it can be easily identified as a development volume.

### dev_list

List all volumes with the dev tag.

### dev_pull

Pull the latest version of the `DOCKER_DEV_ENV`.

### dev_restore <name> <path>

Create a new dev environment and restore the workspace, history and zoxide directory from a given tar archive.

### dev_stop

Stop all running dev containers

### dev_tags

List all local available tags of the `DOCKER_DEV_ENV`.

#### Parameters

All parameters are persisted in `~/.environments.json' along with the environment name, and are automatically loaded when an environment is started.
The values are overridden and overwritten if a parameter is specified. To clear the parameters for an environment, provide the option with a value of 'null'.

| parameter | descrption                                                                              | example           |
| --------- | --------------------------------------------------------------------------------------- | ----------------- |
| Port      | specifiy which port should be exposed to the host system                                | dev . -Port 4200  |
| Tag       | specifiy a specific tag that should be used from the `DOCKER_DEV_ENV` default is latest | dev . -Tag golang |

### update

Update this repository with a git pull to keep up with the latest changes.

### identities

## Options

Following variables can be set in the `variables.ps1`.

| name             | description                                                                                                | example                  |
| ---------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------ |
| DOCKER_DEV_ENV   | docker image to use for the dev environment                                                                | registry.tpoe.dev/dev    |
| REMOTE_DEV_ENV   | comma seperated list of 'ssh connection' strings                                                           | 192.168.0.1,192.168.0.2  |
| SSH_DIRECTORY    | directory that include ssh keys to be used in the dev container                                            | C:/Users/thomas/.ssh     |
| GPG_DIRECTORY    | directory that include gpg configurations                                                                  | "C:/Users/thomas/.gnupg" |
| SHARED_DIRECTORY | directory that is mounted to easily exchange files between the host system and the development environment | "C:/Users/thomas/shared" |
| KUBE_DIRECTORY   | directory that include kubectl configuration                                                               | C:/Users/thomas/.kube    |
| NGROK_DIRECTORY  | directory that include ngrok configuration                                                                 | C:/Users/thomas/.ngrok   |
| NPM_FILE         | npmrc file path                                                                                            | C:/Users/thomas/.ngrok   |
| DICT_FILE        | dictionary file path                                                                                       | C:/Users/thomas/dict.txt |

## Next

- [ ] Find a way to mount the docker credentials from the windows credentials manager into the docker container

## Team

- Thomas Pöhlmann [(@perryrh0dan)](https://github.com/perryrh0dan)

## License

[MIT](https://github.com/perryrh0dan/passline/blob/master/license.md)

This repository was generated by [charon](https://github.com/perryrh0dan/charon)
