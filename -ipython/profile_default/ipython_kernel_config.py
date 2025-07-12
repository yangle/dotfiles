# 'all', 'last', 'last_expr' or 'none', specifying which nodes should be run interactively (displaying output from expressions).
c.InteractiveShell.ast_node_interactivity = 'last_expr'

# Enable magic commands to be called without the leading %.
c.InteractiveShell.automagic = False

# The part of the banner to be printed before the profile
c.InteractiveShell.banner1 = ''
c.TerminalIPythonApp.display_banner = False

# Do not insert blank line before a prompt
c.InteractiveShell.separate_in = ''

# Just exit
c.InteractiveShell.confirm_exit = False

# Use the unnumbered ">>> " prompts
from IPython.terminal.prompts import ClassicPrompts
c.TerminalInteractiveShell.prompts_class = ClassicPrompts

# Do not show tips
c.InteractiveShell.enable_tip = False
c.TerminalInteractiveShell.enable_tip = False
