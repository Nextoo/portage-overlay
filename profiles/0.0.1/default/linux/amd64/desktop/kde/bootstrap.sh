#!/bin/bash
# Emerge packages with use flags set to stop circular dependencies
USE="-postgres -java -gtk -gtk3 -qt4 -X -doc" emerge -1 dev-libs/cyrus-sasl net-dns/avahi
emerge -1 --nodeps dev-java/icedtea-bin
