load("@bazel_skylib//rules:native_binary.bzl", "native_binary")

package(default_visibility = ["//visibility:public"])

PLATFORMS = %platforms%
[
    config_setting(
        name = platform,
        constraint_values = constraint_values,
    )
    for platform, constraint_values in PLATFORMS.items()
]

TOOLS = %tools%
[
    native_binary(
        name = tool,
        src = select({
            platform: "@{}//:{}".format(platform, tool)
            for platform in PLATFORMS.keys()
        }),
        out = tool,
        target_compatible_with = select({
            platform: constraint_values
            for platform, constraint_values in PLATFORMS.items()
        } | {
            "//conditions:default": ["@platforms//:incompatible"],
        }),
    )
    for tool in TOOLS
]