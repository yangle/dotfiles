# dotfiles

This is my collection of configurations and scripts.

To clone the repository with all submodules into `~/.dotfiles`, run
```bash
git clone --recursive https://github.com/yangle/dotfiles.git ~/.dotfiles
```

To update all submodules, run
```bash
git submodule sync && git submodule update --init --recursive
```


## Install

The [setup](setup) script uses pattern matching to create symlinks in the
`$HOME` directory:

1. For any file prefixed by an *underscore* in the repository root, say
   `_$FILE`, `setup` creates a symlink `~/.$FILE` to `_$FILE`.

1. For any directory prefixed by an *underscore* in the repository root, say
   `_$DIR/`, `setup` creates a symlink `~/.$DIR` to `_$DIR/`.

1. For any directory prefixed by a *dash* in the repository root, say `-$DIR/`,
   `setup` makes a directory `~/.$DIR` and creates in it a symlink to
   *each individual file* under `_$DIR/`, making nested subdirectories when
   necessary.  
   (This leaves all other files under `~/.$DIR` out of version control.)

1. Any file or directory in the repository root that is *not* prefixed by an
   underscore or a dash is ignored by `setup`.

Before creating the symlinks and thus possibly overwriting existing files in
the `$HOME` directory, `setup` creates a tarball backup of such files to be
overwritten.
