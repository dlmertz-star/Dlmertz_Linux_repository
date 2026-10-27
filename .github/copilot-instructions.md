# Copilot instructions

## Validation commands

This repository has no package manager, build system, automated test suite, or configured linter. The scripts are Bash utilities, so use the following focused checks:

```bash
# Check one script
bash -n ./disk_monitor_transferable.sh

# Check every shell script
for file in ./*.sh; do bash -n "$file" || exit 1; done
```

There is no project-defined single-test command. When changing a monitor, run `bash -n` on that script and inspect the generated log/alert behavior with a controlled `df` or `sensors` fixture rather than relying on the host's live hardware.

## Architecture

- The disk-monitor family is composed of a monitor, a shell configuration file, and `disk_alert.sh`. A monitor sources `disk_monitor.conf`, identifies `/dev/*` filesystems from `df`, compares usage against `DM_THRESHOLD`, and invokes the alert helper; the helper appends an ISO-8601 timestamp, filesystem, and percentage to `DM_LOGFILE`.
- `disk_monitor.sh`, `disk_monitor_outputVersion.sh`, and `disk_monitor_transferable.sh` are alternative `df` parsing implementations, not separate services. The transferable version uses `df -P` plus `awk` to locate the filesystem and capacity columns; the output-version variant depends on `df --output`; the basic version uses human-readable `df -h`.
- Scripts resolve `SCRIPT_DIR` from `BASH_SOURCE[0]` and use it to source colocated configuration and invoke alert scripts, so do not replace these paths with the caller's working directory.
- The sensors side is not yet wired into a working monitor: `sensors_monitor.sh` and `sensors_alert.sh` are stubs, and they currently source `sensors_monitor.config`, while the checked-in configuration file is named `sensors_monitor.conf`. Treat changes there as completion of an unfinished feature, not as an established runtime pattern.

## Repository-specific conventions

- Configuration files are shell fragments sourced directly by the scripts. Disk settings are `DM_THRESHOLD` and `DM_LOGFILE`; preserve these variable names and keep paths configurable rather than hard-coding log locations.
- Disk alerts are append-only plain-text log lines in the form `timestamp filesystem percentage`. Changes to parsing should preserve the alert helper's two-argument interface (`filesystem`, then percentage including `%` where the caller supplies it).
- Filesystem monitoring intentionally filters to device-backed paths beginning with `/dev/`; do not silently broaden this to every `df` row.
- Keep the three disk monitor variants behaviorally aligned when modifying thresholding or alert invocation. Portability-sensitive logic belongs in `disk_monitor_transferable.sh`; GNU-specific `df` features belong only in the output-version variant.
- Preserve the existing script-local path pattern and Bash shebang style when adding helpers. Configuration is loaded before monitor-specific variables are initialized.
