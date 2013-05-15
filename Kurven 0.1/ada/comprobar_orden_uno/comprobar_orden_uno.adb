with Ada.Text_IO; 						use Ada.Text_IO;
with Ada.Strings;						use Ada.Strings;
with Ada.Strings.Fixed;					use Ada.Strings.Fixed;
with Ada.Numerics.Elementary_Functions;	use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Real_Arrays;  			use Ada.Numerics.Real_Arrays;

procedure comprobar_orden_uno is
	n :	integer :=	300;
	t :	array(integer range 1..n) of float;
	vo :	array(integer range 1..n) of float;
	vl :	array(integer range 1..n) of float;
	angulo_de_inclinacion :	array(integer range 1..n) of float;
	vlf :	float := 0.0; --valor logaritmico del ultimo valor muestreado
	--Ylog :	array(integer range 1..n) of float;
	m :	array(integer range 1..n) of float;
	Arch   : File_Type;
	Nombre : String := "datos.txt";
	indb	 : Natural;
	Ts	:	float := 0.0;
	Conta  : integer := 0;
	Conta2 :	integer := 1;
	Conta3: integer:= 2;
	Conta4: integer:= 2;
	X : float := 0.0;
	Respuesta : integer:= 1;
	diferencia_angular :float :=0.0;
	type coordenada is
		record
			x : float;
			y : float;
		end record;
	p1, p2 : coordenada;
begin
--Leer Archivos de datos--
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
			vo(Conta) := float'Value( Trim( Linea(1 .. Linea'Last ), Both ) );
			--Put_Line(t(Conta)'img & "," & vo(Conta)'img);
		end;
	end loop;
	n := Conta;
   	Ts := float( t(2) - t(1) );
	Close (Arch);
	--Put_Line( "He leído " & n'img & " puntos." );

	--Convertir datos logaritmicos (SUPONIENDO QUE EL PRIMER DATO ES CERO, es decir: se salta el primer valor )!!!!--
	for i in 1..(n-5)  loop
		--vl(0): NO ESTA DEFINIDO
		Conta2 := Conta2 + 1;
		X := abs(vo(Conta2) - vo(n));
		vl(Conta2) := Log(X,10.0);
		--Put_Line( " --- Punto logaritmico= " & vl(Conta2)'img & " --------------------------->  ABS((Log(" & vo(Conta2)'img & " - " & vo(n)'img  & "))  ");
	end loop;

	--Comprobar que los datos logaritmicos forman una recta (EMPIEZA A PARTIR DEL SEGUNDO VALOR MUESTREADO, SUPONIENDO QUE ESTE NO ES CERO)--
	for i in 1..n-4  loop
		p1.x := float(t(Conta3));
		p1.y := float(vl(Conta3));
		p2.x := float(t(Conta3+1));
		p2.y := float(vl(Conta3+1));
		m(Conta3) := (p2.y - p1.y) / (p2.x - p1.x);
		--Put_Line(p1.x'Img & p1.y'Img & p2.x'Img & p2.y'Img & "---------------------> " & m(Conta3)'img & "            Conta3: " & Conta3'img);
		Conta3 := Conta3 + 1;
	end loop;

	--Comprobar si las pendientes son parecidas
	--El arcotangente de una pendiente, indica el angulo que forma la pendiente con el eje horizontal
 	--Estableciendo que la recta no debe desviarse en mas de 3 grados, para que sea una recta....
	--Conta4 esta inicializado como: 2
	for i in 1..(n/2) loop
		angulo_de_inclinacion(Conta4) := Arctan(m(Conta4),1.0,360.0);
		angulo_de_inclinacion(Conta4+1) := Arctan(m(Conta4+1),1.0,360.0);
		diferencia_angular := abs(angulo_de_inclinacion(Conta4)-angulo_de_inclinacion(Conta4+1));
		--Put_Line("diferencia angular actual: " & diferencia_angular'Img);
		if diferencia_angular>3.0 then
			Respuesta := 0;
			--Put_Line("Incongruencia detectada!");
		end if;
		Conta4 := Conta4 +1;
	end loop;
	if Respuesta = 1 then
		--New_Line;
		--Put_Line("---------------------------------------------------------------------------------------------------------------------------------------");
		Put_Line("S");
	else
		--New_Line;
		--Put_Line("---------------------------------------------------------------------------------------------------------------------------------------");
		Put_Line("N");
	end if;
end comprobar_orden_uno;




