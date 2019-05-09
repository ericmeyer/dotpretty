[![Build Status](https://travis-ci.org/ericmeyer/dotpretty.svg?branch=master)](https://travis-ci.org/ericmeyer/dotpretty)

# Dotpretty

Dotpretty is a gem designed to clean up the output of `dotnet`. It works by piping the output of `dotnet` into `dotpretty`.

## Installation

`gem install dotpretty`

## Usage

### Example Usages

Here is an example of the basic usage for `dotpretty`.

`dotnet test -v=normal Test.Project/ | dotpretty`

Ordinarily, you will probably want to suppress stderr output.

`dotnet test -v=normal Test.Project/ 2>&1 | dotpretty`

### Command Options

| Flag | Use | Default | Values |
|------|-----|---------|--------|
|`-h`, `--help`| Display this help | | |
|`-r`, `--reporter`| Reporter to use to format output | basic | basic, json |

## Development

### System Requirements

 * Ruby
    * See `.ruby-version` file for specific version

### Setup

1. Fork repository (if needed)
2. Clone repository
3. `bundle install`

### Tests

 * `rake spec` runs unit tests followed by acceptance tests
 * `bundle exec guard` starts a watcher to re-run tests
