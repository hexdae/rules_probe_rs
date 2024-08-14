# Rust ❤️ Bazel -> rules_probe_rs

<p align="center">

<a href="https://github.com/hexdae/rules_probe_rs/blob/master/LICENSE">
    <img alt="GitHub license" src="https://img.shields.io/github/license/hexdae/rules_probe_rs?color=success">
</a>

<a href="https://github.com/hexdae/rules_probe_rs/stargazers">
    <img alt="GitHub stars" src="https://img.shields.io/github/stars/hexdae/rules_probe_rs?color=success">
</a>

<a href="https://github.com/hexdae/rules_probe_rs/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/hexdae/rules_probe_rs">
</a>

</p>

<p align="center">

<img src="https://probe.rs/images/banner.svg" width="100px"/>
<img src="https://blog.bazel.build/images/bazel-icon.svg" width="100px"/>

</p>

The goal of the project is to add a simple way to run probe-rs from bazel, similar to cargo embed for the rust ecosystem.

If this project was useful to you, give it a ⭐️ and I'll keep improving it!

## Features

- [MODULE support](#bzlmod)
- [Examples](./examples)
- Remote execution support
- Linux, MacOS, Windows

## Installation

For official releases you can use:
<https://github.com/hexdae/rules_probe_rs/releases>

## Bzlmod

```python
bazel_dep(name = "rules_probe_rs", version = "<version>")

probe_rs = use_extension("@rules_probe_rs//:extensions.bzl", "probe_rs")

probe_rs.tools(
    version = "0.24.0",
)
use_repo(probe_rs, "probe_rs")
```
