with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;	use Ada.Command_Line;
with System;
with variables;	use variables;
with busqueda_directa;	use busqueda_directa;

procedure ajuste_directo is
	X: boolean:= false;
begin
	lee_archivo_de_datos(Argument(1));
	calcula_k_tau;
	evalua_modelo;
	X:= guarda_datos_modelo;
	imprimir_datos_modelo;
end ajuste_directo;

