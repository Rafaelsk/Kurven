with Ada.Text_IO; 				use Ada.Text_IO;
with Gnat.Sockets;				use Gnat.Sockets;
with Ada.Strings;				use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Command_Line;		use Ada.Command_Line;
with Ada.Real_Time;			use Ada.Real_Time;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with Ada.Float_Text_Io; 			use Ada.Float_Text_Io;
with System;
with Ada.Exceptions; use Ada.Exceptions;

procedure planta is
--############################## DECLARACIONES GLOBALES #################################
        Salida, Error_Controlador_A, Error_Controlador_B: Boolean := False;
        y, u, uA, uB	: Float	:= 0.0;

	task TareaPlanta is
		pragma Priority (System.Max_Priority);
        end TareaPlanta;

	task ControlRedundancia is
		pragma Priority (System.Default_Priority);
	end ControlRedundancia;

	task TareaServidorControlA is
		pragma Priority (System.Default_Priority);
	end TareaServidorControlA;

	task TareaServidorControlB is
		pragma Priority (System.Default_Priority);
	end TareaServidorControlB;

--################################### PLANTA #################################
	task body TareaPlanta	is
		k		: Float 			:= Float'Value(Argument(1));
		tau		: Float 			:= Float'Value(Argument(2));
		vz		: Real_Vector(1..2) 	:= ( (0.0), (0.0) );
		Ts		: Float 			:= (Float'Value(Argument(3)));		--RECORDAR QUE TIENE QUE SER UN PERIODO DE MUESTREO DE 0.1 SEGUNDOS
		Periodo 	: Time_Span 		:= Milliseconds( Integer(Ts*1000.0) );	--time_span para representar intervalos de tiempo.
		Siguiente	: Time;										--Time para representar un valor absoluto
		t_inicio	: Time;
	begin
		--Put_Line("Inicio Tarea Planta.");
		t_inicio 	:= Clock;										--Se guarda el momento que inicio la tarea en la variable "t_inicio"
		Siguiente := t_inicio;									--Hace que Siguente tome el tiempo de inicio de la tarea.
		loop
			vz(1) := u - (Ts-2.0*tau)/(Ts+2.0*tau)*Float(vz(2));			--Segundo, V1 es igual a la accion de control mas la retroalimentacion por la V2
			y  	:= k*Ts/(Ts+2.0*tau)*Float(vz(1)+vz(2));				--Primero, declara que la salida es la parte constante por las dos variables V1 y V2
			--Put( Float( To_Duration( Clock - t_inicio ) ), 1, 2, 0 );		--Pone el momento que se calculo "y" con 1 caracter antes del punto, con dos digitos decimales, y sin exponciacion cientifica
			Put_Line(y'img);						--Se coloca la accion de control y la salida
			Siguiente := Siguiente + Periodo;						--Define cuanto tiempo se tiene que esperar para que la planta se despierte cada Ts*1000.0
			delay until  Siguiente;								--Espera
			vz(2) := vz(1);										--Despues del delay, V2 es igual a V1
			exit when Salida = TRUE;							--Sale si la salida es positiva
                end loop;
                delay(3.0);
		--Put_Line("Planta Apagada...");
        end TareaPlanta;


--############################## CONTROL DE REDUNDANCIA #############################
	task body ControlRedundancia	is
                dossegundos	: Time;
                contador 	:integer	:=0;
        begin
                loop
                        case Error_Controlador_A is
                                when False	=> u	:= uA;
                                when True	=> u	:= uB;
			end case;
                        if Error_Controlador_A and Error_Controlador_B and contador<2 then
                                --New_Line;
                                --New_Line;
                                --Put_Line("Emergencia: Planta Sin Control!!!");
                                --Put_Line("Apagando Planta....");
                                --New_Line;
                                --New_Line;
				dossegundos	:= clock + Milliseconds(2000);
                                Delay until dossegundos;
                                Salida 	:= TRUE;
                                contador	:= contador+1;
                        end if;
                        if contador=10 then
                                exit;
			end if;
                end loop;
	end ControlRedundancia;

--############################## SERVIDOR PARA EL CONTROLADOR A #################################
	task body TareaServidorControlA is
		Direccion_Control_A	: Sock_Addr_Type(Family_Inet);
		Puerto_Control_A		: Natural		:=50001;
		Hueco_Planta			: Socket_Type;
		Hueco_Control_A		: Socket_Type;
		Canal_Control_A		: Stream_Access;
	begin
		--Put_Line("Configurando Conexion con Controlador A");
		Create_Socket(Hueco_Planta);
		Direccion_Control_A	:= (Family_Inet, Any_Inet_Addr, Port_Type(Puerto_Control_A));
		Bind_Socket(Hueco_Planta, Direccion_Control_A);
		Listen_Socket(Hueco_Planta);
		--Put_Line("Esperando conexion del controlador A");
		Accept_Socket(Hueco_Planta, Hueco_Control_A, Direccion_Control_A);
		Canal_Control_A		:=stream(Hueco_Control_A);
		--Put_Line("Conexion con el Controlador A Establecida");
		loop
			declare
				Mensaje : String := String'Input(Canal_Control_A);   	-- toma mensaje desde el stream
			begin
                                if Mensaje(1..4) = "FIN:" then
                                        Salida := True;
					exit;
				else
					if Mensaje(1..4) = "ACT:" then				-- Recibe acción de control y envía salida
						uA := Float'Value( Trim( Mensaje(5 .. Mensaje'Last ), Both ) );
						String'Output( Canal_Control_A, y'img );
					end if;
				end if;
			end;
		end loop;
		ShutDown_Socket(Hueco_Control_A,  Shut_Read_Write);
		Close_Socket(Hueco_Control_A);
		Close_Socket(Hueco_Planta);
		--New_Line;
		--Put_Line( "Comunicacion con Controlador A Finalizada" );
       Exception
                when Host_Error=>
                        --New_Line;
			--New_Line;
                       -- Put_Line("Problemas en comunicacion con Controlador B");
			Error_Controlador_A := true;
			--New_Line;
                       -- New_Line;
                when socket_error=>
                       -- New_Line;
			--New_Line;
                       -- Put_Line("Problemas en comunicacion con Controlador A");
			Error_Controlador_A := true;
			--New_Line;
                      --  New_Line;
               when E : others =>
                       -- Ada.Text_IO.Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
                        --New_Line;
			--New_Line;
                        --Put_Line("Problemas en comunicacion con Controlador A");
			Error_Controlador_A := true;
			--New_Line;
                        --New_Line;
	end TareaServidorControlA;

