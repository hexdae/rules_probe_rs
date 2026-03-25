"""Executable rule for running probe-rs against an ELF built for another platform."""

def _quote_shell(arg):
    return "'" + arg.replace("'", "'\"'\"'") + "'"

def _quote_batch(arg):
    escaped = arg.replace("^", "^^")
    escaped = escaped.replace("\"", "\"\"")
    return "\"" + escaped + "\""

def _probe_rs_run_impl(ctx):
    elf = ctx.file.elf
    # probe-rs is a host tool even when the ELF was built for an embedded target.
    tool = ctx.executable.probe_rs
    is_windows = tool.basename.endswith(".exe")
    script_name = ctx.label.name + (".bat" if is_windows else ".sh")
    launcher = ctx.actions.declare_file(script_name)

    args = ["run", "--chip", ctx.attr.chip, elf.short_path] + ctx.attr.probe_rs_args

    # Emit a tiny launcher so `bazel run` executes probe-rs from runfiles while
    # still allowing the ELF input to stay in the target configuration.
    if is_windows:
        script = "\r\n".join([
            "@echo off",
            "setlocal",
            "{} {}".format(_quote_batch(tool.short_path), " ".join([_quote_batch(arg) for arg in args])),
            "exit /b %ERRORLEVEL%",
            "",
        ])
    else:
        script = "\n".join([
            "#!/usr/bin/env bash",
            "set -euo pipefail",
            "{} {}".format(_quote_shell(tool.short_path), " ".join([_quote_shell(arg) for arg in args])),
            "",
        ])

    ctx.actions.write(launcher, script, is_executable = True)

    # Keep both the ELF and the host tool in runfiles so the launcher can refer
    # to them by short_path on every supported host platform.
    runfiles = ctx.runfiles(files = [elf, tool])
    runfiles = runfiles.merge(ctx.attr.elf[DefaultInfo].default_runfiles)
    runfiles = runfiles.merge(ctx.attr.probe_rs[DefaultInfo].default_runfiles)

    return [DefaultInfo(executable = launcher, runfiles = runfiles)]

probe_rs_run = rule(
    implementation = _probe_rs_run_impl,
    executable = True,
    attrs = {
        "elf": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "chip": attr.string(mandatory = True),
        "probe_rs_args": attr.string_list(),
        "probe_rs": attr.label(
            executable = True,
            # Resolve probe-rs for the execution platform rather than the ELF's
            # target platform so cross-target flashing works correctly.
            cfg = "exec",
        ),
    },
)
