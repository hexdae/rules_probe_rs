"Public API re-exports"

load("@bazel_skylib//rules:native_binary.bzl", "native_binary")

def _probe_rs_run(name, elf, chip, args = [], **kwargs):
    """Run probe-rs on the given ELF file.

    Args:
        name: The name of the rule.
        elf: The ELF file to run probe-rs on.
        chip: probe-rs chip to use. Ex. "nRF52840_xxAA"
        args: Additional arguments to pass to probe-rs.
        **kwargs: Additional arguments to pass to native_binary.
    """

    native_binary(
        name = name,
        src = "@probe_rs//:probe-rs",
        data = [elf],
        args = ["run", "--chip", chip, "$(locations {})".format(elf)] + args,
        **kwargs
    )

probe_rs = struct(
    run = _probe_rs_run,
)
