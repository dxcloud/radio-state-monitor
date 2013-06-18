################################################################################
### Demo_v2/SendingMote/Makefile
################################################################################

COMPONENT=SendingMoteC

### Destination UDP port
### Default port is 7060
CFLAGS   += -DAPP_PORT=7060

### Report interval in milliseconds
CFLAGS   += -DAPP_PERIOD=6000UL

### Enable blinking LED
#CFLAGS   += -DLED_ENABLED

### Enable random number generation
### If this flag is set, APP_PERIOD will be automatically disabled
### The random number is between RANDOM_MIN and RANDOM_MAX
#CFLAGS   += -DRANDOM_ENABLED \
#            -DRANDOM_MAX=30000UL \
#            -DRANDOM_MIN=10000UL

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
CFLAGS   += -DREPORT_DEST=\"fec0::1\"
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

