# Bazel rules for probe_rs_tools

## Installation

From the release you wish to use:
<https://github.com/hexdae/probe_rs_tools/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

To use a commit rather than a release, you can point at any SHA of the repo.

For example to use commit `abc123`:

1. Replace `url = "https://github.com/hexdae/probe_rs_tools/releases/download/v0.1.0/probe_rs_tools-v0.1.0.tar.gz"` with a GitHub-provided source archive like `url = "https://github.com/hexdae/probe_rs_tools/archive/abc123.tar.gz"`
1. Replace `strip_prefix = "probe_rs_tools-0.1.0"` with `strip_prefix = "probe_rs_tools-abc123"`
1. Update the `sha256`. The easiest way to do this is to comment out the line, then Bazel will
   print a message with the correct value. Note that GitHub source archives don't have a strong
   guarantee on the sha256 stability, see
   <https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/>
