#!/bin/bash

cd "$(git rev-parse --show-toplevel)" || exit

git-filter-repo --invert-paths --path-glob 'fonts/*.ttf'
