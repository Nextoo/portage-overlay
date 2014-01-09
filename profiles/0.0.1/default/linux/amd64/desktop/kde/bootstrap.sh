#!/bin/bash
# Emerge packages with use flags set to stop circular dependencies
USE="-postgres" emerge -1 dev-libs/cyrus-sasl
