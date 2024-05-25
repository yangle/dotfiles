import gdb
import re


class HighlightNan(gdb.Command):
    """
    Highlight "nan" and "inf" in GDB output in bold and red.
    """

    def __init__(self):
        super().__init__("highlight-nan", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        output = gdb.execute(arg, from_tty=True, to_string=True)
        output = re.sub(
            r'(nan(\(0x[0-9a-fA-F]+\))?|inf)', r'\033[1;91m\1\033[0m', output
        )
        print(output, sep='', end='')


HighlightNan()
