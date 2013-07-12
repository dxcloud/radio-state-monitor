################################################################################
### Demo_v2/SendingMote/Makefile
################################################################################

COMPONENT=SendingMoteC

### Destination UDP port
### Default port is 7060
CFLAGS   += -DAPP_PORT=7060

### Report interval in milliseconds
### 10 minutes: 600000
### 15 minutes: 900000
CFLAGS   += -DAPP_PERIOD=900000UL

### Enable blinking LED
#CFLAGS   += -DLED_ENABLED

### Dummy sending parameters
### Loopback address '::1'
CFLAGS   += -DDUMMY_SEND_ENABLED
CFLAGS   += -DDUMMY_PERIOD=600000UL
CFLAGS   += -DDUMMY_DEST=\"::1\"

### Enable random number generation
### If this flag is set, DUMMY_PERIOD will be automatically disabled
### The random number is between RANDOM_MIN and RANDOM_MAX
CFLAGS   += -DRANDOM_ENABLED \
            -DRANDOM_MAX=600000UL \
            -DRANDOM_MIN=60000UL

### Radio settings
CFLAGS   += -DCC2420_DEF_CHANNEL=16
CFLAGS   += -DCC2420_DEF_RFPOWER=31

### Enable radio state capture functionalities
CFLAGS   += -DCC2420_RADIO_STATE_CAPTURE

### LPL parameters
CFLAGS   += -DLOW_POWER_LISTENING \
            -DLPL_SLEEP_INTERVAL=1024U \
            -DBLIP_L2_RETRIES=2 \
            -DBLIP_L2_DELAY=2048U

### Static address
CFLAGS   += -DIN6_PREFIX=\"fec0::\"
CFLAGS   += -DREPORT_DEST=\"fec0::B5\"
CFLAGS   += -DBLIP_DERIVE_SHORTADDRS

### Enalbe UDP shell
#CFLAGS   += -DUDP_SHELL_ENABLED

### Enable RPL routing protocol
CFLAGS   += -DRPL_ROUTING \
            -DRPL_STORING_MODE \
            -I$(TOSDIR)/lib/net/rpl

### Directories to be included
INCLUDES += -I.. \
            -I../StateCapture \
            -I../ReportCmd

CFLAGS   += $(INCLUDES)

### Enable Voltage Sensor
CFLAGS   += -DVOLTAGE_SENSOR

### Enable only ONE sensor at a time:
### - Temperature
### - Humidity
### - Visible Light
### - All Light
CFLAGS   += -DTEMPERATURE_SENSOR
#CFLAGS   += -DHUMIDITY_SENSOR
#CFLAGS   += -DVISIBLE_LIGHT_SENSOR
#CFLAGS   += -DALL_LIGHT_SENSOR

### Enable printf
CFLAGS   += -DPRINTFUART_ENABLED \
            -DNEW_PRINTF_SEMANTICS

include $(MAKERULES)

