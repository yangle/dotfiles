from IPython.core.magic import no_var_expand, register_line_cell_magic


@no_var_expand
@register_line_cell_magic
def pyinstrument(line, cell=None):
    """
    Magic commands %pyinstrument and %%pyinstrument.
    """
    import datetime
    from pathlib import Path

    from IPython import get_ipython
    from pyinstrument import Profiler, renderers

    # Write to timestamped files under ~/pyinstrument.
    now = datetime.datetime.now()
    filename = now.strftime('~/pyinstrument/%Y%m%d.%H%M%S.%f.html')
    path = Path(filename).expanduser()

    code = line if cell is None else cell
    shell = get_ipython()

    with Profiler() as profiler:
        shell.ex(code)

    # Can't call profiler.write_html directly because it does not yet pass
    # through show_all to HTMLRenderer in pyinstrument 4.6.1.
    path.parent.mkdir(exist_ok=True)
    path.write_text(
        profiler.output(
            renderer=renderers.HTMLRenderer(show_all=True, timeline=False)
        ),
        encoding='utf-8',
    )
    print(path)


# Clean up local objects now that registration is complete.
del no_var_expand
del pyinstrument
del register_line_cell_magic
