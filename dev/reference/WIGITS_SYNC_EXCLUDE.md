# WiGiTS S3 Sync Excludes

Trailing `--exclude` globs applied after the schema-derived includes
when syncing a WiGiTS run (see
[`s3sync()`](https://tidywf.github.io/tidywigits/dev/reference/s3sync.md)).
`aws s3 sync` filters are ordered and last-match wins, so these carve
files back out of the includes.

## Usage

``` r
WIGITS_SYNC_EXCLUDE
```

## Format

An object of class `character` of length 7.
