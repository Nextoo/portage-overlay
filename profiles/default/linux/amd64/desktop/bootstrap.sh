#!/bin/bash
# Emerge packages with use flags set to stop circular dependencies
USE="-opengl" emerge -1Nu app-emulation/emul-linux-x86-xlibs
USE="-gtk" emerge -1Nu net-dns/avahi

