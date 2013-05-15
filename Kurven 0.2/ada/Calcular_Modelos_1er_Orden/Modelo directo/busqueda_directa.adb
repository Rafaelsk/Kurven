with Ada.Text_IO; 			use Ada.Text_IO;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with Interfaces.C; 			use Interfaces.C;
with Gnat.Sockets;			use Gnat.Sockets;
with variablesmd;			use variablesmd;
with Ada.Command_Line;	use Ada.Command_Line;
with System;

package body busqueda_directa is

	Procedure lee_archivo_de_datos(Nombre_Entrada : in String) is
		Arch	: File_Type;					-- Variable utilizada como fichero logico
		Mode : File_Mode 	:= In_File;			-- Abre el archivo en modo lectura.
		Conta  : Natural 	:= 0;				-- Contador de li­neas leidas
		indb	 : Natural	;
	begin
		Open ( Arch, In_File, Nombre_Entrada );
	   while not End_Of_File (Arch) loop
      	declare
         	Linea : String := Get_Line (Arch);
      	begin
         	Conta := Conta + 1;
         	indb := Index( Linea(1..Linea'Length), "," );
         	t(Conta) := float'Value( Trim( Linea(1 .. indb-1 ), Both ) );
         	Replace_Slice ( Linea, 1, indb, "" );
         	v(Conta) := float'Value( Trim( Linea(1 .. Linea'Last ), Both ) );
      	end;
		end loop;
		Close (Arch);
		n := Conta;
		Ts := long_float( t(2) - t(1) );
	end lee_archivo_de_datos;

	procedure calcula_k_tau is
		v63  : long_float;					-- Valor del 63%
		iv63 : integer;				-- Indice para el punto de 63%
		p1, p2, p3 : T_Punto;		-- Se definen 3 objetos, los cuales son de tipo COORDENADA. El tipo COORDENADA tiene 2 componentes: X y Y
	begin
		kd := long_float(v(n));
		v63 := long_float( v(n)*(1.0-exp(-1.0)) );
		iv63 := 1;
		while ( long_float(v(iv63)) < v63 ) loop
			iv63 := iv63 + 1;
		end loop;
		if (long_float(v(iv63)) = v63) then
			taud := long_float(t(iv63));			-- Si el valor es exacto, este es tau
		else												-- de lo contrario lo interpola
			p1.x := long_float(t(iv63-1));	-- Define la componente X de la coordenada P1
			p1.y := long_float(v(iv63-1));	-- Define la componente Y de la coordenada P1
			p2.x := long_float(t(iv63));	-- Define la componente X de la coordenada P2
			p2.y := long_float(v(iv63));	-- Define la componente Y de la coordenada P2
			p3 := parametros_recta( p1, p2 );	-- Hace P3 igual a regreso
			taud := (v63-p3.y)/p3.x;
		end if;
   end calcula_k_tau;

	function  parametros_recta( p1, p2 : in T_Punto) return T_Punto is
		regreso : T_Punto;
	begin
		regreso.x := (p2.y - p1.y) / (p2.x - p1.x);
		regreso.y := p2.y - regreso.x*p2.x;
		return regreso;
	end parametros_recta;




	procedure evalua_modelo is
		Ts : long_float;
		vz : Real_Vector(1..2) := ( (0.0), (0.0) );
		r: long_float := 1.0;
	begin
		ISEd := 0.0;
		Ts := long_float( t(2)-t(1) );
		for i in 1..n loop
			yd(i)  := float( kd*Ts/(Ts+2.0*taud)*long_float(vz(1)+vz(2)) );
			vz(1) := float (r - (Ts-2.0*taud)/(Ts+2.0*taud)*long_float(vz(2)) );
			vz(2) := vz(1);
			err(i) := v(i)-yd(i);
			ISEd := ISEd + long_float(err(i))**2;
		end loop;
	end evalua_modelo;




	function guarda_datos_modelo(Nombre_Salida : in string) return Boolean is
	   Arch   : File_Type;
	   regreso : Boolean := True;
	begin
		-- Crea o abre el archivo de datos
		loop
			begin
				Open ( Arch, Out_File, Nombre_Salida );		-- Si el archivo no existe genera un Name_Error
				exit;						-- Si existe lo abre y sale del loop
			exception
				when Name_Error =>				-- No existe, entonces se crea
					--Put_Line ("Archivo no existe. Paso a crearlo");
					Create (Arch, Name => Nombre_Salida);		-- Se devuelve al comienzo delo loop para abrir el archivo creado
				when Status_Error =>
					--Put_Line ("El archivo ya estÃ¡ abierto. Sigo");
					exit;
				when Use_Error =>				-- No se puede abrir o crear
					--Put_Line ("No he podido crear o abrir el archivo. Salgo del programa");
					regreso := False;
			end;
		end loop;
		if regreso = True then
			Put_Line(Arch, kd'img & "," & taud'img & "," & ISEd'img);
			for i in 1..n loop
				Put_Line(Arch, t(i)'img & "," & yd(i)'img);
			end loop;
			Close (Arch);
		end if;
		return regreso;
	end guarda_datos_modelo;




	procedure imprimir_datos_modelo is
	begin
			Put_Line(kd'img & "," & taud'img & "," & ISEd'img);
			for i in 1..n loop
				Put_Line(t(i)'img & "," & yd(i)'img);
			end loop;
	end imprimir_datos_modelo;




end busqueda_directa;
