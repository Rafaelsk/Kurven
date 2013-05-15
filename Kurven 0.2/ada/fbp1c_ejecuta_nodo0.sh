#!/bin/bash
PUERTO=50000
NODO1=localhost
KD=16.4465
TAUD=5.56079
TAUPASO=0.5e-7

./fbp1c $NODO1 $PUERTO $KD $TAUD $TAUPASO Resultado_fb.txt
read X

