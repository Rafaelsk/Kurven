with Ada.Text_IO; 					use Ada.Text_IO;
with Gnat.Sockets;				use Gnat.Sockets;
with Ada.Strings;					use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Command_Line;	use Ada.Command_Line;
with System;
with variables;						use variables;
with evaluar_modelo;			use evaluar_modelo;

-- Nodo Principal: Busca (con la ayuda de fbp1s) el mejor valor de tau segun recorrido y comparacion ISE
-- Argumentos:
-- |----------------Nodo fbp1c----------------------------------+-----------------Nodo fbp1s--------------------------|
-- | (1) Direccion IP. Por defecto: Localhost			| (1) Puerto. Por defecto 50000                       |
-- | (2) Puerto. Por defecto 50000				| (2) K: Ultima ganancia de la planta a mejorar       |
-- | (3) K: Ultima ganancia de la planta a mejorar el modelo	| (3) Tau: Tau preliminar		       	      |
-- | (4) Taud: Tau preliminar de la planta a mejorar		| (4) Nombre del archivo que se guardara el resultado |
-- | (5) Presicion: Presicion del calculo de FB			|					       	      |
-- | (6) Nombre del archivo que se guardara el resultado	|					              |
-- |------------------------------------------------------------+-----------------------------------------------------+
procedure fbp1c is
	--Puerto : Natural := 50000;
	Server_Addr : Sock_Addr_Type(Family_Inet);
	Sock		: Socket_Type;
	S			: Stream_Access;		-- Canal
	indb : Natural;
	tau_pro : long_float;
	mtau2, mISE2 : long_float;
	kd : long_Float;
	taud : long_Float;
	tempB : Boolean;
	Nombre_Salida	: String := Argument(6);
	task tareafb is
      pragma Priority (System.Max_Priority);
   end tareafb;

   task body tareafb	is
	begin
		lee_archivo_datostxt;
		kd := long_float'Value( Argument(3));
		taud := long_float'Value( Argument(4));
		--Ts := long_float'Value( Argument(5));
		evalua_modelo(kd, taud, Ts);
		ISEd := ISE;		-- ISE del modelo directo
		--Put_Line( "ISE =" & ISEd'img );
		--Put_Line( "KD =" & kd'img );
		--Put_Line( "TAUD =" & taud'img);
		--Put_Line( "TS =" & Ts'img );
		md := m;				-- Vector de respuesta del modelo
		errd := err;		-- Vector de errores del modelo

		-- Fuerza Bruta
		mISE := ISEd;
		mtau := taud;
		tau_min := 0.95*taud;
		tau_max := 1.05*taud;
		tau_paso := long_float'Value( Argument(5));
		--tau_paso := 0.5E-7;
		tau_pro := ( tau_max + tau_min ) / 2.0;
		--contaglim := integer( (tau_max-tau_min)/tau_paso/long_float(mcpg) ) + 1;

		Initialize;		-- Inicializa los sockets de forma no bloqueante
		Server_Addr := (	Family_Inet,
		   					Addresses( Get_Host_By_Name ( Argument(1) ), 1),
		   					Port_Type( Natural'Value( Argument(2) ) ) );
		--Server_Addr := (	Family_Inet,
		--  						Addresses( Get_Host_By_Name ( "localhost" ), 1),
		--  						Port_Type( Puerto ) );
		Create_Socket (Sock);

		Connect_Socket (Sock, Server_Addr);
				--Put_Line( "LANZANDO DATOS:"& long_float(tau_pro+tau_paso)'img & "," & tau_max'img & "," & tau_paso'img);
		S := Stream (Sock);   -- Asocia un stream con el socket


		String'Output( S, "PARA:" & long_float(tau_pro+tau_paso)'img & "," & tau_max'img & "," & tau_paso'img);
		--Put_Line( "Empezando Fuerza bruta con:" );
		--Put_Line( "  kd =" &kd'img );
		--Put_Line( "   tau_min =" & tau_min'img );
		--Put_Line( "   tau_max =" & tau_max'img );
		--Put_Line( "   tau_paso =" & tau_paso'img );
		--Put_Line( "   Ts =" & Ts'img );
		tau_temp := tau_min;
		--contag := 0;
		indice := 1;
		contador := 0;
		while (tau_temp <= tau_pro) loop
			evalua_modelo(kd, tau_temp, Ts);	--evalua modelo con los pasos
			ISE_temp := ISE;								--guarda el ISE evaluado
			if (ISE_temp < mISE) then				--Verifica si es mejor que el que tenia
				mISE := ISE_temp;						--
				mtau := tau_temp;
				mfb := m;
				errfb := err;
			end if;
			--contag := contag + 1;
			--if (contag > contaglim) then
			--	taus(indice) := float(tau_temp);
			--	ISEs(indice) := float(ISE_temp);
			--	indice := indice + 1;
			--	contag := 0;
			--end if;
			tau_temp := tau_temp + tau_paso;
			contador := contador + 1;
		end loop;
		--indice := indice - 1;
		--Put_Line( "Mi Fuerza Bruta:" );
		--Put_Line( "   tau =" & mtau'img );
		--Put_Line( "   ISE =" & mISE'img );
		String'Output( S, "DAME" );			-- Envía el mensaje a la stream pidiendo mtau e mISE desde el núcleo 2
		declare
			Str : String := String'Input(S);   -- toma mensaje desde el stream
		begin
--New_Line;
--Put_Line("Recibido desde el otro núcleo:");
--Put_Line(Str);
--New_Line;
			indb := Index( Str, "," );
			mtau2 := long_float'Value( Trim( Str(1 .. indb-1 ), Both ) );
			Replace_Slice( Str, 1, indb, "" );
			mISE2 := long_float'Value( Trim( Str(1 .. Str'Last ), Both ) );
		end;
		String'Output( S, "FIN:" );			-- Envía el mensaje a la stream pidiendo al nucleo 2 detener su ejecución
		Close_Socket(Sock);
		Finalize;

		-- Decide cual es el mejor
		if mISE2 <= mISE then
			mISE := mISE2;
			mtau := mtau2;
			--Put("Fue el otro nodo!");
		else
		tempB:= guarda_datos_modelos(Nombre_Salida);
		--Put("Fui yo!");
		end if;
		--New_Line;
		--Put_Line( "Mejor Fuerza Bruta:" );
		Put_Line( mtau'img & "," & mISE'img);
		--Put_Line( "   ISE =" & mISE'img );
		--grafica;
		--grafica_historia;

		--New_Line;
 		 --Put_Line( "Fin del Programa." );
 	 	lee_archivo_de_datos(Nombre_Salida);
	end tareafb;

begin
	null;
end fbp1c;

