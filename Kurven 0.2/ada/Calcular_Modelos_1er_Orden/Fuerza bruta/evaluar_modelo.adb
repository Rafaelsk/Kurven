with Ada.Text_IO; 			use Ada.Text_IO;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with variables;				use variables;
with Ada.Command_Line;			use Ada.Command_Line;
with System;

-- *********** EVALUAR_MODELO.ADB ********************
-- Paquete que contiene los procedimientos y funciones usados para encontrar el valor de Tau por Fuerza Bruta
--
package body evaluar_modelo is


	procedure evalua_modelo ( kt, taut, Tt : in long_float ) is
		vz : Real_Vector(1..2) := ( (0.0), (0.0) );
	begin
		ISE := 0.0;
		for i in 1..n loop
			m(i)  := float( kt*Tt/(Tt+2.0*taut)*long_float(vz(1)+vz(2)) );
			vz(1) := float( r - (Tt-2.0*taut)/(Tt+2.0*taut)*long_float(vz(2)) );
			vz(2) := vz(1);
			err(i) := v(i)-m(i);
			ISE := ISE + long_float(err(i))**2;
		end loop;
	end evalua_modelo;

	function guarda_datos_modelos(Nombre_Salida : in string) return Boolean is
		Arch   : File_Type;
		regreso : Boolean := True;
	begin
		-- Crea o abre el archivo de datos
		loop
			begin
				Open ( Arch, Out_File, Nombre_Salida );		-- Si el archivo no existe genera un Name_Error
				exit;											-- Si existe lo abre y sale del loop
			exception
				when Name_Error =>						-- No existe, entonces se crea
					Put_Line ("Archivo no existe. Paso a crearlo");
					Create (Arch, Name => Nombre_Salida);	-- Se devuelve al comienzo delo loop para abrir el archivo creado
				when Status_Error =>
					Put_Line ("El archivo ya estÃ¡ abierto. Sigo");
					exit;
				when Use_Error =>		-- No se puede abrir o crear
					Put_Line ("No he podido crear o abrir el archivo. Salgo del programa");
					regreso := False;
			end;
		end loop;
		if regreso = True then
			--Put_Line( Arch,kd'Img & "," & mtau'img & "," & mISE'img);
			for i in 1..n loop
				Put_Line(Arch, t(i)'img & "," & mfb(i)'img);
			end loop;
			Close (Arch);
		end if;
		return regreso;
	end guarda_datos_modelos;

		procedure lee_archivo_datostxt is
		Arch   : File_Type;
	   Nombre : String := "datos.txt";
   	Conta  : Natural := 0;				-- Contador de lÃ­neas leÃ­das
   	indb	 : Natural;
	begin
   	Open ( Arch, In_File, Nombre );
	   while not End_Of_File (Arch) loop
      	declare
         	Linea : String := Get_Line (Arch);
      	begin
         	Conta := Conta + 1;
         	--Put_Line (Linea);
         	indb := Index( Linea(1..Linea'Length), "," );
         	t(Conta) := float'Value( Trim( Linea(1 .. indb-1 ), Both ) );
         	Replace_Slice ( Linea, 1, indb, "" );
         	v(Conta) := float'Value( Trim( Linea(1 .. Linea'Last ), Both ) );
         	--Put_Line( "   (" & t(Conta)'img & "," & v(Conta)'img & " )" );
      	end;
   	end loop;
   	Close (Arch);
   	--Put_Line( "He leÃ­do " & Conta'img & " puntos." );
   	n := Conta;
   	Ts := long_float( t(2) - t(1) );
   end lee_archivo_datostxt;

	procedure lee_archivo_de_datos(Nombre_Salida: in String) is
		Arch   : File_Type;
   		Conta  : Natural := 0;				-- Contador de líneas leídas
   		indb	 : Natural;
	begin
   		Open ( Arch, In_File, Nombre_Salida);
	   while not End_Of_File (Arch) loop
      	declare
         	Linea : String := Get_Line (Arch);
      	begin
         	Conta := Conta + 1;
         	--Put_Line (Linea);
         	indb := Index( Linea(1..Linea'Length), "," );
         	t(Conta) := float'Value( Trim( Linea(1 .. indb-1 ), Both ) );
         	Replace_Slice ( Linea, 1, indb, "" );
         	v(Conta) := float'Value( Trim( Linea(1 .. Linea'Last ), Both ) );
         	Put_Line(t(Conta)'img & "," & v(Conta)'img);
      	end;
   	end loop;
   	Close (Arch);
   	--Put_Line( "He leído " & Conta'img & " puntos." );
  	end lee_archivo_de_datos;

end evaluar_modelo;
