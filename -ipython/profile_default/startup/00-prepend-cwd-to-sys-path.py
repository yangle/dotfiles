# Make sure sys.path starts with current working directory.
# (Somehow this is not always the case with embedded IPython.)
import sys
if sys.path[0] != '':
    sys.path.insert(0, '')
