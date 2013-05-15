with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;	use Ada.Command_Line;
with System;
with variablesmd;	use variablesmd;
with busqueda_directa;	use busqueda_directa;
-- ajuste_directo: Calcula el tau y k mediante el calculo de 63.2 por ciento.
-- Agumentos:
-- (1) Nombre del archivo donde esta el muestreo de la planta
-- (2) Nombre del archivo donde se guardara el resultado (tau, k, ISE, y nuevo comportamiento escalon lazo abierto)
procedure ajuste_directo is
	X : boolean:= false;
begin
	lee_archivo_de_datos(Argument(1));
	calcula_k_tau;
	evalua_modelo;
	X:= guarda_datos_modelo(Argument(2));
	imprimir_datos_modelo;
end ajuste_directo;

