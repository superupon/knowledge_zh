# Write basic CShell Scripts

## Control Structure
### if-else
```csh
if (expression) then
endif
```

## Alias
For tcsh, alias can be a function. It can **accept parameters** passed to it.

For example,
in one file, `alias.sh`, you can define an alias
```csh
alias lst 'ls -l \!:1'
```
And in another file, `test.sh`, you can 
```csh
source alias.sh
lst test_dir
```

## Passing Value from variable to variable
```csh
set v1="test file"
set v2="$v1"
```

> [!NOTE]
> Please be attention that the "" should be added to second statement, otherwise you will lose "file" for `v2`.

## String Compare
- `==` equal returns true
- `!=` not equal returns true
- `=~` regex pattern equal
- `!~` regex pattern not equal

## File Test
- `-e` File exist
- `-r` can be read
- `-w` can be written
- `-x` can be executed
- `-d` is directory
- `-f` nomal file
- `-0` is owner
- `-z` is file content empty
