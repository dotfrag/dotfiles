# Fonts

## Iosevka

Default: The default variant with ligatures. Various symbols, like arrows and
geometric, are wide (2-column).

Terminal ("Term")：A narrower variant focusing terminal uses. Arrows and
geometric symbols will be narrow to follow typical terminal usages.

Fixed: Exact monospace font without ligatures and wide glyphs. Since some
environments cannot interpret Iosevka or Iosevka Term as monospace, and have
difficulties with ligatures included, you can use Iosevka Fixed as an
alternative.

<https://github.com/be5invis/Iosevka/blob/main/doc/PACKAGE-LIST.md>

## Nerd Fonts

Nerd Font Mono (a strictly monospaced variant, created with --mono)

Nerd Font (a somehow monospaced variant, maybe)

Nerd Font Propo (a not monospaced variant, created with --variable-width-glyphs)

<https://github.com/ryanoasis/nerd-fonts/discussions/1103>

## Useful commands

```shell
fc-cache -vrf
```

```shell
fc-list
fc-list : family
fc-list : family spacing outline scalable
```

```shell
fc-match 'Iosevka SS08'

fc-match 'Iosevka SS08:weight=bold'
fc-match 'Iosevka SS08:weight=medium'
fc-match 'Iosevka SS08:weight=medium:size=14'

fc-match --verbose IosevkaSS08
fc-match --verbose 'IosevkaSS08 Nerd Font'

fc-match --format='%{charset}\n' "Symbols Nerd Font Mono"
```

```shell
fc-scan --format "%{fullname[$(( $(sed -E 's/^(.*)en.*/\1/;s/[^,]//g' <<<"$(fc-scan --format "%{fullnamelang}\n" IosevkaSS08NerdFont-Bold.ttf)" | wc -c) -1 ))]}\n" IosevkaSS08NerdFont-Bold.ttf
```

## Resources

<https://github.com/be5invis/Iosevka>\
<https://github.com/ryanoasis/nerd-fonts>\
<https://github.com/be5invis/Iosevka/blob/main/doc/PACKAGE-LIST.md>\
<https://github.com/ryanoasis/nerd-fonts/wiki/ScriptOptions>\
<https://github.com/ryanoasis/nerd-fonts/discussions/1103>
<https://github.com/polybar/polybar/issues/991>
