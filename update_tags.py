#!/usr/bin/python
import os
import sys
import subprocess
import shlex


def foo():
    pass


def run_command(command):
    tokenized_command = shlex.split(command)

    p = subprocess.Popen(tokenized_command,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)

    stdout = p.stdout.read()
    return stdout.rstrip()

stdout = run_command('git rev-parse --git-dir')

if not stdout:
    sys.exit(1)

temp_tags = "{}/tags.temp".format(stdout)
tags = "{}/tags".format(stdout)

# os.remove(temp_tags)

ctags_command = "ctags -R -o {} {}".format(temp_tags, stdout + '/..')
stdout = run_command(ctags_command)

os.rename(temp_tags, tags)