--############################## SERVIDOR PARA EL CONTROLADOR B #################################
	task body TareaServidorControlB is
		Direccion_Control_B		: Sock_Addr_Type;
		Puerto_Control_B		: Natural		:= 50002;
		Hueco_Planta			: Socket_Type;
		Hueco_Control_B		: Socket_Type;
		Canal_Control_B		: Stream_Access;
	begin
                --Put_Line("Configurando Conexion con Controlador B");
		Direccion_Control_B	:= (Family_Inet, Any_Inet_Addr, Port_Type(Puerto_Control_B));
		Create_Socket(Hueco_Planta);
		Bind_Socket(Hueco_Planta, Direccion_Control_B);
		Listen_Socket(Hueco_Planta);
		--Put_Line("Esperando conexion del controlador B");
		Accept_Socket(Hueco_Planta, Hueco_Control_B, Direccion_Control_B);
		Canal_Control_B 	:=stream(Hueco_Control_B);
		--Put_Line("Conexion con el Controlador B Establecida");
		loop
			declare
				Mensaje : String := String'Input(Canal_Control_B); 		-- toma mensaje desde el stream
			begin
                                if Mensaje(1..4) = "FIN:" then
                                        Salida := True;
					exit;
				else
					if Mensaje(1..4) = "ACT:" then						-- Recibe acción de control y envía salida
						uB := Float'Value( Trim( Mensaje(5 .. Mensaje'Last ), Both ) );
						String'Output( Canal_Control_B, y'img );
					end if;
				end if;
			end;
                end loop;
		ShutDown_Socket(Hueco_Control_B,  Shut_Read_Write);
		Close_Socket(Hueco_Control_B);
		Close_Socket(Hueco_Planta);
		--New_Line;
		--Put_Line( "Fin de la Tarea Servidor de la Planta." );
        Exception
               when Host_Error=>
                        --New_Line;
			--New_Line;
                       -- Put_Line("Problemas en comunicacion con Controlador B");
			Error_Controlador_B := true;
			--New_Line;
                        --New_Line;
                when socket_error=>
                        --New_Line;
			--New_Line;
                       -- Put_Line("Problemas en comunicacion con Controlador B");
			Error_Controlador_B := true;
			--New_Line;
                        --New_Line;
                when E : others =>
                        --Ada.Text_IO.Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
                        --New_Line;
			--New_Line;
                        --Put_Line("Problemas en comunicacion con Controlador B");
			Error_Controlador_B := true;
			--New_Line;
                        --New_Line;
	end TareaServidorControlB;

begin
	null;
end planta;

