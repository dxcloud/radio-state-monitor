/**
 * @file    Demo/java/Demo.java
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-20
 * @version 1.2
 * @brief   Java application for displaying radio activity report
 * @details Changelog:
 *          - Time diagram (.png file) generation by executing `plot.sh'
 */

import java.io.IOException;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Calendar;
import java.lang.*;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class Demo implements MessageListener {

  final private String outputFile = "output";
  private int currentDay = Calendar.getInstance().get(Calendar.DAY_OF_YEAR);
  private int numBackup = 0;
  private MoteIF moteIF;
  private File file;
  private String[] cmd = new String[] {"./plot.sh", outputFile, " "};

  public Demo(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new ReportMsg(), this);
  }

  public void messageReceived(int to, Message message) {
    ReportMsg msg = (ReportMsg) message;
    double voltage = msg.get_voltage() / 4096.0 * 3.0;  // see DemoSensorC.nc
    double temperature = msg.get_sensor() * 0.01 - 39.60;  // see Sensirion sth11 datasheet
    String reportMessage = msg.get_sender() + " "
                           + msg.get_seqno() + " "
                           + msg.getElement_duration_states(0) + " "
                           + msg.getElement_duration_states(1) + " "
                           + msg.getElement_duration_states(2) + " "
                           + msg.getElement_duration_states(3) + " "
                           + msg.getElement_duration_states(4);

    System.out.println(reportMessage + " "
                       + voltage + " "
                       + temperature + " "
                       + timestamp());

    try {
      FileWriter writer = new FileWriter(file, true);
      PrintWriter printer = new PrintWriter(writer, true);
      printer.println(reportMessage + " "
                      + msg.get_voltage() + " "
                      + msg.get_sensor() + " "
                      + System.currentTimeMillis());

      printer.close();

      if (currentDay != Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) {
        currentDay = Calendar.getInstance().get(Calendar.DAY_OF_YEAR);
        newFile(++numBackup);
      }

/*
 * Uncomment the next two lines to enable this application to execute `plot.sh'
 * script (drawing time diagram for each node).
 */

//      cmd[2] = msg.get_sender() + "";
//      Runtime.getRuntime().exec(cmd);

    } catch (Exception e) {
      e.printStackTrace();
    }

  }

  private static void usage() {
    System.err.println("usage: Demo [-comm <source>]");
  }

  private String timestamp() {
    long millis = System.currentTimeMillis();
    int second = (int) ((millis / 1000) % 60);
    int minute = (int) ((millis / 60000) % 60);
    int hour = (int) ((millis / 3600000) % 24);
    return hour + ":" + minute + ":" + second;
  }

  public void newFile(int fileNumber) {
    file = new File(outputFile + fileNumber + ".dat");
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
    serial.newFile(0);
  }
}

