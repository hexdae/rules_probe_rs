"""Extensions for bzlmod.

Installs a probe_rs_tools toolchain.
Every module can define a toolchain version under the default name, "probe_rs_tools".
The latest of those versions will be selected (the rest discarded),
and will always be registered by probe_rs_tools.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load("@probe_rs_tools//probe_rs_tools/private:repositories.bzl", "probe_rs_tools_repositories")

_DEFAULT_NAME = "probe_rs"

probe_rs_tools = tag_class(attrs = {
    "name": attr.string(doc = "Base name for generated repositories", default = _DEFAULT_NAME),
    "version": attr.string(doc = "Explicit version of probe_rs_tools.", mandatory = True),
})

def _probe_rs_extension(module_ctx):
    registrations = {}

    # Module resolution
    for mod in module_ctx.modules:
        for toolchain in mod.tags.tools:
            if toolchain.name != _DEFAULT_NAME and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the probe_rs_tools toolchain.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(toolchain.version)

    # Version resolution
    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: probe_rs_tools toolchain {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        probe_rs_tools_repositories(
            name = name,
            version = selected,
        )

probe_rs = module_extension(
    implementation = _probe_rs_extension,
    tag_classes = {"tools": probe_rs_tools},
)
