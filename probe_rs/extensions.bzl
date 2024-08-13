"""Extensions for bzlmod."""

load("@rules_probe_rs//probe_rs/private:repositories.bzl", "probe_rs_tools_repositories")

_DEFAULT_NAME = "probe_rs"

probe_rs_tools = tag_class(attrs = {
    "name": attr.string(doc = "Base name for generated repositories", default = _DEFAULT_NAME),
    "version": attr.string(doc = "Explicit version of probe_rs_tools.", mandatory = True),
    "archives": attr.string_list_dict(doc = "Optional archives for probe_rs_tools."),
})

def _probe_rs_extension(module_ctx):
    registrations = {}
    modules = {}

    # Module resolution
    for mod in module_ctx.modules:
        for module in mod.tags.tools:
            if module.name != _DEFAULT_NAME and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the probe_rs_tools module.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if module.name not in registrations.keys():
                registrations[module.name] = []
            registrations[module.name].append(module.version)
            modules[module.version] = module

    # Version resolution
    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: probe_rs_tools module {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        probe_rs_tools_repositories(
            name = name,
            version = selected,
            archives = modules[selected].archives,
        )

probe_rs = module_extension(
    implementation = _probe_rs_extension,
    tag_classes = {"tools": probe_rs_tools},
)
