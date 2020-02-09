from IPython.core.magic import register_line_cell_magic


@register_line_cell_magic
def pyinstrument(line, cell=None):
    """
    Magic commands %pyinstrument and %%pyinstrument.
    """
    from IPython import get_ipython
    from pyinstrument import Profiler

    code = line if cell is None else cell
    shell = get_ipython()

    with Profiler() as profiler:
        shell.ex(code)

    profiler.open_in_browser()


# Clean up local objects now that registration is complete.
del pyinstrument
del register_line_cell_magic
