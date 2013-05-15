with Ada.Text_IO; 				use Ada.Text_IO;
with Gnat.Sockets;				use Gnat.Sockets;
with Ada.Strings;				use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Command_Line;		use Ada.Command_Line;
with Ada.Real_Time;			use Ada.Real_Time;
with Ada.Float_Text_Io; 			use Ada.Float_Text_Io;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with System;

procedure controlador_b is
	Salida : Boolean := False;
	y, u, r : Float;

	task TareaControlador is	-- Servidor para el Controlador y Cliente para Servidor Planta
		pragma Priority (System.Max_Priority);
	end TareaControlador;

	task TareaServidor is	-- Servidor para el operador del sistema
		pragma Priority (System.Default_Priority);
	end TareaServidor;

	task body TareaControlador is		--se tiene que agregar kp y ki!!!
		Ts 				: constant Float 	:= Float'Value(Argument(1))/10.0;
		Periodo 			: Time_Span 		:= Milliseconds( Integer(Ts*1000.0) );	--time_span para representar intervalos de tiempo.
		Siguiente 		: Time;
		t_inicio 			: Time;
		Direccion_Planta 	: Sock_Addr_Type(Family_Inet);
		Hueco_Controlador_B : Socket_Type;
		Canal_Control_B	: Stream_Access;					-- Canal
		E				: Float;							--añadida - asignacion
		vz 				: Real_Vector(1..2) := ( (0.0), (0.0) );	--añadida - asignacion
		Kp				: constant float	:= Float'Value(Argument(2));
		Ki				: constant float	:= Float'Value(Argument(3));
	begin
		--Put_Line("Inicio Tarea Controlador.");
		Direccion_Planta	 := (	Family_Inet,
	   						Addresses( Get_Host_By_Name ("localhost" ), 1),
	   						Port_Type(50002 ) );
		Create_Socket (Hueco_Controlador_B);
		Connect_Socket (Hueco_Controlador_B, Direccion_Planta);
		Canal_Control_B := Stream (Hueco_Controlador_B);   -- Asocia un stream con el socket
   		t_inicio := Clock;
   		Siguiente := t_inicio;
   	loop
		E  := r - y;
		vz(1) := E + vz(2);
	   	u := ((Ki*Ts+2.0*Kp)/2.0)*vz(1) + ((Ki*Ts-2.0*Kp)/2.0)*vz(2);
		--Put( Float( To_Duration( Clock - t_inicio ) ), 1, 2, 0 );
		Put_Line(u'img);
		String'Output( Canal_Control_B, "ACT:" & u'img );			-- Envía Acc. de control a la planta y solicita valor de la salida
		declare				   			-- Espera la respuesta desde el Servidor ( y )
			Mensaje : String := String'Input(Canal_Control_B); 		-- toma mensaje desde el stream
		begin
			y := Float'Value( Trim( Mensaje(1 .. Mensaje'Length ), Both ) );	--trim quita los espacios en blanco al inicio y al final
		end;
		Siguiente := Siguiente + Periodo;
		delay until  Siguiente;
		vz(2) := vz(1);										--añadida - asignacion
		exit when Salida = TRUE;
	end loop;
		String'Output( Canal_Control_B, "FIN:" );			-- Envía el mensaje de finalización a la Planta
		delay(3.0);
		Close_Socket(Hueco_Controlador_B);
		--Put_Line("Comunicacion del Controlador B finalizada.");
   end TareaControlador;


	task body TareaServidor is			--esta tarea habla con el operador
		Sock, New_Sock : Socket_Type;
		Addr, Peer_Addr : Sock_Addr_Type(Family_Inet);
		S : Stream_Access;
	begin
		Create_Socket(Sock);
		Addr := (Family_Inet, Any_Inet_Addr, Port_Type( 50004)  );
		Bind_Socket(Sock, Addr);
		Listen_Socket(Sock);
		--Put_Line("Inicio Tarea Servidor del Controlador B");
		--Put_Line("Espero peticiones desde el Operador");
		Accept_Socket(Sock, New_Sock, Peer_Addr);
		S := Stream(New_Sock);
		loop
			declare
				Str : String := String'Input(S);   -- toma mensaje desde el stream
			begin
                                if Str(1..4) = "FIN:" then
                                        --Put_Line("Recibida la orden de Parada");
					Salida := True;
					exit;
				else
					if Str(1..4) = "ACT:" then			-- Recibe referencia desde el operador y le envia Acc. Control y Salida
						r := Float'Value( Trim( Str(5 .. Str'Last ), Both ) );

						String'Output( S, u'img & "," & y'img );
					end if;
				end if;
			end;
		end loop;
		delay(5.0);
		ShutDown_Socket(New_Sock,  Shut_Read_Write);
		Close_Socket(New_Sock);
		Close_Socket(Sock);
		--Finalize;
		--New_Line;
		--Put_Line( "Fin de la Tarea Servidor del Controlador." );
	end TareaServidor;

begin
	null;
end controlador_b;
