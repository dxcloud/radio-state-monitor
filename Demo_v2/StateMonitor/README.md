# StateMonitor: Debugging mode

## Presentation

The debugging mode is activated/deactivated by pressing the **USER button**.

When the debugging mode is activate, the LED 0 (red) is turned ON for a period
as a visual confirmation to the user.
The period is defined the constant `NOTIFY_DELAY` (1 second by default).

In the debugging mode, every time a radio state change is detected, a new line
is printed out containing the timestamp in microseconds and the numerical value
of the state.

| Radio state | Numerical value |
|-------------|:---------------:|
| OFF         | 0               |
| Power Down  | 1               |
| IDLE        | 2               |
| Receive     | 3               |
| Transmit    | 4               |

The user is able to read the message by connecting the mote to a laptop via USB,
and run Java application **PrintfClient**.

To deactivate debugging mode, press the **USER button** again, the LED 2 (blue)
is turned ON for a period and then turned OFF.

## Usage

UDPEcho is a simple application for testing this functionality.
In file *UDPEchoC.nc* comment lines inside of `#ifdef PRINTFUART_ENABLED`,
since the component `StateMonitorC` has included `PrintfC` and `SerialStartC`.
Then, just declare the component `StateMonitorC`.

        configuration UDPEchoC {
        } implementation {
          // ...
          #ifdef PRINTFUART_ENABLED
            // ...
            // components SerialPrintfC;
            // components PrintfC;
            // components SerialStartC;
          #endif

          components StateMonitorC;
        }

Then, in the Makefile, the following flags must be used:
* `-DCC2420_RADIO_STATE_CAPTURE`
* `-DNEW_PRINTF_SEMANTICS`
* `-DPRINTFUART_ENABLED`
* `-I<path to StateMonitor>`

Compile and install it.
        $ make telosb blip install,1 bsl,/dev/ttyUSB0

Run also **PrintfClient** application.
        $ java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:115200

Your should see when the **USER button** is pressed:
        Thread[Thread-1,5,main]serial@/dev/ttyUSB0:115200: resynchronising
        Debugging mode activated
        567974 1
        570850 2
        574678 3
        583490 0
        1485024 1
        1488179 2
        ...

## Note
The blip stack contains also some printf for debugging purposes. You may have
to disable these lines manually.

