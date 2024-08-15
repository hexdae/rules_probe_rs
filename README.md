# Rust ❤️ Bazel: rules_probe_rs

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

This project aims to provide a simple way to run probe-rs from bazel, similar to the function `cargo embed` has in the rust ecosystem.

If this project was useful to you, give it a ⭐️ and I'll keep improving it!

## Features

- [MODULE support](#bzlmod)
- [Examples](./examples)
- Remote execution support
- Linux, MacOS, Windows

## Installation

### Official releases (coming soon to BCR)

For official releases you can use:
<https://github.com/hexdae/rules_probe_rs/releases>

### From source (this repository)

```python
bazel_dep(name = "rules_probe_rs", version = "<version>")

git_override(
    module_name = "rules_probe_rs",
    remote = "https://github.com/hexdae/rules_probe_rs.git",
    commit = "<commit>",
)

probe_rs = use_extension("@rules_probe_rs//:extensions.bzl", "probe_rs")
probe_rs.tools(version = "0.24.0",)
use_repo(probe_rs, "probe_rs")
```

## .bazelrc

Add this to your `.bazelrc` to enable RTT symbol generation at build time.

```
build --action_env=DEFMT_LOG="trace"
```
