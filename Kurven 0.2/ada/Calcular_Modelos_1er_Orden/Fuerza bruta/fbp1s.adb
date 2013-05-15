
with Ada.Text_IO; 		use Ada.Text_IO;
with Gnat.Sockets;		use Gnat.Sockets;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;	use Ada.Strings.Fixed;
with Ada.Command_Line;	use Ada.Command_Line;
with System;
with variables;			use variables;
with evaluar_modelo;			use evaluar_modelo;

procedure fbp1s is
	Sock, New_Sock : Socket_Type;
	--Puerto : Natural := 50000;
	Addr, Peer_Addr : Sock_Addr_Type(Family_Inet);
	S : Stream_Access;
	--Mensaje : String(1..1024);
	--LongMens : Integer;
	indb : Natural;
	kd : long_Float;
	taud : long_Float;
	tempB : Boolean;
	Nombre_Salida : String := Argument(4);
	task tareafb is
      pragma Priority (System.Max_Priority);
   end tareafb;

   task body tareafb	is
   begin
   		lee_archivo_datostxt;
		kd := long_float'Value( Argument(2));
		taud := long_float'Value( Argument(3));
		evalua_modelo(kd, taud, Ts);
		ISEd := ISE;		-- ISE del modelo directo
		--Put_Line( "ISE =" & ISEd'img );
		md := m;				-- Vector de respuesta del modelo
		errd := err;		-- Vector de errores del modelo
		mISE := ISE;

		Create_Socket(Sock);
		--Addr := (Family_Inet, Any_Inet_Addr, Port_Type(Puerto) );
		Addr := (Family_Inet, Any_Inet_Addr, Port_Type( Natural'Value( Argument(1) ) ) );
		Bind_Socket(Sock, Addr);
		Listen_Socket(Sock);
		--Put_Line("Espero peticiones desde el Cliente");
		Accept_Socket(Sock, New_Sock, Peer_Addr);
		S := Stream(New_Sock);
		loop
			declare
				Str : String := String'Input(S);   -- toma mensaje desde el stream
			begin
--Put_Line(Str);
				if Str(1..4) = "FIN:" then
					exit;
				else
					if Str(1..4) = "PARA" then		-- Recibe parámetros y ejecuta FB
						indb := Index( Str(1..Str'Length), "," );
						tau_min := long_float'Value( Trim( Str(6 .. indb-1 ), Both ) );
--Put_Line(tau_min'img);
						Replace_Slice ( Str, 1, indb, "" );	indb := Index( Str(1..Str'Length), "," );
						tau_max := long_float'Value( Trim( Str(1 .. indb-1 ), Both ) );
--Put_Line(tau_max'img);
						Replace_Slice ( Str, 1, indb, "" );	indb := Index( Str(1..Str'Length), "," );
						tau_paso := long_float'Value( Trim( Str(1 .. Str'Last ), Both ) );
--Put_Line(tau_paso'img);


						tau_temp := tau_min;
						contag := 0;
						indice := 1;
						contador := 0;
						--Put_Line( "Empezando Fuerza bruta con:" );
						--Put_Line( "  kd =" &kd'img );
						--Put_Line( "   tau_min =" & tau_min'img );
						--Put_Line( "   tau_max =" & tau_max'img );
						--Put_Line( "   tau_paso =" & tau_paso'img );
						--Put_Line( "   Ts =" & Ts'img );
						while (tau_temp <= tau_max) loop
							evalua_modelo(kd, tau_temp, Ts);
							ISE_temp := ISE;
							if (ISE_temp < mISE) then
								mISE := ISE_temp;
								mtau := tau_temp;
								mfb := m;
								errfb := err;
							end if;
							--contag := contag + 1;
							--if (contag > contaglim) then
								--taus(indice) := float(tau_temp);
								--ISEs(indice) := float(ISE_temp);
								--indice := indice + 1;
								--contag := 0;
							--end if;
							tau_temp := tau_temp + tau_paso;
							contador := contador + 1;
						end loop;
						indice := indice - 1;
						--Put_Line( "ISE =" & ISEd'img );
						New_Line;
						--Put_Line( "Mi Fuerza Bruta:" );
						--Put_Line( "   tau =" & mtau'img );
						--Put_Line( "   ISE =" & mISE'img );
						tempB := guarda_datos_modelos(Nombre_Salida);
					elsif Str(1..4) = "DAME" then		-- Recibe solicitud de enviar Mejores tau e ISE
						String'Output( S, mtau'img & "," & mISE'img );
					end if;	-- if Str(1..4)
				end if;		-- if Str = "Fin"
			end;	-- declare
		end loop;
		ShutDown_Socket(New_Sock,  Shut_Read_Write);
		Close_Socket(New_Sock);
		Close_Socket(Sock);
		Finalize;
		--New_Line;
		--Put_Line( "Fin del Programa Servidor." );
   end tareafb;

begin
	null;
end fbp1s;

