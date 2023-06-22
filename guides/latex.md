# LaTeX

## TeX Live installation (native)

```shell
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
zcat < install-tl-unx.tar.gz | tar xf -
cd install-tl-*
sudo perl install-tl --init-from-profile texlive.profile -select-repository
```

> Finally, prepend /usr/local/texlive/YYYY/bin/PLATFORM to your PATH,
> e.g., /usr/local/texlive/2023/bin/x86_64-linux

<details><summary>texlive.profile</summary>

```text
# texlive.profile written on Wed Jun 21 16:54:43 2023 UTC
# It will NOT be updated and reflects only the
# installation profile at installation time.
selected_scheme scheme-custom
TEXDIR /usr/local/texlive/2023
TEXMFCONFIG ~/.config/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /usr/local/texlive/texmf-local
TEXMFSYSCONFIG /usr/local/texlive/2023/texmf-config
TEXMFSYSVAR /usr/local/texlive/2023/texmf-var
TEXMFVAR ~/.cache/texmf-var
binary_x86_64-linux 1
collection-basic 1
collection-bibtexextra 1
collection-binextra 1
collection-context 1
collection-fontsextra 1
collection-fontsrecommended 1
collection-fontutils 1
collection-formatsextra 1
collection-humanities 1
collection-langenglish 1
collection-langgreek 1
collection-latex 1
collection-latexextra 1
collection-latexrecommended 1
collection-luatex 1
collection-metapost 1
collection-pictures 1
collection-plaingeneric 1
collection-pstricks 1
collection-publishers 1
collection-xetex 1
instopt_adjustpath 0
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 1
tlpdbopt_install_srcfiles 1
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/share/info
tlpdbopt_sys_man /usr/local/share/man
tlpdbopt_w32_multi_user 1
```

</details>

<https://tug.org/texlive/quickinstall.html>

### Dependencies

Possible dependencies in case formatting fails:

```shell
sudo pacman -S perl-yaml-tiny perl-file-homedir
```

[perl-yaml-tiny](https://archlinux.org/packages/extra/any/perl-yaml-tiny/),
[perl-file-homedir](https://archlinux.org/packages/extra/any/perl-file-homedir/)

### Symlinks

**It is highly preferred to add the path manually (see install script above).**

```shell
tlmgr path add
```

```shell
tlmgr option sys_bin
tlmgr option sys_man
tlmgr option sys_info
```

<https://tex.stackexchange.com/a/500732>

### Uninstall

Remove path (symlinks) using `tlmgr path remove` and delete all the files manually or:

```shell
sudo tlmgr remove --all
```

<https://tex.stackexchange.com/a/543893>, <https://tex.stackexchange.com/a/95502>

## Commands

```shell
tlmgr update --all
```

> Once a year, when there's a new TeX Live release, `tlmgr update --all` will fail and it will be necessary to install TeX Live anew.
