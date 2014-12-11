#!/usr/bin/env python2
# -*- coding: utf8 -*-

####  logging and inspect  #####################################################

def setup_logging(filename=None, lvl=None):
    """setup logging to a file + console"""
    import logging
    lvl = logging.DEBUG if lvl is None else lvl

    if filename is not None:
        logging.basicConfig(level=logging.DEBUG,
                            format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                            datefmt='%m-%d %H:%M',
                            filename=filename,
                            filemode='w')
    console = logging.StreamHandler()
    console.setLevel(lvl)
    console.setFormatter(logging.Formatter('%(message)s'))
    logging.getLogger('').addHandler(console)
    return logging.getLogger('')




####  data processing  #########################################################

def key_natural(key):
    """key to sort strings with embedded numbers"""
    # adapted from: http://stackoverflow.com/a/2669120
    def to_float(s):
        try:
            return float(s)
        except ValueError:
            return s

    from re import split
    return [to_float(s) for s in split(r'((?:\+|-)?[0-9.]+)', key)]

class DotDict(dict):
    """dict with "." access to elements"""
    # taken from: http://stackoverflow.com/a/224876
    # see also: http://www.rafekettler.com/magicmethods.html and also
    __getattr__= dict.__getitem__
    __setattr__= dict.__setitem__
    __delattr__= dict.__delitem__




####  shell  ###################################################################

def execute(command):
    """execute command in current directory"""
    from subprocess import Popen, PIPE
    p = Popen([command], shell=True, stdout=PIPE, stderr=PIPE)
    stdout, stderr = p.communicate()
    return stdout, stderr, p.returncode

def execute_realtime(command, choke=True):
    """execute command in current directory, yielding stdout + stderr in real time

    choke = whether to choke on non-zero return code
    """
    try:
        from pexpect import spawn, EOF
        child = spawn(command)
        while True:
            try:
                child.expect('\n', timeout=None) # http://www.noah.org/wiki/pexpect#Exceptions
                yield child.before
            except EOF:
                break
        child.close()
        code = child.exitstatus

    except ImportError:
        from subprocess import Popen, PIPE, STDOUT
        p = Popen([command], shell=True, stdout=PIPE, stderr=STDOUT)
        for line in iter(p.stdout.readline, ''):
            yield line.rstrip()
        code = p.wait()

    if choke:
        assert code == 0, code

def mkdir(path):
    """emulate 'mkdir -p', no error if existing, make parent directories as needed"""
    import errno
    try:
        os.makedirs(path)
    except OSError as e: # Python >2.5
        if e.errno == errno.EEXIST:
            pass
        else:
            raise

################################################################################


if __name__ == '__main__':
    pass
