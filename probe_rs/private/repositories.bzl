"""deps.bzl"""

load(":versions.bzl", "PROBE_RS_VERSIONS")

def _probe_rs_tools_archive_repo_impl(repository_ctx):
    """Defines a host-specific repository for the probe-rs tool."""
    bin_extension = ".exe" if "windows" in repository_ctx.name else ""
    tools = [tool + bin_extension for tool in repository_ctx.attr.tools]

    repository_ctx.download_and_extract(
        sha256 = repository_ctx.attr.sha256,
        url = repository_ctx.attr.url,
        stripPrefix = repository_ctx.attr.strip_prefix,
    )

    repository_ctx.template(
        "BUILD.bazel",
        Label(":templates/probe_rs_archive.BUILD.tpl"),
        substitutions = {
            "%tools%": "{}".format(tools),
        },
    )

    for patch in repository_ctx.attr.patches:
        repository_ctx.patch(patch, strip = 1)

probe_rs_tools_archive_repo = repository_rule(
    implementation = _probe_rs_tools_archive_repo_impl,
    attrs = {
        "tools": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "url": attr.string(mandatory = True),
        "strip_prefix": attr.string(),
        "patches": attr.label_list(),
        "exec_compatible_with": attr.string_list(),
    },
)

def _probe_rs_impl(repository_ctx):
    """Defines the probe-rs alias repository."""
    repository_ctx.template(
        "BUILD",
        Label(":templates/probe_rs.BUILD.tpl"),
        substitutions = {
            "%platforms%": "{}".format(repository_ctx.attr.platforms),
            "%tools%": "{}".format(repository_ctx.attr.tools),
        },
    )

probe_rs_repo = repository_rule(
    implementation = _probe_rs_impl,
    attrs = {
        "platforms": attr.string_list_dict(mandatory = True),
        "tools": attr.string_list(mandatory = True),
    },
)

def probe_rs_tools_repositories(name, version, tools = ["probe-rs"], archives = None):
    """Generate probe-rs repositories for the given version and tools.

    Args:
        name: The name of the repository.
        version: The version of the probe-rs tool to use.
        tools: A list of tools to include in the repository.
        archives: A dictionary of version to archive attributes.
    """
    if not archives:
        archives = PROBE_RS_VERSIONS

    archive = archives.get(version)

    if not archive:
        fail("Version {} not available in {}".format(version, archives.keys()))

    probe_rs_repo(
        name = name,
        tools = tools,
        platforms = {
            repo["name"]: repo["exec_compatible_with"]
            for repo in archive
        },
    )

    for attrs in archive:
        probe_rs_tools_archive_repo(
            tools = tools,
            **attrs
        )
