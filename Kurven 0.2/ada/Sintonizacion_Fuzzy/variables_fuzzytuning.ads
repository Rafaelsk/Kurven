with Ada.Numerics.Real_Arrays;  use Ada.Numerics.Real_Arrays;

package variables_fuzzytuning is


	-- Usadas para deteccion de Variables de la prueba escalon


	Type MUESTREO is
		record
			VALOR	: float	:= 0.0;
			TIEMPO	: float	:= 0.0;
		end record;

	-- Usadas para el Control Difuso
	Type ESTADO_TAS is 			-- Objeto para tiempo de asentamiento
		record
			-- Valor de la Variable
			INICIAL		: float := 0.0;		-- Valor leido actualmente
			ACTUAL		: float := 0.0;
			VALOR		: float := 0.0;		-- Comparacion del actual con el escalon (% de mas rapidez)
			-- Estado en comparacion con el escalon inicial
			IGUAL_AL_ESCALON		: float := 0.0;
			ESTA_20_PORCIENTO_MASRAPIDO	: float := 0.0;
			ESTA_40_PORCIENTO_MASRAPIDO	: float := 0.0;
			ESTA_60_PORCIENTO_MASRAPIDO	: float := 0.0;
			ESTA_80_PORCIENTO_MASRAPIDO	: float := 0.0;
			ESTA_100_PORCIENTO_MASRAPIDO	: float := 0.0;
		end record;

	Type ESTADO_MP is 			-- Objeto para tiempo de asentamiento
		record
			-- Valor de la Variable
			VALOR		: float := 0.0;

			-- Estado de la variable
			NULO		: float := 0.0;
			MUY_POCO	: float := 0.0;
			POCO		: float := 0.0;
			MEDIO		: float := 0.0;
			GRANDE		: float := 0.0;
			MUY_GRANDE	: float := 0.0;
		end record;

	Salida_TAS	: float		:= 0.0;
	Operacion_TAS	: array(INTEGER range 1..6) of float;
	-- (1) NO_AUMENTAR
 	-- (2) AUMENTAR_20_PORCIENTO
 	-- (3) AUMENTAR_40_PORCIENTO
 	-- (4) AUMENTAR_60_PORCIENTO
	-- (5) AUMENTAR_80_PORCIENTO
	-- (6) AUMENTAR_100_PORCIENTO
 	Media_TAS : array(INTEGER range 1..6) of float;


	Salida_CHI 	: float		 := 0.0;
	Operacion_CHI	: array(INTEGER range 1..6) of float;
	-- (1) OSCILAR
	-- (2) APURAR_MUCHO_REBOTAR_MUCHO
	-- (3) APURAR_POCO_REBOTAR_POCO
	-- (4) AMORTIGUAR
	-- (5) RELENTIZAR_POCO_AMORTIGUAR_POCO
	-- (6) RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO
	Media_CHI : array(INTEGER range 1..6) of float;



	-- Usadas para Probar la planta con el control
	Kp	: Float;
	Ki	: Float;
	TAS	: ESTADO_TAS;
	MP	: ESTADO_MP;
	Tr	: Float;

	-- Variables para el control del tasking
	Run_p, Run_c 	: boolean := False;
end variables_fuzzytuning;
