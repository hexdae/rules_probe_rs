<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="probe_rs.run"></a>

## probe_rs.run

<pre>
probe_rs.run(<a href="#probe_rs.run-name">name</a>, <a href="#probe_rs.run-elf">elf</a>, <a href="#probe_rs.run-chip">chip</a>, <a href="#probe_rs.run-args">args</a>, <a href="#probe_rs.run-kwargs">kwargs</a>)
</pre>

Run probe-rs on the given ELF file.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="probe_rs.run-name"></a>name |  The name of the rule.   |  none |
| <a id="probe_rs.run-elf"></a>elf |  The ELF file to run probe-rs on.   |  none |
| <a id="probe_rs.run-chip"></a>chip |  probe-rs chip to use. Ex. "nRF52840_xxAA"   |  none |
| <a id="probe_rs.run-args"></a>args |  Additional arguments to pass to probe-rs.   |  <code>[]</code> |
| <a id="probe_rs.run-kwargs"></a>kwargs |  Additional arguments to pass to native_binary.   |  none |


