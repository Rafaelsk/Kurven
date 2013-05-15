with Ada.Text_IO; 				use Ada.Text_IO;
with Ada.Command_Line;		use Ada.Command_Line;
with System;
with Ada.Real_Time;			use Ada.Real_Time;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;

-- **************** AEULC = Aplicar Escalon-Unitario Lazo Cerrado ***********************
--
-- Dato importante 1: Cuando se simula la planta con el controlador, tiene que aumentarse el tiempo de muestreo para tomar mas detalles del comportamiento transitorio.**VER LINEA 10**
-- En este caso se uso 0.1 s para el muestreo de la planta, con este tiempo es suficiente para ver con detalle el comportamiento transitorio.
-- Dato importante 2: El sistema imprimira en pantalla e imprimira un archivo con el resultado del escalon
-- Dato importante 3: La planta tiene que ser de Primer Orden y el controlador PI
--
-- Agumentos:
-- (1) TsP: Tiempo de muestreo para la planta Por defecto: 0.1s
-- (2) TsC: Tiempo de muestreo para el controlador. Por defecto 0.01s
-- (3) n : Numero de muestreos. Por defecto: 30.
-- (4) k : Ganancia de Estado Estable de la planta.	| Primer Orden
-- (5) tau : Tau de la planta.				|
-- (6) Kp: Constante de Ganancia Proporcional.
-- (7) Ki: Constante de Ganancia Integral
-- (8) Nombre: Nombre del Archivo que se guardara con la respuesta


