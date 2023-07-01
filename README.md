# Kino.IconvAll.Git

This is a [Kino](https://github.com/livebook-dev/kino)-based user interface for
[Livebook](https://livebook.dev/) that lets you configure and perform conversion
of character encoding using iconv. It is a wrapper around
[iconv_all](https://github.com/akirak/iconv_all), which converts all files
matching a glob pattern in a Git repository. It is intended for helping with
interactive analysis of code base in a legacy encoding.

See [an example livebook](./sample.livemd) for usage.

## Installation

The library is not available on Hex yet, so you can install from GitHub instead:

```elixir
Mix.install([
  {:kino_iconv_all_git, github: "akirak/kino_iconv_all"}
])
```
