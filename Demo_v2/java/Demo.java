/**
 * @file    Demo/java/Demo.java
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-20
 * @version 1.1
 * @brief   Java application for displaying radio activity report
 * @details Changes:
 *          - Time diagram (png file) generation
 */

import java.io.IOException;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.lang.*;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class Demo implements MessageListener {

  final private String outputFile = "output.dat";
  private MoteIF moteIF;
  private File file;
  private String[] cmd = new String[] {"./plot.sh", outputFile, " "};

  public Demo(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new ReportMsg(), this);
  }

  public void messageReceived(int to, Message message) {
    ReportMsg msg = (ReportMsg) message;

    System.out.println(msg.get_sender() + " "
                      + msg.get_seqno() + " "
                      + msg.getElement_duration_states(0) + " "
                      + msg.getElement_duration_states(1) + " "
                      + msg.getElement_duration_states(2) + " "
                      + msg.getElement_duration_states(3) + " "
                      + msg.getElement_duration_states(4) + " "
                      + System.currentTimeMillis()
                      );

    try {
      FileWriter writer = new FileWriter(file, true);
      PrintWriter printer = new PrintWriter(writer, true);
      printer.println(msg.get_sender() + ": "
                      + msg.get_seqno() + " "
                      + msg.getElement_duration_states(0) + " "
                      + msg.getElement_duration_states(1) + " "
                      + msg.getElement_duration_states(2) + " "
                      + msg.getElement_duration_states(3) + " "
                      + msg.getElement_duration_states(4) + " "
                      + System.currentTimeMillis()
                      );
      printer.close();

/*
 * Uncomment the next two lines to enable the application to execute 'plot.sh'
 * script (drawing time diagram for each node).
 */

      cmd[2] = msg.get_sender() + "";
      Runtime.getRuntime().exec(cmd);

    } catch (Exception e) {
      e.printStackTrace();
    }

  }

  private static void usage() {
    System.err.println("usage: Demo [-comm <source>]");
  }

  public void initialize() {
    file = new File(outputFile);
  }

  public static void main(String[] args) throws Exception {
    String source = null;
    if (args.length == 2) {
      if (!args[0].equals("-comm")) {
	      usage();
	      System.exit(1);
      }
      source = args[1];
    }
    else {
      source = "serial@/dev/ttyUSB0:115200";
    }

    PhoenixSource phoenix;
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }
    System.out.print(phoenix);
    MoteIF mif = new MoteIF(phoenix);
    Demo serial = new Demo(mif);
    serial.initialize();
  }
}

