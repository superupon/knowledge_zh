# How to call one shell script from another shell script?
There are a couple of different ways you can do this:

1. **Make the other script executable** with chmod a+x /path/to/file(Nathan Lilienthal's comment), add the #!/bin/bash line (called shebang) at the top, and the path where the file is to the $PATH environment variable. Then you can call it as a normal command;

2. Or **call it with the source command** (which is an alias for .), like this:

```
source /path/to/script
```
3. Or **use the bash command to execute it**, like:
```
/bin/bash /path/to/script
```
The first and third approaches execute the script as another process, so variables and functions in the other script will not be accessible.
**The second approach executes the script in the first script's process, and pulls in variables and functions from the other script** (so they are usable from the calling script). It will of course run all the commands in the other script, not only set variables.

In the second method, if you are using `exit` in second script, it will exit the first script as well. Which will not happen in first and third methods.

# Original Link
https://stackoverflow.com/questions/8352851/shell-how-to-call-one-shell-script-from-another-shell-script
