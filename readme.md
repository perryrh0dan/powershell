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
- [Install](#install)
- [Usage](#usage)

## Install

1. Copy `PowerShell_profile.ps1` to your `$profile` path
2. Reload profile with `. $profile`

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

## Team

- Thomas Pöhlmann [(@perryrh0dan)](https://github.com/perryrh0dan)

## License

[MIT](https://github.com/perryrh0dan/passline/blob/master/license.md)

This repository was generated by [charon](https://github.com/perryrh0dan/charon)