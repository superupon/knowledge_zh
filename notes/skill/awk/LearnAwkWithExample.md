# Learn awk with Example

## Types of awk

* AWK − Original AWK from AT & T Laboratory.
* NAWK − Newer and improved version of AWK from AT & T Laboratory.
* GAWK − It is GNU AWK. All GNU/Linux distributions ship GAWK. It is fully compatible with AWK and NAWK.

## Typical Uses of AWK

Myriad of tasks can be done with AWK. Listed below are just a few of them −

* Text processing,
* Producing **formatted** text reports,
* Performing **arithmetic** operations,
* Performing **string** operations, and many more.

## awk command format

```bash
awk [ -u ] [ -F Ere ] [ -v Assignment ] ... { -f ProgramFile | 'Program' } [ [ File ... | Assignment ... ] ] ...
```

## Fields

Awk is good ad handling text that has been broken into multiple logical fields.
Example:

```bash
awk -F ":" '{print $1}' /etc/passwd
```

$1 stands for the first field separated.

## External Scripts

```bash
awk ‑f myscript.awk myfile.in
```

myscript.awk

```awk
BEGIN { 
        FS=":" 
} 
{ print $1 }
```

It's generally best to set the `FS` inside the script itself, because it means you have one less command line argument to remember to type.

## BEGIN and END blocks
