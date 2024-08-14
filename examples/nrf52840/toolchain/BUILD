load("@arm_none_eabi//toolchain:toolchain.bzl", "arm_none_eabi_toolchain")

# NRF52840 toolchain
arm_none_eabi_toolchain(
    name = "nrf52840_toolchain",
    linkopts = [
        "-O3",
        "-g3",
        "-mthumb",
        "-mabi=aapcs",
        "-mcpu=cortex-m4",
        "-mfloat-abi=hard",
        "-mfpu=fpv4-sp-d16",
        "-Wl,--gc-sections",
        "--specs=nano.specs",
        "-lc",
        "-lnosys",
        "-lm",
    ],
    target_compatible_with = [
        "@platforms//os:none",
        "@platforms//cpu:armv7e-m",
    ],
)
