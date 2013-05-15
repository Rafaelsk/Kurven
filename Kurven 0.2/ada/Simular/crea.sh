#!/bin/bash

gnatmake --GCC=gcc --RTS=rts-native planta.adb -bargs -static;
gnatmake --GCC=gcc --RTS=rts-native controlador_a.adb -bargs -static;
gnatmake --GCC=gcc --RTS=rts-native controlador_b.adb -bargs -static;
gnatmake --GCC=gcc --RTS=rts-native operador.adb -bargs -static;
