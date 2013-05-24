
Demo/java/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* Makefile
* Demo.java

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
Run this application the same way as for PrintfClient except this application
uses */dev/ttyUSB0* as default source.

`java Demo [-comm <source>]`

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

