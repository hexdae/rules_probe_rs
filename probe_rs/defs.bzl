"Public API re-exports"

def _probe_rs_run(name, elf, chip, **kwargs):
    """Run probe-rs on the given ELF file."""

    native.sh_binary(
        name = name,
        srcs = ["@probe_rs//:probe-rs"],
        data = [elf],
        args = ["run", "--chip", chip, "$(locations {})".format(elf)],
        **kwargs
    )

probe_rs = struct(
    run = _probe_rs_run,
)
