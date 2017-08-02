# Set to display confirmation dialog on exit. You can always use ‘exit’ or ‘quit’, to force a direct exit without any confirmation.
c.JupyterConsoleApp.confirm_exit = False  # apparently a dummy
c.ZMQTerminalInteractiveShell.confirm_exit = False

# Text to display before the first prompt. Will be formatted with variables {version} and {kernel_banner}.
c.ZMQTerminalInteractiveShell.banner = ''
