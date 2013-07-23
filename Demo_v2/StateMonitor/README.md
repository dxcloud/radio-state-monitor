# StateMonitor: Debugging mode

## Presentation

The debugging mode can be activated/deactivated by pressing the **USER button**.

When the debugging mode is activate, the LED 0 (red) is turned ON for one period
as a visual confirmation.    
The period is defined the constant `NOTIFY_DELAY`
(the default delay is 1 second).

In the debugging mode, every time a radio state change is detected, a new line
is printed out containing the timestamp and the numerical value of the state.

| Radio state | Numerical value |
|-------------|:---------------:|
| OFF         | 0               |
| Power Down  | 1               |
| IDLE        | 2               |
| Receive     | 3               |
| Transmit    | 4               |

The message can be read by connecting the mote to a laptop,
and by running **PrintfClient** application.

To deactivate debugging mode, press the **USER button** again, the LED 2 (blue)
should be turned ON for one period and then turned OFF.

--------------------------------------------------------------------------------

The unit of the timestamp depend on which kind of Counter used. There are 3
types:
* `CounterMicro32C`
* `Counter32khz32C`
* `CounterMilli32C`

The type of the Counter can be configured by using one of the following flags
in the Makefile:
* `COUNTER_MICRO_ENABLED`: to use microsecond Counter
* `COUNTER_32KHZ_ENABLED`: to use 32kHz Counter

Notice that whether none of the above flags is set, the millisecond Counter
is used instead.    
Prefer millisecond Counter or 32kHz Counter to microsecond Counter, that is
because several lines of output could be cut short before being fully printed
when microsecond Counter is used.

--------------------------------------------------------------------------------

The module `StateMonitorP` is implemented with a **ring buffer**. The buffer is
used both for printing and writting. The size of the buffer is defined by
`RING_BUFFER_SIZE`, the size is configurable by specifying the proper `CFLAGS`
option in your Makefile, nethertheless the size cannot exceed 256, and the
default size is limited to 32 elements.
Two ring buffers are used, one for timestamp (4 bytes per element) and the other
for radio state (1 byte per element).    
The reason of using ring buffers is because the printing operation is a too slow
compared to the writting operation. So, the printing function is not able to
print out all lines when numerous radio events are triggered is a short period.    
Moreover, because of **data structure alignment**, two buffers are used instead
of one buffer of structure containing both timestamp and radio state. In the
case of structure, 6 bytes is used instead 5 bytes (+1 padding byte).


## Usage

UDPEcho is a simple application that could be used for testing debugging mode.

First, comment each line where `SerialPrintfC`, `PrintfC` or `SerialStartC`
appears in *UDPEchoC.nc*.    
Since the component `StateMonitorC` has already included `PrintfC` and
`SerialStartC`, no need to declare them again.    
Then, just include the component `StateMonitorC` in the same file.

```
configuration UDPEchoC {
} implementation {

  // ...
  // components SerialPrintfC;
  // components PrintfC;
  // components SerialStartC;

  components StateMonitorC;
}
```

In the Makefile, the following flags must be set:
* `CC2420_RADIO_STATE_CAPTURE`
* `NEW_PRINTF_SEMANTICS`
* `PRINTFUART_ENABLED`: only whether the **blip stack** is used.

The path of the directory *StateMonitor* need also be included in your Makefile.

--------------------------------------------------------------------------------

Compile and install it.

```
$ make telosb blip install,1 bsl,/dev/ttyUSB0
```

Run also **PrintfClient** application.

```
$ java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:115200
```

--------------------------------------------------------------------------------

Finally, press the **USER button**, the following output should be printed to
your screen:

```
567974 1
570850 2
574678 3
583490 0
1485024 1
1488179 2
...
```

The first column indicates the timestamp, the unit depends on the type of
Counter used for the application. The second column shows the radio state.


## Plot time diagram

You can also plot a time diagram in order to visualize the radio state change.
**gnuplot** can be used for that.

Install **gnuplot**:

```
$ sudo apt-get install gnuplot
```

Record the printed values into a file, then type:

```
$ gnuplot
plot '<your data file>' using 1:2 with steps
```

More information about **gnuplot** at [gnuplot homepage](http://www.gnuplot.info/).


## Note

The blip stack has also several lines containing `printf` for debugging
purposes which are not removed for the released version.

**Date:** 2013-07-23    
**Author:** Chengwu Huang <chengwhuang@gmail.com>    

