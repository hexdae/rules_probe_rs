"""Extensions for bzlmod.

Installs a probe_rs_tools toolchain.
Every module can define a toolchain version under the default name, "probe_rs_tools".
The latest of those versions will be selected (the rest discarded),
and will always be registered by probe_rs_tools.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load(":repositories.bzl", "probe_rs_tools_register_toolchains")

_DEFAULT_NAME = "probe_rs_tools"

probe_rs_tools_toolchain = tag_class(attrs = {
    "name": attr.string(doc = """\
Base name for generated repositories, allowing more than one probe_rs_tools toolchain to be registered.
Overriding the default is only permitted in the root module.
""", default = _DEFAULT_NAME),
    "probe_rs_tools_version": attr.string(doc = "Explicit version of probe_rs_tools.", mandatory = True),
})

def _toolchain_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != _DEFAULT_NAME and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the probe_rs_tools toolchain.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(toolchain.probe_rs_tools_version)
    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: probe_rs_tools toolchain {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        probe_rs_tools_register_toolchains(
            name = name,
            probe_rs_tools_version = selected,
            register = False,
        )

probe_rs_tools = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {"toolchain": probe_rs_tools_toolchain},
)
