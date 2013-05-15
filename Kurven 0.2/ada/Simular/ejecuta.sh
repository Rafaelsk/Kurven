#!/bin/bash
gnome-terminal -e ./ejecuta_planta.sh
sleep 1
gnome-terminal -e ./ejecuta_controlador_a.sh
sleep 1
gnome-terminal -e ./ejecuta_controlador_b.sh
sleep 1
gnome-terminal -e ./ejecuta_operador.sh

