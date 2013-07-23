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

You are able to read the message by connecting the mote to a laptop via USB,
and by running **PrintfClient** application.

To deactivate debugging mode, press the **USER button** again, the LED 2 (blue)
should be turned ON for one period and then turned OFF.

--------------------------------------------------------------------------------

The unit of the timestamp can be configured by using one of the following flags
in the Makefile:
* `COUNTER_MICRO_ENABLED`: microsecond Counter
* `COUNTER_32KHZ_ENABLED`: 32kHz Counter

Notice that whether none of the above flags is defined, a millisecond Counter
is used instead.    
Prefer millisecond Counter or 32kHz Counter to microsecond Counter, that is
because lines of output could be cut short before being fully printed when
microsecond Counter is used.

--------------------------------------------------------------------------------

The module `StateMonitorP` is implemented with a **ring buffer**. The buffer is
used for printing and writting. The size of the buffer is defined by
`RING_BUFFER_SIZE`, this size is configurable by specifying the proper `CFLAGS`
option in your Makefile, nethertheless you cannot use more than 256 elements.
The default size is limited to 32 elements.
Notice that each element is 5 bytes long (4 bytes for timestamp and 1 byte
for radio state). When you notice that some radio states is not printed, try to
increase the size of the buffer.    
The reason of using ring buffer is because `printf` is a slow operation
compared to the writting operation. So whether the radio events are triggered
too often and too fast, the printing task is not able to print out all changes.


## Usage

UDPEcho is a simple application for testing this functionality.
In the file *UDPEchoC.nc*, comment every lines where `SerialPrintfC`,
`PrintfC` or `SerialStartC` appear.
Since the component `StateMonitorC` has already included `PrintfC` and
`SerialStartC`, you do not need to declare them again.    
Then, just declare the component `StateMonitorC` is enough.

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

In the Makefile, the following flags must be used:
* `CC2420_RADIO_STATE_CAPTURE`
* `NEW_PRINTF_SEMANTICS`
* `PRINTFUART_ENABLED`: whether the **blip stack** is used.

You need also include the path of the directory *StateMonitor* (and *printf*
whether the **blip stack** is not used).

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
Thread[Thread-1,5,main]serial@/dev/ttyUSB0:115200: resynchronising
567974 1
570850 2
574678 3
583490 0
1485024 1
1488179 2
...
```
The first column indicates the timestamp, the unit depends on the type of
Counter used for the application. The second column is the radio state.

## Note
The blip stack has also several lines containing `printf` for debugging
purposes which are not removed for released version.

**Date:** 2013-07-23    
**Author:** Chengwu Huang <chengwhuang@gmail.com>    

