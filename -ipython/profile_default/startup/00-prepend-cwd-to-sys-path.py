# Make sure sys.path starts with current working directory.
# Somehow this is not always the case with embedded IPython in a virtual env.
# Also, sys.path.insert(0, '') doesn't work reliably -- apparently something in
# IPython *occasionally* wipes out the '' entry in sys.path.
import sys
sys.path.insert(0, '.')
