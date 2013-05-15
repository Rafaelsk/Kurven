with Ada.Numerics.Real_Arrays;  use Ada.Numerics.Real_Arrays;

package variables is
	r : long_float := 1.0;										-- Magnitud del escalón de entrada al momento de obtener datos
	kd, taud : long_float;											--	Modelo: Ganancia y constante de tiempo
	npmax : integer := 1000;									-- Máximo número de puntos del archivo de datos
	n : integer := 30;													-- Número de puntos leídos desde archivo de datos
	Ts : long_float;												-- Tiempo de muestreo
	t : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de tiempo
	v : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de amplitud
	m : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de datos del modelo
	err : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de errores del modelo
	ISE : long_float;												-- ISE para el modelo
	md : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de datos del modelo directo
	errd : Real_Vector(1..npmax) := (others => 0.0);	-- Vector de errores del modelo directo
	ISEd : long_float;														-- ISE para el modelo directo
	mfb : Real_Vector(1..npmax) := (others => 0.0);		-- Vector de datos del modelo fb
	errfb : Real_Vector(1..npmax) := (others => 0.0);	-- Vector de errores del modelo fb
	ISEfb : long_float;											-- ISE para el modelo fb
	kfb, taufb : long_float;									--	Fuerza Bruta: Ganancia y constante de tiempo
	mk, mtau, mISE : long_float;								--	Mejores parámetros obtenidos en la ejecución de FB
	tau_min, tau_max, tau_paso, tau_temp : long_float;
	ISE_temp : long_float; 
	contaglim, contag, indice, contador : integer;
	mcpg : integer := 1000;										-- Máxima cantidad de puntos de datos para graficar históricos
	taus : Real_Vector(1..mcpg) := (others => 0.0);		-- Históricos de tau
	ISEs : Real_Vector(1..mcpg) := (others => 0.0);		-- Históricos de ISE
	
	type T_Punto is
	record
		x : long_float;
		y : long_float;
	end record;
	
end variables;
