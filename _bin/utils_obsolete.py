#!/usr/bin/python2

class Unbuffered:
    """turn off buffering"""
    def __init__(self, stream):
        self.stream = stream
    def write(self, data):
        self.stream.write(data)
        self.stream.flush()
    def __getattr__(self, attr):
        return getattr(self.stream, attr)
## this breaks bpython
# import sys
# sys.stdout=Unbuffered(sys.stdout)

def lp(filename):
    """load cPickle as return as a DotDict, if possible"""
    from cPickle import load
    from os.path import isfile
    if isfile(filename + '.pickle'):
        with open(filename + '.pickle') as f:
            data = load(f)
    if isfile(filename):
        with open(filename) as f:
            data = load(f)
    else:
        return None

    if isinstance(data, dict):
        return DotDict(data)
    else:
        return data

class memoized(object):
    """Memoizing decorator

    Usage: @memoized before functions, memomized() around lambdas
    """
    # this does not allow kwargs. error msg "__call__() got an unexpected keyword argument ..."
    # use backport of functools.lru_cache instead: http://code.activestate.com/recipes/578078/
    def __init__(self, func):
        self.func = func
        self.cache = {}
    def __call__(self, *args):
        try:
            return self.cache[args]
        except KeyError:
            value = self.func(*args)
            self.cache[args] = value
            return value
        except TypeError:
            return self.func(*args)
    def __repr__(self):
        return repr(self.func)
    def __get__(self, obj, objtype):
        """support instance methods. see http://stackoverflow.com/a/3296318"""
        from functools import partial
        return partial(self.__call__, obj)

def get_input(prompt, default='default', timeout=10):
    print prompt, '(timeout = %d sec, press ENTER when finish):' % timeout,

    from select import select
    from sys import stdin
    i, o, e = select([stdin], [], [], timeout)
    if i:
        return stdin.readline().strip()
    else:
        return default

class _Getch:
    """Gets a single character from standard input.  Does not echo to the screen."""
    def __init__(self):
        try:
            self.impl = _GetchWindows()
        except ImportError:
            self.impl = _GetchUnix()
    def __call__(self): return self.impl()
class _GetchUnix:
    def __init__(self):
        import tty, sys
    def __call__(self):
        import sys, tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch
class _GetchWindows:
    def __init__(self):
        import msvcrt
    def __call__(self):
        import msvcrt
        return msvcrt.getch()
#getch=_Getch()

if __name__=='__main__':
    pass

