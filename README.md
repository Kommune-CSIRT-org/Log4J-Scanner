# Log4J-Scanner
Log4J Scanning tools for detection of use of Log4J or JNDILookup on local use on Windows and Linux.

It consistst of four different scanners for both Linux and Windows and is based on Helse-Certs previous work as displayed on 
[HelseCERT GitHub CVE-2021-44228](https://github.com/helsecert/CVE-2021-44228)

HelseCERT also showcases several mitigative methods. 

--------

## Tool descriptions
### Ansible
This contains an Ansible playbook and role for Linux OS and runs two scripts then fetches the output which they created in the `/tmp` directory.
These scripts are the same as resides in the **Bash** folder.



### Powershell
This powershell script has to be run with Administrator privileges. 

It scans either provided directories or all local and mapped drives.  Then it will try and find all files on the drive with extension `.jar`, `.java` and `.class`.  For each file it will try and find a `jar` file which contains the string *"JndiLookup.class"*, and `java` or `class` file with *"jndi* or *"log4j"* in the filename.

The PowerShell script is tested on Windows 11 with PowerShell version 5.1.22000.282.

Run the powershell script either with parameters or without.
Without parameters:
- `.\windowsSearch.ps1`
- Tries to scan all drives and saves output to `C:\Windows\Temp\`

With parameters:
- `.\windowsSearch.ps1 -Location "ABSOLUTE PATH","ABSOLUTE PATH","ABSOLUTE PATH"`
- The `-Location` parameter takes an array of strings containing absolute paths to root folder for scanning.



### Bash
These linux scripts looks only for the existence of `.jar` files named Log4J

#### linuxLSOFScan.sh
This scripts lists all opened files and writes the list to a temp file "`/tmp/kcsirtLSOFScan.txt`" which can be reviewed for entries of Log4J or the JNDI lookup class manually.
The command has to be run with sudo privileges in order to list all files.

#### linuxFindScan.sh
This script utilises find which lists all files from the root directory and onwards witch matches the "-name" parameter.
The name parameter checks the filename for matching "log4j" and the file extension ".jar"

For each file it will unzip the content of the `.jar` file, extract all text strings, and select the strings which starts with `Implementation-Version: ` in order to show the version number of the JAR file.

All data is written to a temp file which can be extracted and reviewed for analysis, `/tmp/kcsirtFindScan.txt`.

The command has to be run with sudo privileges in order to list all files.




### Python
Python program which performs the same task as the "windowsSearch.ps1" powershell script, but does not look inside packaged JAR files. It is written in Python3 and tested on v3.10.1 and 3.8.

It can be run with and without arguments.  Without arguments, `python ./main.py`, is will scan `C:` or `/` dependent on OS.
It can be supplied with a set of arguments, eg. `python ./main.py "ABSOLUTE PATH" "ABSOLUTE PATH"` where each argument is a path to the root of a folder you want to scan.  In order to ensure access, it has to be run with sudo.

The log is written to `C:\Windows\Temp\kcsirtLog4jPythonScanner.log` or `/tmp/kcsirt/Log4jPythonScanner.log`.
