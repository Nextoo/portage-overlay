#!/bin/bash
# Emerge packages with use flags set to stop circular dependencies
USE="-postgres -java -gtk -gtk3 -qt4" emerge -1Nu dev-libs/cyrus-sasl net-dns/avahi
emerge -1Nu --nodeps dev-java/icedtea-bin
