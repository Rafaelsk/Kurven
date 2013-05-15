with variables;	use variables;
with Ada.Command_Line;	use Ada.Command_Line;
with System;

package busqueda_directa is
	procedure lee_archivo_de_datos(DIRECCION: in string);
	procedure calcula_k_tau;
	function  parametros_recta( p1, p2 : in T_Punto) return T_Punto;
	procedure evalua_modelo;
	function guarda_datos_modelo return Boolean;
	procedure imprimir_datos_modelo;
end busqueda_directa;
