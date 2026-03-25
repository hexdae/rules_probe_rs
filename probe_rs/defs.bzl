"Public API re-exports"

load("//probe_rs/private:run.bzl", "probe_rs_run")

def _probe_rs_run(name, elf, chip, args = [], **kwargs):
    """Run probe-rs on the given ELF file.

    Args:
        name: The name of the rule.
        elf: The ELF file to run probe-rs on.
        chip: probe-rs chip to use. Ex. "nRF52840_xxAA"
        args: Additional arguments to pass to probe-rs.
        **kwargs: Additional arguments to pass to native_binary.
    """

    probe_rs_run(
        name = name,
        elf = elf,
        chip = chip,
        probe_rs = "@probe_rs//:probe-rs",
        probe_rs_args = args,
        **kwargs
    )

probe_rs = struct(
    run = _probe_rs_run,
)
