#!/bin/bash
#
# use the command line interface to install Weather.com package.
#
: ${WHISK_SYSTEM_AUTH:?"WHISK_SYSTEM_AUTH must be set and non-empty"}
AUTH_KEY=$WHISK_SYSTEM_AUTH

SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
source "$SCRIPTDIR/util.sh"
cd "$SCRIPTDIR/../bin"

echo Installing Weather package.

createPackage 'weather' \
    -a description "Services from The Weather Company" \
    -a parameters '[ {"name":"apiKey", "required":false} ]'

waitForAll

install 'weather/forecast.js'       weather/forecast \
    -a description 'Weather.com 10-day forecast' \
    -a parameters '[ {"name":"latitude", "required":true}, {"name":"longitude", "required":true}, {"name":"apiKey", "required":true, "type":"password", "bindTime":true} ]' \
    -a sampleInput '{"latitude":"34.063", "longitude":"-84.217", "apiKey":"XXX"}' \
    -a sampleOutput '{"forecasts":[ {"dow":"Monday", "min_temp":30, "max_temp":38, "narrative":"Cloudy"} ]}'

waitForAll

echo Weather package ERRORS = $ERRORS
exit $ERRORS
