with Ada.Text_IO; 			use Ada.Text_IO;
with Ada.Command_Line;			use Ada.Command_Line;
with System;
with variables_fuzzytuning;		use variables_fuzzytuning;
with biblioteca_fuzzytuning;		use biblioteca_fuzzytuning;
with Ada.Real_Time;			use Ada.Real_Time;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
With biblioteca_esp_curv;		use biblioteca_esp_curv;

Procedure fuzzytuning is
	-- Nombre del archivo que contiene el escalon inicial a mejorar
	Nombre_Archivo 	: String := String(Argument(1));
	-- Nombre del archivo que mostrara el resultado
	--Nombre_Salida	: String := String(Argument(4));
	--X	: boolean := False;
	-- Datos de la planta (Para la simulacion)
	k		: float	:= float'value(Argument(2));
	tau		: float := float'value(Argument(3));
	Tr_recibido, TAS_recibido, MP_recibido : float := 0.0;


	-- -------------------------Tasking para ejecutar escalon en lazo cerrado-------------------------------------------------------

	TsP_sim 	: constant Float 	:= 0.1;					--Tiempo de muestreo con que se simulara la planta **MIRA AQUI** -- antes era: Float'Value(Argument(3))/10.0
	TsC_sim 	: constant Float 	:= 0.01;				--Tiempo de muestreo con que se simulara el tren de impulsos de muestreos del Controlador
	n_sim		: constant Float	:= 30.0;		--Con cuantos segundos se desea probar el controlador  -- antes era: Natural'Value(Argument(4))
	nmax_sim	: constant Float	:= n_sim/TsC_sim;				--Numero de puntos maximo que se mostraran en la grafica, 30 segundos entre las divisiones de tiempo de Contr.
	Estado_Planta_sim	: Float		:= 0.0;					-- |y(i) para guardar el archivo, Estado_Planta para el Control
	t_sim		: Real_Vector(0..1000) 	:= (others => 0.0);			-- Pasos en el tiempo de la simulacion de la planta
	u_sim 		: Float;
	Salida_sim 	: Boolean 		:= False;
	k_sim  		: constant Float	:= k;					--antes era: Float'Value(Argument(1))
	tau_sim 	: constant Float	:= tau;					--antes era: Float'Value(Argument(2))
	PeriodoP_sim 	: constant Time_Span 	:= Milliseconds(Integer(100.0*TsP_sim));
	PeriodoC_sim	: constant Time_Span 	:= Milliseconds(Integer(100.0*TsC_sim));
	Tiempo_Simul_sim	: integer	:= 0;					--Tiempo total de prueba del controlador
	it_sim		: integer		:= 0;					--Iteraciones que se tiene que hacer para lograr los segundos deseados
	Nombre_sim	: string		:= "Fuzzy_loop.txt";
	y_sim 		: array(INTEGER range 1..300) of Float;				-- |Usados para ver el estado de la planta
	task Simular_Planta is
		pragma Priority (System.Default_Priority);
	end Simular_Planta;

	task Simular_Controlador is
		pragma Priority (System.Default_Priority);
	end Simular_Controlador;

	task flujo_principal is
		pragma Priority(System.Default_Priority);
	end flujo_principal;


	task body Simular_Planta is
		vz_sim 		: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
		Siguiente_sim 	: Time;
		t_inicio_sim 	: Time;
	begin
		--Put_Line("Planta esperando por señal de arranque");
		loop
			If Run_p then
				--Put_Line("Nombre del Archivo a Guardar:" & Nombre_sim);
				--Put_Line("Inicio Tarea Planta.");
				Tiempo_Simul_sim 	:= Integer(Float(n_sim));					-- Tiempo que se "simulara" la reaccion de la planta, en SEGUNDOS
				--Put_Line("Tiempo de simulacion: " & Tiempo_Simul_sim'img & " segundos");
				--Put_Line("Tiempo muestreo de la planta = " & TsP_sim'img);
				it_sim 		:= integer(float(Tiempo_Simul_sim)/TsP_sim);			-- Numero de iteraciones que tiene que dar el ciclo for para completar los 30 segundos propuestos de
				--Put_Line("iteraciones: " & it_sim'Img);					-- simulacion, sera entonces Tiempo de simulacion / Ts
				t_inicio_sim  	:= Clock;
				Siguiente_sim 	:= t_inicio_sim;
				for i in 1..it_sim loop
					--Put_Line("Accion Planta.");
					vz_sim(1) 		:= u_sim - (TsP_sim-2.0*tau_sim)/(TsP_sim+2.0*tau_sim)*(vz_sim(2));	-- Segundo, V1 es igual a la accion de control mas la retroalimentacion por la V2
					y_sim(i) 		:= k_sim*TsP_sim/(TsP_sim+2.0*tau_sim)*(vz_sim(1)+vz_sim(2));		-- Primero, declara que la salida es la parte constante por las dos variables V1 y V2
					Estado_Planta_sim	:= y_sim(i);
					--Put( Float( To_Duration( Clock - t_inicio ) ), 1, 2, 0 );	-- Pone el momento que se calculo "y" con 1 caracter antes del punto, con dos digitos decimales, y sin exponciacion cientifica
					t_sim(i)		:= float(i)*TsP_sim;
					--Put_Line(t_sim(i)'img & "," & y_sim(i)'img);				-- Se coloca la accion de control y la salida
					Siguiente_sim	:= Siguiente_sim + PeriodoP_sim;			-- Define cuanto tiempo se tiene que esperar para que la planta se despierte cada Ts*1000.0
					delay until  Siguiente_sim;						-- Espera
					vz_sim(2) := vz_sim(1);
					-- Despues del delay, V2 es igual a V1
				end loop;
				Salida_sim	:= True;
				--Put_Line("Fin Tarea Planta.");
				vz_sim(1)	:= 0.0;
				vz_sim(2)	:= 0.0;
				Run_p := False;
			End If;
		End loop;
	End Simular_Planta;

	task body Simular_Controlador is
		Siguiente_sim 	: Time;
		t_inicio_sim 		: Time;
		E_sim			: Float;
		vz_sim 			: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
	begin
		--Put_Line("Controlador esperando por señal de arranque");
		loop
			If Run_c then
					--Put_Line("Inicio Tarea Controlador. Con Kp=" & Kp'Img & ", Ki=" & Ki'Img);
					t_inicio_sim := Clock;
					Siguiente_sim := t_inicio_sim;
					loop
						--Put_Line("loop del controlador!");
						E_sim  := k_sim - Estado_Planta_sim;
						vz_sim(1) := E_sim + vz_sim(2);
						u_sim := ((Ki*TsC_sim+2.0*Kp)/2.0)*vz_sim(1) + ((Ki*TsC_sim-2.0*Kp)/2.0)*vz_sim(2);
						Siguiente_sim := Siguiente_sim + PeriodoC_sim;
						--Put_Line("Accion de Control:" & u_sim'Img);
						delay until  Siguiente_sim;
						vz_sim(2) := vz_sim(1);
						exit when Salida_sim = True;
					end loop;
				Salida_sim := False;
					Declare
						Arch_sim   : File_Type;
						regreso_sim : Boolean := True;
						limite_sim : integer := 0;
					begin
						-- Crea o abre el archivo de datos
						loop
							begin
								Open ( Arch_sim, Out_File, Nombre_sim );		-- Si el archivo no existe genera un Name_Error
								exit;											-- Si existe lo abre y sale del loop
							exception
								when Name_Error =>						-- No existe, entonces se crea
									--Put_Line ("Archivo no existe. Paso a crearlo");
									Create (Arch_sim, Name => Nombre_sim);	-- Se devuelve al comienzo delo loop para abrir el archivo creado
								when Status_Error =>
									--Put_Line ("El archivo ya estÃ¡ abierto. Sigo");
									exit;
								when Use_Error =>		-- No se puede abrir o crear
									--Put_Line ("No he podido crear o abrir el archivo. Salgo del programa");
									regreso_sim := False;
							end;
						end loop;
						limite_sim := it_sim;
						if regreso_sim = True then
							for i in 1..limite_sim loop
								Put_Line(Arch_sim, t_sim(i)'img & "," & y_sim(i)'img);
							end loop;
							Close (Arch_sim);
						end if;
				End;
				--Put_Line("Fin Tarea Controlador.");
				Run_c := False;
				vz_sim(1)	:= 0.0;
				vz_sim(2)	:= 0.0;
				End If;
		End loop;
	end Simular_Controlador;


	task body flujo_principal is begin
		-- FUZZY AUTO TUNING --
		Especificaciones_Curva(Nombre_Archivo, Tr_recibido, TAS_recibido, MP_recibido);
		--Put_Line("Datos leidos de:" & Nombre_Archivo & ", TAS:" & TAS_recibido'Img & ", MP:" & MP_recibido'Img);
		TAS.INICIAL 	:= TAS_recibido;
		TAS.ACTUAL 	:= TAS.INICIAL;
		For i in 1..2 loop
			--New_Line;
			--New_Line;
			--Put_Line("Aplicando loop del fuzzy logic");
			MP.VALOR 	:= MP_recibido;
			Tr		:= Tr_recibido;
			Fuzzificar;
			Inferencia_Fuzzy;
			Desfuzzificar;
			calcular_ganancias_pi(k,tau);
			mostrar_resultado;
			Run_c := True;
			Run_p := True;
			While (Run_c and Run_p) loop
				Delay(1.0);
				--Put_Line("Esperando por la aplicacion del lazo cerrado de prueba");
			Null;
			End loop;
			Delay(1.0);
			--Put_Line("Listo");
			Delay(1.0);
			Especificaciones_Curva("Fuzzy_loop.txt", Tr_recibido, TAS_recibido, MP_recibido);
			--Put_Line("Datos leidos de Fuzzy_Loop: TAS:" & TAS_recibido'Img & ", MP:" & MP_recibido'Img);
			TAS.ACTUAL 	:= TAS_recibido;
		End loop;
		mostrar_resultado;
		--X := guarda_resultado(Nombre_Salida);
	end flujo_principal;

	-- ------------------------------------------Fin del Tasking----------------------------------------------------------------------


begin
	Null;
end fuzzytuning;

