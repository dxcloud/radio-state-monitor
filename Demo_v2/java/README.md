
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
This application is a revision of the previous Demo application.
A BaseStation must be connected to the PC.
Each time a report packet is received the application will display the packet
value on the screen. It generates also an output file.
The output format is the same as the report packet with a timestamp at the
end of the packet.

A Makefile is provided to simplify the compilation.

### Compilation
The environment variable **CLASSPATH** must at least contain the value
*$(TOSROOT)/support/sdk/java/tinyos.jar*.
For a simple compilation, type `make`.
3 files should be generated:
* *ReportMsg.java*
* *ReportMsg.class*
* *Demo.class*.

### Run
Run this application the same way as for PrintfClient. If the source is not
specified, */dev/ttyUSB0* will be used as the default source.

`java Demo [-comm <source>]`

An output file will be generate by this application with *.dat* extension. This
file contains the some values as printed on the terminal.

The application is now able to check the current date of the system. A new
output file will be generated every day after 00:00:00.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