procedure aeulc is
	TsP 		: constant Float 	:= Float'Value(Argument(1));		--Tiempo de muestreo con que se simulara la planta **MIRA AQUI** -- antes era: Float'Value(Argument(3))/10.0
	TsC 		: constant Float 	:= Float'Value(Argument(2));		--Tiempo de muestreo con que se simulara el tren de impulsos de muestreos del Controlador
	n		: constant Float	:= Float'Value(Argument(3));		--Con cuantos segundos se desea probar el controlador  -- antes era: Natural'Value(Argument(4))
	nmax		: constant Float	:= n/TsC;				--Numero de puntos maximo que se mostraran en la grafica, 30 segundos entre las divisiones de tiempo de Contr.

	Estado_Planta	: Float			:= 0.0;					-- |y(i) para guardar el archivo, Estado_Planta para el Control
	t		: Real_Vector(0..1000) := (others => 0.0);			-- Pasos en el tiempo de la simulacion de la planta
	u 		: Float;
	Salida 		: Boolean 		:= False;
	k  		: constant Float	:= Float'Value(Argument(4));		--antes era: Float'Value(Argument(1))
	tau 		: constant Float	:= Float'Value(Argument(5));		--antes era: Float'Value(Argument(2))
	PeriodoP 	: constant Time_Span 	:= Milliseconds(Integer(100.0*TsP));
	PeriodoC	: constant Time_Span 	:= Milliseconds(Integer(100.0*TsC));
	Kp		: constant float	:= Float'Value(Argument(6));		--antes era: Float'Value(Argument(5))
	Ki		: constant float	:= Float'Value(Argument(7));		--antes era: Float'Value(Argument(6))
	Tiempo_Simul	: integer		:= 0;					--Tiempo total de prueba del controlador
	it		: integer		:= 0;					--Iteraciones que se tiene que hacer para lograr los segundos deseados
	Nombre		: string		:= Argument(8);
	y 		: array(INTEGER range 1..300) of Float;				-- |Usados para ver el estado de la planta
	task Simular_Planta is
		pragma Priority (System.Max_Priority);
	end Simular_Planta;

	task Simular_Controlador is
		pragma Priority (System.Default_Priority);
	end Simular_Controlador;

	task body Simular_Planta is
		vz 		: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
		Siguiente 	: Time;
		t_inicio 	: Time;
	begin
		--Put_Line("Nombre del Archivo a Guardar:" & Nombre);
		--Put_Line("Inicio Tarea Planta.");
		Tiempo_Simul 	:= Integer(Float(n));					-- Tiempo que se "simulara" la reaccion de la planta, en SEGUNDOS
		--Put_Line("Tiempo de simulacion: " & Tiempo_Simul'img & " segundos");
		--Put_Line("Tiempo muestreo de la planta = " & TsP'img);
		it 		:= integer(float(Tiempo_Simul)/TsP);			-- Numero de iteraciones que tiene que dar el ciclo for para completar los 30 segundos propuestos de
		--Put_Line("iteraciones: " & it'Img);					-- simulacion, sera entonces Tiempo de simulacion / Ts
		t_inicio  	:= Clock;
		Siguiente 	:= t_inicio;
		for i in 1..it loop
			vz(1) 		:= u - (TsP-2.0*tau)/(TsP+2.0*tau)*(vz(2));	-- Segundo, V1 es igual a la accion de control mas la retroalimentacion por la V2
			y(i) 		:= k*TsP/(TsP+2.0*tau)*(vz(1)+vz(2));		-- Primero, declara que la salida es la parte constante por las dos variables V1 y V2
			Estado_Planta	:= y(i);
			--Put( Float( To_Duration( Clock - t_inicio ) ), 1, 2, 0 );	-- Pone el momento que se calculo "y" con 1 caracter antes del punto, con dos digitos decimales, y sin exponciacion cientifica
			t(i)		:= float(i)*TsP;
			Put_Line(t(i)'img & "," & y(i)'img);				-- Se coloca la accion de control y la salida
			Siguiente	:= Siguiente + PeriodoP;			-- Define cuanto tiempo se tiene que esperar para que la planta se despierte cada Ts*1000.0
			delay until  Siguiente;						-- Espera
			vz(2) := vz(1);
			-- Despues del delay, V2 es igual a V1
		end loop;
		Salida	:= True;
		--Put_Line("Fin Tarea Planta.");
	end Simular_Planta;

	task body Simular_Controlador is
		Siguiente 	: Time;
		t_inicio 		: Time;
		E			: Float;
		vz 			: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
	begin
		--Put_Line("Inicio Tarea Controlador.");
   		t_inicio := Clock;
		Siguiente := t_inicio;
		loop
			--Put_Line("loop del controlador!");
			E  := k - Estado_Planta;
			vz(1) := E + vz(2);
			u := ((Ki*TsC+2.0*Kp)/2.0)*vz(1) + ((Ki*TsC-2.0*Kp)/2.0)*vz(2);
			Siguiente := Siguiente + PeriodoC;
			--Put_Line("Accion de Control:" & u'Img);
			delay until  Siguiente;
			vz(2) := vz(1);
			exit when Salida = True;
		end loop;
		--Put_Line("Fin Tarea Controlador.");
		Declare
			Arch   : File_Type;
			regreso : Boolean := True;
			limite : integer := 0;
		begin
			-- Crea o abre el archivo de datos
			loop
				begin
					Open ( Arch, Out_File, Nombre );		-- Si el archivo no existe genera un Name_Error
					exit;											-- Si existe lo abre y sale del loop
				exception
					when Name_Error =>						-- No existe, entonces se crea
						--Put_Line ("Archivo no existe. Paso a crearlo");
						Create (Arch, Name => Nombre);	-- Se devuelve al comienzo delo loop para abrir el archivo creado
					when Status_Error =>
						--Put_Line ("El archivo ya está abierto. Sigo");
						exit;
					when Use_Error =>		-- No se puede abrir o crear
						--Put_Line ("No he podido crear o abrir el archivo. Salgo del programa");
						regreso := False;
				end;
			end loop;
			limite := it;
			if regreso = True then
				for i in 1..limite loop
					Put_Line(Arch, t(i)'img & "," & y(i)'img);
				end loop;
				Close (Arch);
			end if;
		End;
	end Simular_Controlador;

begin
	Null;
end aeulc;
