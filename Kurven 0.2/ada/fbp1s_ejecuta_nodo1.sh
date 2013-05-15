#!/bin/bash
PUERTO=50000
KD=16.4465
TAUD=5.56079
TS=0.1

./fbp1s $PUERTO $KD $TAUD Resultado_fb.txt
read X
