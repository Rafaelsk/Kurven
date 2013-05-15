with Ada.Numerics.Real_Arrays;  use Ada.Numerics.Real_Arrays;
Package variables_esp_curv is

	type COORDENADA is
		record
			X 	: float	:= 0.0;	-- Componente X
			Y 	: float	:= 0.0;	-- Componente Y
			m	: float	:= 0.0;	-- Componente m (pendiente)
			b	: float	:= 0.0;	-- Componente b (punto donde la recta corta al eje de las ordenadas)
		end record;

	Type MUESTREO is
		record
			VALOR	: float	:= 0.0;
			TIEMPO	: float	:= 0.0;
		end record;


		-- Usadas para deteccion de Variables de la prueba escalon
	TAS	: float;
	MP	: float;
	CHI	: float := 0.0;
	k	: float	:= 0.0;			-- Valor ultimo
	t10	: float	:= 0.0;			-- Tiempo al 10% de la se�al
	t90	: float	:= 0.0;			-- Tiempo al 90% de la se�al.
	t95	: float	:= 0.0;			-- Tiempo al 95% de la se�al
	k10	: float	:= 0.0;			-- 10% del Valor final
	k90	: float	:= 0.0;			-- 90% del valor final
	k95	: float	:= 0.0;			-- 95% del valor final
	ik10	: integer	:= 0;			-- numero de muestreos hasta el 10% del valor
	ik90	: integer	:= 0;			-- numero de muestreos hasta el 90% del valor
	ik95	: integer	:= 0;			-- numero de muestreos hasta el 95% del valor
	Tr 	: float	:= 0.0;			-- Tiempo de levantamiento
	r 	: float := 1.0;												-- Magnitud del escalón de entrada al momento de obtener datos
	kd, taud : long_float;												--	Modelo: Ganancia y constante de tiempo
	npmax 	: integer := 1000;									-- Máximo número de puntos del archivo de datos
	n 	: integer;													-- Número de puntos leídos desde archivo de datos
	Ts	: long_float;													-- Número de puntos leídos desde archivo de datos					-- Tiempo de muestreo
	t 	: Real_Vector(1..npmax) := (others => 0.0);		-- Vector de tiempo
	v 	: Real_Vector(1..npmax) := (others => 0.0);		-- Vector de amplitud

End variables_esp_curv;
