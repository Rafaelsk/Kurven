with Ada.Text_IO; 		use Ada.Text_IO;
with Gnat.Sockets;		use Gnat.Sockets;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;	use Ada.Strings.Fixed;
with Ada.Command_Line;	use Ada.Command_Line;
with System;
with Ada.Real_Time;		use Ada.Real_Time;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

procedure operador is
        Salida, APAGATE : Boolean := False;
        y_A, y_B, uA, uB, r : Float;

        task interfaz is	-- Controlador y Cliente para Servidor Planta
                pragma Priority (System.Default_Priority);
        end interfaz;

        task TareaCliente_A is	-- Controlador y Cliente para Servidor Planta
                pragma Priority (System.Default_Priority);
        end TareaCliente_A;

        task TareaCliente_B is	-- Controlador y Cliente para Servidor Planta
                pragma Priority (System.Default_Priority);
        end TareaCliente_B;


 task body interfaz is
                Cadena : String(1..80);
                lon : Natural;

        begin
                loop
			--Put("FIN ó REFERENCIA : ");
			Get_Line( Cadena, lon );
                        if Cadena(1..3)="FIN" or Cadena(1..3)="fin" or Cadena(1..3)="Fin" or APAGATE=true then
                                APAGATE:=true;
				exit;
			else
				r := Float'Value( Trim( Cadena(1 .. lon ), Both ) );
                        end if;
                end loop;
		delay(3.0);
        end interfaz;



        task body TareaCliente_A is
		Controlador_A 		: Sock_Addr_Type(Family_Inet);
		Hueco_Para_A			: Socket_Type;
		Canal_A				: Stream_Access;
		indb_A : Natural;

	begin
		--Put_Line("Enlazado con el Controlador A.");
                Controlador_A := (	Family_Inet, Addresses( Get_Host_By_Name ( "localhost" ), 1), Port_Type(50003) );
                Create_Socket (Hueco_Para_A);
                Connect_Socket (Hueco_Para_A, Controlador_A);
                Canal_A := Stream (Hueco_Para_A);
   	loop
                        if APAGATE=true then
                                APAGATE:=true;
				exit;
			else
                                String'Output( Canal_A, "ACT:" & r'img );
				declare				   									-- Espera la respuesta desde el Servidor ( y )
                                        Mensaje_A : String := String'Input(Canal_A);
				begin
                                        indb_A := Index( Mensaje_A, "," );
                                        uA := Float'Value( Trim( Mensaje_A(1 .. indb_A-1 ), Both ) );
                                        Replace_Slice ( Mensaje_A, 1, indb_A, "" );
                                        y_A := Float'Value( Trim( Mensaje_A(1 .. Mensaje_A'Length ), Both ) );
                                        --Put_Line("Estado del Controlador A: " & uA'img & "  " & y_A'img);
				end;
			end if;
		end loop;
                String'Output( Canal_A, "FIN:" );
		delay(1.0);
                Close_Socket(Hueco_Para_A);
		--Put_Line("Fin Tarea Cliente del Operador.");
        end TareaCliente_A;

	 task body TareaCliente_B is
                Controlador_B 		: Sock_Addr_Type(Family_Inet);
		Hueco_Para_B			: Socket_Type;
		Canal_B				: Stream_Access;		-- Canal
		indb_B : Natural;
	begin
		--Put_Line("Enlazado con el Controlador B");
                Controlador_B := (	Family_Inet, Addresses( Get_Host_By_Name ( "localhost" ), 1), Port_Type(50004) );
                Create_Socket (Hueco_Para_B);
                Connect_Socket (Hueco_Para_B, Controlador_B);
                Canal_B := Stream (Hueco_Para_B);
   	loop
                        if APAGATE=true then
                                APAGATE:=true;
				exit;
			else
                                String'Output( Canal_B, "ACT:" & r'img );
				declare				   									-- Espera la respuesta desde el Servidor ( y )
                                        Mensaje_B : String := String'Input(Canal_B);
				begin
                                        indb_B := Index( Mensaje_B, "," );
                                        uB := Float'Value( Trim( Mensaje_B(1 .. indb_B-1 ), Both ) );
                                        Replace_Slice ( Mensaje_B, 1, indb_B, "" );
                                        y_B := Float'Value( Trim( Mensaje_B(1 .. Mensaje_B'Length ), Both ) );
                                        --Put_Line("Estado del Controlador B: " & uB'img & "  " & y_B'img);
				end;
			end if;
		end loop;
                String'Output( Canal_B, "FIN:" );
		delay(1.0);
                Close_Socket(Hueco_Para_B);
                --Put_Line("Fin Tarea Cliente del Operador para Controlador B.");
        end TareaCliente_B;

begin
	null;
end operador;

