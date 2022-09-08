#!/usr/bin/env python3

# https://stackoverflow.com/a/5839291

from subprocess import call

import pkg_resources

packages = [dist.project_name for dist in pkg_resources.working_set]
call("pip install --upgrade " + " ".join(packages), shell=True)
