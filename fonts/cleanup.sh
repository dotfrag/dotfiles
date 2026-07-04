#!/bin/bash

cd "$(git rev-parse --show-toplevel)" || exit

remote=$(git remote get-url origin)
echo "Current remote: ${remote}"
echo

tmp_dir=/tmp/fonts-cleanup

mkdir -p "${tmp_dir}"
git ls-files fonts/*.ttf | xargs cp -t "${tmp_dir}"

if ! git-filter-repo --invert-paths --path-glob 'fonts/*.ttf'; then
  echo
  echo "Something went wrong."
  exit 1
fi

cp "${tmp_dir}"/* ./fonts/

echo
echo "Looking good. Double check and push:"
echo "git remote add origin ${remote}"
echo "git push -fu origin main"
