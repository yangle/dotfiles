from IPython import get_ipython as _get_ipython

try:
    _get_ipython().magic("%load_ext line_profiler")
except Exception:
    pass

try:
    _get_ipython().magic("%load_ext memory_profiler")
except Exception:
    pass

del _get_ipython
