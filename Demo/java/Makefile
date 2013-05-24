################################################################################
### Demo/java/Makefile
################################################################################

### Java compilation options
# JAVAC  : Java Compilator
# JFLAGS : Extra compilation flags
# HEADER : File which contains the format of the packet
# INCLUDE: Additional directories
# SOURCES: Java source files
###
JAVAC      = javac
JFLAGS    += -g
HEADER     = ../report_message.h
INCLUDE    = $(TOSDIR)/chips/cc2420
SOURCES    = Demo.java \
             ReportMsg.java

all: Demo.class

# Byte code for Demo
Demo.class: $(SOURCES)
	$(JAVAC) $(JFLAGS) -cp $(CLASSPATH) $^

# Byte code for ReportMsg
ReportMsg.class: ReportMsg.java
	$(JAVAC) $(JFLAGS) $<

### ReportMsg.java
# Use mig tool to generate ReportMsg.java
###
ReportMsg.java: $(HEADER)
	mig java -target=null -java-classname=ReportMsg $< ReportMsg -o $@ -I $(INCLUDE)

### Clean
# Delete automatically generated files and backups
###
clean:
	rm -rf *~ *.class ReportMsg.java output.dat

