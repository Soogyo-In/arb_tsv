# arb_tsv

This package provides conversion between arb files and tsv files and merging arb files for easy internationalization. Arb file is output of [intl_translation](https://pub.dev/packages/intl_translation) package from [Dart](https://dart.dev/) and tsv file is for spread sheet apps like [Google Sheets](https://www.google.com/sheets/about/).

## Convert arb to tsv

When you have arb files to translate and it's uncomfortable to do with text editor. Convert arb to tsv and use tsv file for spread sheet app.

``` 
Usage: arb2tsv [path of arb file or directory containing arb files] [options]
-o, --output-dir=<output directory>    Set output directory for generated tsv file. Create directory if given directory is not exists
                                       (defaults to ".")
```

## Convert tsv to arb

After translation with spread sheet app. Export tsv file from spread sheet app and convert it to arb file for use in your app.

```
Usage: tsv2arb [path of tsv file or directory containing tsv files] [options]
-o, --output-dir=<output directory>    Set output directory for generated arb file. Create directory if given directory is not exists
                                       (defaults to ".")
```

## Merge arb files

Merge multiple target arb files with one source arb file without overwrite but appends new messages.

```
Usage: merge_arbs [source arb file path] [merge target arb file paths]
```