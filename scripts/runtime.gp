reset
set ylabel 'time(sec)'
set style fill solid
set title 'perfomance comparison'
set term png enhanced font 'Verdana,10'
set output 'runtime.png'

plot [:][:0.150]'output.txt' using 2:xtic(1) with histogram title 'original', \
'' using ($0-0.06):(0.06):2 with labels title ' ', \
'' using 3:xtic(1) with histogram title 'row'  , \
'' using ($0+0.25):(0.04):3 with labels title ' ',\
'' using 4:xtic(1) with histogram title 'col'  , \
'' using ($0+0.35):(0.02):4 with labels title ' '
