#!/bin/bash

if ! git_root=$(git rev-parse --show-toplevel); then
  exit 1
fi

cd "${git_root}" || exit

remote=$(git remote get-url origin)
echo "Current remote: ${remote}"
echo

if ! git-filter-repo --invert-paths --path-glob 'fonts/*.ttf'; then
  echo
  echo "Something went wrong."
  exit 1
fi

echo
echo "Looking good. Double check and push:"
echo "git remote add origin ${remote}"
echo "git push -fu origin main "
