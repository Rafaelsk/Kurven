with Ada.Numerics.Real_Arrays;  use Ada.Numerics.Real_Arrays;

package variablesmd is
	r : float := 1.0;												-- Magnitud del escalón de entrada al momento de obtener datos
	kd, taud : long_float;												--	Modelo: Ganancia y constante de tiempo
	npmax : integer := 1000;									-- Máximo número de puntos del archivo de datos
	n : integer;													-- Número de puntos leídos desde archivo de datos
	Ts: long_float;
	t : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de tiempo
	v : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de amplitud
	m : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de datos del modelo
	err : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de errores del modelo
	ISEd : long_float;							-- ISE para el modelo
	yd : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de datos del modelo
	type T_Punto is
	record
		x : long_float;
		y : long_float;
	end record;
	
end variablesmd;
