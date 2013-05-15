#!/bin/bash

gnatmake --GCC=gcc --RTS=rts-native fbp1s.adb -bargs -static;
gnatmake --GCC=gcc --RTS=rts-native fbp1c.adb -bargs -static;
gnatmake evaluar_modelo.adb

