# CMD

## date
### How to output date as you want
Usage: date [option] [+format]
format controls output
%% -> %
%a -> weekday name (eg, Sun)
%m -> month (eg, 01..12)
%d -> day of month (eg, 01)

#### Example
```
date "+%m%d"
0908
```
Please use --help to see more information

## diff
diff command can diff two different directories.

### Example
diff -bur folder1/ folder2/
* b -> ignore whitespace
* u -> unified context
* r -> recursive

## xterm 
We can pass in a lot of parameters to it to get better default window.
For instance,
```bash
xterm -sl 20000 -fg lightgreen -bg block -cr red -fn 9x15 -maxmized
```
It's very good for your eyes 😄

## repeat
repeat cnt command

