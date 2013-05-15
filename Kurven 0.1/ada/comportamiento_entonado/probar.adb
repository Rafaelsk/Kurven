with Ada.Text_IO; 				use Ada.Text_IO;
with Ada.Command_Line;		use Ada.Command_Line;
with System;
with Ada.Real_Time;			use Ada.Real_Time;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
--Dato importante: Cuando se simula la planta con el controlador, tiene que aumentarse el tiempo de muestreo para tomar mas detalles del comportamiento transitorio.**VER LINEA 13**

procedure probar is
	y, u 			: Float;
	Salida 		: Boolean 			:= False;
	k  			: constant Float		:= Float'Value(Argument(1));
	tau 			: constant Float		:= Float'Value(Argument(2));
	Ts 			: constant Float 		:= Float'Value(Argument(3))/10.0;	--Tiempo de muestreo con que se simulara la planta **MIRA AQUI**
	n			: constant Integer		:= Natural'Value(Argument(4));	--Con cuantos segundos se desea probar el controlador
	Kp			: constant float		:= Float'Value(Argument(5));
	Ki			: constant float		:= Float'Value(Argument(6));
	Periodo 		: constant Time_Span 	:= Milliseconds(Integer(10.0*Ts));
	Tiempo_Simul	: integer				:= 0;						--Tiempo total de prueba del controlador
	it			: integer				:= 0;						--Iteraciones que se tiene que hacer para lograr los segundos deseados


	task Simular_Planta is
		pragma Priority (System.Max_Priority);
	end Simular_Planta;

	task Simular_Controlador is
		pragma Priority (System.Default_Priority);
	end Simular_Controlador;

	task body Simular_Planta is
		vz 			: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
		Siguiente 	: Time;
		t_inicio 		: Time;
		t			: Real_Vector(0..1000) := (others => 0.0);	--Limite de puntos que se mediran
	begin
		--Put_Line("Inicio Tarea Planta.");
		t_inicio  		:= Clock;
		Siguiente 	:= t_inicio;
		Tiempo_Simul 	:= Integer(Ts*10.0*Float(n));				--Tiempo de simulacion en SEGUNDOS
		--Put_Line("Tiempo de simulacion: " & Tiempo_Simul'img & " segundos");
		--Put_Line("Ts=" & Ts'img);
		it 			:= integer(Ts*float(Tiempo_Simul)*100.0);
		--Put_Line("iteraciones: " & it'Img);
		for i in 1..it loop
			vz(1) 	:= u - (Ts-2.0*tau)/(Ts+2.0*tau)*(vz(2));		--Segundo, V1 es igual a la accion de control mas la retroalimentacion por la V2
			y 		:= k*Ts/(Ts+2.0*tau)*(vz(1)+vz(2));			--Primero, declara que la salida es la parte constante por las dos variables V1 y V2
			--Put( Float( To_Duration( Clock - t_inicio ) ), 1, 2, 0 );	--Pone el momento que se calculo "y" con 1 caracter antes del punto, con dos digitos decimales, y sin exponciacion cientifica
			t(i)		:= float(i)*Ts;
			Put_Line(t(i)'img & "," & y'img);					--Se coloca la accion de control y la salida
			Siguiente	:= Siguiente + Periodo;					--Define cuanto tiempo se tiene que esperar para que la planta se despierte cada Ts*1000.0
			delay until  Siguiente;							--Espera
			vz(2) := vz(1);									--Despues del delay, V2 es igual a V1
		end loop;
		Salida	:= True;
		--Put_Line("Fin Tarea Planta.");
	end Simular_Planta;

	task body Simular_Controlador is
		Siguiente 	: Time;
		t_inicio 		: Time;
		E			: Float;
		vz 			: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
		Tsc			: constant Float 	:= TS/10.0;
	begin
		--Put_Line("Inicio Tarea Controlador.");
   		t_inicio := Clock;
		Siguiente := t_inicio;
		loop
			--Put_Line("loop del controlador!");
			E  := k - y;
			vz(1) := E + vz(2);
			u := ((Ki*Tsc+2.0*Kp)/2.0)*vz(1) + ((Ki*Tsc-2.0*Kp)/2.0)*vz(2);
			Siguiente := Siguiente + Periodo;
			--Put_Line("Accion de Control:" & u'Img);
			delay until  Siguiente;
			vz(2) := vz(1);										--añadida - asignacion
			exit when Salida = True;
		end loop;
		--Put_Line("Fin Tarea Controlador.");
	end Simular_Controlador;

begin
	null;
end probar;
