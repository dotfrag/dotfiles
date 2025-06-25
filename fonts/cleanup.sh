#!/bin/bash

if git_root=$(git rev-parse --show-toplevel); then
  cd "${git_root}" || exit
else
  exit 1
fi

remote=$(git remote -v | awk '{print $2}' | sort -u)
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
