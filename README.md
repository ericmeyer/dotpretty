# Dotpretty

[![Build Status](https://travis-ci.org/ericmeyer/dotpretty.svg?branch=master)](https://travis-ci.org/ericmeyer/dotpretty)

## Usage

`dotnet test -v=normal Test.Project/ | dotpretty`

In order to suppress stderr output:

`dotnet test -v=normal Test.Project/ 2>&1 | dotpretty`
