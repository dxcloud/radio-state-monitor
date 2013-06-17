
Demo/java/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* Makefile
* Demo.java
* plot.sh (added 2013-05-28)
* diagram.gnuplot (added 2013-05-28)

Description
--------------------------------------------------------------------------------
### General description
This application is based on PrintfClient. A BaseStation must be connected to
the PC. Each time a report packet is received the application displays its value
on the screen. It generates also an output file.

A Makefile is provided to simplify the compilation.

### Compilation
Make the environment variable **CLASSPATH** set, it should at least contain the
value *$(TOSROOT)/support/sdk/java/tinyos.jar*.
Type `make` for compilation, 3 files should be generated: *ReportMsg.java*,
*ReportMsg.class* and *Demo.class*.

### Run
Run this application the same way as for PrintfClient. If the source is not
specified, this application will use */dev/ttyUSB0* as default source.

`java Demo [-comm <source>]`

An output file will be generate by the application with *.dat* extension. This
file contains the some values as printed on the terminal.

### Modification
The java application is able to call *plot.sh* script, this script allows to
draw a time diagram.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

