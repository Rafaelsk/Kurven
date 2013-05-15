with variables;	use variables;
with Ada.Command_Line;	use Ada.Command_Line;
with System;

package evaluar_modelo is
	procedure evalua_modelo ( kt, taut, Tt : in long_float );
	function guarda_datos_modelos return Boolean;
	procedure lee_archivo_datostxt;
	procedure lee_archivo_de_datos;
end evaluar_modelo;
