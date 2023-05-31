# Intro

Based on [The Primeagen's Video](https://www.youtube.com/watch?v=w7i4amO_zaE)

# Setup

## Windows

At the moment I recommend [neovide](https://neovide.dev/), since the bundled `nvim-qt` was
very laggy and became slow very fast.

- Clone this repo into

```ps
~/AppData/Local/nvim
```

- Install [Packer](https://github.com/wbthomason/packer.nvim) following the instructions in their
`README`:

```ps
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
```

- Run `:PackerSync` to install packages.

I had to run this several times to get everything installed (I'd understand two runs: one for packer
and one for all the other packages, but I had to run it at least four times).

## Linux

Make sure to have `nvim` version >= `0.9` installed.

- Clone this repo into

```sh
~/.config/nvim
```

- Install [Packer](https://github.com/wbthomason/packer.nvim) following the instructions in their
`README`:

```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

- Run `:PackerSync` to install packages.

I had to run this several times to get everything installed
