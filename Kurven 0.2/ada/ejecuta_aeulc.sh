#!/bin/bash
TsP=0.1
TsC=0.01
n=30
k=16.44
Tau=5.56
Kp=0.1
Ki=0.1
Nombre=RDADELC.txt
./aeulc $TsP $TsC $n $k $Tau $Kp $Ki $Nombre
