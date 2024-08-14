# NRF52840 bazel rust examples

Show how to use bazel to build rust code for the NRF52840.

## Building

We can cross compile the code to the NRF52840, using `rules_rust` for the compiler (`rustc`) and `toolchains_arm_gnu` for the linker (`arm-none-eabi-gcc`).

```bash
bazel build //blinky/...
```

## Flashing

We use `rules_probe_rs` to flash the code to the NRF52840 and enable optional debugging / RTT.

```bash
bazel run //blinky:probe_rs
```

## Notes

- `build.rs` is included just to show cargo equivalence. It is not used by the bazel build system.
- `memory.x` is used by cargo, but not by bazel.
- `linker.x` file is a linker script used for bazel, this was handwritten to include all the linker scripts that are automatically added to the link path when cargo builds.
