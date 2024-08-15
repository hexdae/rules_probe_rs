"""repositories.bzl"""

load("@rules_probe_rs//probe_rs/private:repositories.bzl", "probe_rs_tools_repositories")

def probe_rs_dependencies(name = "probe-rs", version = "0.24.0", tools = ["probe-rs"], archives = None):
    """Defines the probe-rs tool repositories for WORKSPACE."""
    probe_rs_tools_repositories(
        name = name,
        version = version,
        tools = tools,
        archives = archives,
    )
