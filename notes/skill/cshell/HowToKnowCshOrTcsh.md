To determine which shell you're currently using, especially if you're trying to differentiate between `csh` and `tcsh`, you can use several methods:

1. **Using the `echo` Command**:
   By checking the value of the `SHELL` environment variable, you can usually identify your default shell. However, note that this method displays the default shell, not necessarily the currently running instance.
   ```bash
   echo $SHELL
   ```

2. **Using the `ps` Command**:
   This command will show you the currently running processes for your terminal session, which includes your active shell.
   ```bash
   ps -p $$
   ```
   The output will give you details about your current shell's process. Look under the "COMMAND" column to identify the shell.

3. **Checking the Shell Version**:
   Both `csh` and `tcsh` support the `version` command, but their outputs differ, which can help you distinguish between them.
   ```bash
   version
   ```
   - If you're using `csh`, this might not provide detailed version information.
   - If you're using `tcsh`, this will provide more comprehensive version details.

4. **Using Special Variables**:
   The `tcsh` shell defines a variable `$tcsh`, which is not present in `csh`.
   ```bash
   echo $tcsh
   ```
   If you get an output (likely the `tcsh` version), then you're using `tcsh`. If the variable is undefined or you get an error, you might be using `csh` or another shell.

5. **Checking the Login Message**:
   When you start a new session of `csh` or `tcsh`, the shell might display a message indicating its type and version. However, this method isn't always reliable, as the message can be suppressed or customized.

It's worth noting that the methods above can be used in a variety of shells, not just `csh` and `tcsh`. The key is to identify the unique characteristics or outputs of the shell in question.