To install a new extension:
1. Add a new git submodule under `_jupyter/nbextensions`.
2. Edit `_jupyter/nbconfig/notebook.json` to enable it.

### Why?

Jupyter Notebook searches for extensions under
`~/.local/share/jupyter/nbextensions`.  
It does **not** search under `~/.jupyter/nbextensions`.  
(See [the documentation][doc] for details.)

I'm housing git submodules for notebook extensions under `_jupyter/nbextensions`.
I can't put them directly under `-local/share/jupyter/nbextensions`
because files under `-local` are linked *individually* by the `setup` script.  
To make the extensions visible to Jupyter Notebook,
`~/.local/share/jupyter/nbextensions` is symlinked to
`~/.jupyter/nbextensions`.

[doc]: https://jupyter.readthedocs.io/en/latest/projects/jupyter-directories.html#config-dir
