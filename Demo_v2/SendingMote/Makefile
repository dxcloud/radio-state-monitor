################################################################################
### Demo_v2/SendingMote/Makefile
################################################################################

COMPONENT=SendingMoteC

### Destination UDP port
CFLAGS   += -DAPP_PORT=7060

### Report interval
CFLAGS   += -DAPP_PERIOD=2000UL

CFLAGS   += -DLED_ENABLED

### Enable rando
### If this flag is set, APP_PERIOD will be automatically disabled
### RANDOM_MAX and RANDOM_MIN define the interval of random value
CFLAGS   += -DRANDOM_ENABLED \
            -DRANDOM_MAX=30000UL \
            -DRANDOM_MIN=10000UL

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
CFLAGS   += -DREPORT_DEST=\"fec0::5\"
CFLAGS   += -DBLIP_DERIVE_SHORTADDRS

### Enalbe UDP shell
CFLAGS   += -DUDP_SHELL_ENABLED

### Enable RPL routing protocol
CFLAGS   += -DRPL_ROUTING \
            -DRPL_STORING_MODE \
            -I$(TOSDIR)/lib/net/rpl

INCLUDES += -I.. \
            -I../StateCapture \
            -I../ReportCmd

CFLAGS   += $(INCLUDES)

### Enable Voltage Sensor
CFLAGS   += -DVOLTAGE_SENSOR

################################################################################
### Enable only ONE sensor at a time:
### - Temperature
### - Humidity
### - Visible Light
### - All Light
################################################################################
### Enable Temperature Sensor
#CFLAGS   += -DTEMPERATURE_SENSOR

### Enable Humidity Sensor
#CFLAGS   += -DHUMIDITY_SENSOR

### Enable Visible Light Sensor
CFLAGS   += -DVISIBLE_LIGHT_SENSOR

### Enable All Light Sensor
#CFLAGS   += -DALL_LIGHT_SENSOR
################################################################################

### Enable printf
CFLAGS   += -DPRINTFUART_ENABLED \
            -DNEW_PRINTF_SEMANTICS

include $(MAKERULES)

