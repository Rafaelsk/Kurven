set terminal wxt 1 enhanced
set size 1.0, 1.0
set origin 0.0, 0.0
set multiplot
set size 1.0,0.6
set origin 0.0,0.5
set grid
set title 'Datos y Modelo'
set xlabel 'Tiempo'
set ylabel 'Amplitud'
set key on box top left
set grid xtics ytics
set datafile separator ','
plot [0:30][*:*] 'datosm.txt' u 1:3 t 'Modelo' with lines lw 2 lt rgb '#FF0000', \
					  'datosm.txt' u 1:2 t 'Datos' with lines lw 2 lt rgb '#0000FF'
# Próxima gráfica con los errores
set size 1.0,0.5
set origin 0.0,0.0
set grid
set title 'Errores del Modelo'
set xlabel 'Tiempo'
set ylabel 'Amplitud'
set key on box bottom right
set grid xtics ytics
plot [0:30][*:*] 'datosm.txt' u 1:4 t 'Errores' with lines lw 2 lt rgb '#008000'
unset multiplot

