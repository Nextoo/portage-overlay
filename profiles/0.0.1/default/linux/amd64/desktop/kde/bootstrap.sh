#!/bin/bash
# Emerge packages with use flags set to stop circular dependencies
USE="-postgres -java -gtk" emerge -1 dev-libs/cyrus-sasl net-dns/avahi
