with Ada.Text_IO; 			use Ada.Text_IO;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with Interfaces.C; 			use Interfaces.C;
with variables_esp_curv;		use variables_esp_curv;
with Ada.Command_Line;	use Ada.Command_Line;
with System;


Package body biblioteca_esp_curv is

	Procedure lee_archivo_de_datos(Nombre: in String) is		-- Argumento DIRECCION : in String
		Arch	: File_Type;					-- Variable utilizada como fichero logico
		Mode : File_Mode 	:= In_File;			-- Abre el archivo en modo lectura.
		--Nombre : String 	:= "/home/marlon/Estudios/Investigaciones/Kurven 0.2/DatosEntrada.txt";		-- Nombre del archivo (solo se usa esta vez en este programa)
		Conta  : Natural 	:= 0;			-- Contador de li­neas leidas
		indb	 : Natural	;
	begin
		Open ( Arch, In_File, Nombre );
		while not End_Of_File (Arch) loop
			declare
				Linea : String := Get_Line (Arch);
			begin
				Conta := Conta + 1;
				indb := Index( Linea(1..Linea'Length), "," );
				t(Conta) := float'Value( Trim( Linea(1 .. indb-1 ), Both ) );
				Replace_Slice ( Linea, 1, indb, "" );
				v(Conta) := float'Value( Trim( Linea(1 .. Linea'Last ), Both ) );
				--Put_Line(v(Conta)'img);
				--Put_Line(t(Conta)'img);
			end;
		end loop;
		Close (Arch);
		n  := Conta;
		Ts := long_float( t(2) - t(1) );
	end lee_archivo_de_datos;

	Procedure calcula_tiempo_levantamiento is
		p1, p2, PARAMETRO10, p4, p5, PARAMETRO90 : COORDENADA;		-- Se definen  objetos, los cuales son de tipo COORDENADA. El tipo COORDENADA tiene 3 componentes: X, Y y m
	begin
		k 	:= v(n);
		k10	:= k*0.1;
		k90	:= k*0.9;
		ik10 := 1;					-- Iteraciones que se hara para el calculo del 10%
		ik90	:= 1;				-- Iteraciones que se hara para el calculo del 90%
		while (float(v(ik10)) < k10 ) loop		-- ik10 va a guardar la cantidad de muestreos que hay antes de llegar al valor del 10% mas una (para cubrir el valor si se pasa)
			ik10 := ik10 + 1;
		end loop;
		while (float(v(ik90)) < k90 ) loop		-- ik10 va a guardar la cantidad de muestreos que hay antes de llegar al valor del 10% mas una (para cubrir el valor si se pasa)
			ik90 := ik90 + 1;
		end loop;
		-- PRIMERO SUPONEMOS QUE ENTRE K10 Y K10-1 HAY UNA RECTA, QUE CORTA AL EJE DE LAS ORDENADAS Y TIENE UNA PENDIENTE ESPECIFICA, CALCULAMOS ENTONCES
		if (float(v(ik10)) = k10) then
			t10 := float(t(ik10));			-- Si el valor es exacto, este es el valor al 10%
		else								-- de lo contrario lo interpola
			p1.X	:= float(t(ik10-1));				-- El tiempo justo antes del 10% -- Define la componente X de la coordenada P1
			p1.Y	:= float(v(ik10-1));				-- El valor muestreado justo antes del 10% -- Define la componente Y de la coordenada P1
			p2.X	:= float(t(ik10));				-- El tiempo justo despues del 10% -- Define la componente X de la coordenada P2
			p2.Y	:= float(v(ik10));				-- El valor muestreado justo despues del 10% -- Define la componente Y de la coordenada P2
			PARAMETRO10 := parametros_recta( p1, p2 );	-- Hace P3 igual a COORDENADA CALCULADA (resultado que arroja la funcion parametros_recta)
			t10	:= (k10-PARAMETRO10.b)/PARAMETRO10.m;	-- Ecuacion de la recta simplificada -- ver http://es.wikipedia.org/wiki/Recta
		end if;
		-- DESPUES SUPONEMOS QUE ENTRE K90 Y K90-1 HAY UNA RECTA, QUE CORTA AL EJE DE LAS ORDENADAS Y TIENE UNA PENDIENTE ESPECIFICA, CALCULAMOS ENTONCES
		if (float(v(ik90)) = k90) then
			t90 := float(t(ik90));			-- Si el valor es exacto, este es el valor al 90%
		else								-- de lo contrario lo interpola
			p4.X	:= float(t(ik90-1));				-- El tiempo justo antes del 10% -- Define la componente X de la coordenada P1
			p4.Y	:= float(v(ik90-1));				-- El valor muestreado justo antes del 10% -- Define la componente Y de la coordenada P1
			p5.X	:= float(t(ik90));				-- El tiempo justo despues del 10% -- Define la componente X de la coordenada P2
			p5.Y	:= float(v(ik90));				-- El valor muestreado justo despues del 10% -- Define la componente Y de la coordenada P2
			PARAMETRO90 := parametros_recta( p4, p5 );	-- Hace P3 igual a COORDENADA CALCULADA (resultado que arroja la funcion parametros_recta)
			t90	:= (k90-PARAMETRO90.b)/PARAMETRO90.m;	-- Ecuacion de la recta simplificada -- ver http://es.wikipedia.org/wiki/Recta
		end if;
		Tr := t90 - t10;							-- Tiempo de levantamiento
	end calcula_tiempo_levantamiento;

	function  parametros_recta( PA, PB : in COORDENADA) return COORDENADA is	-- Llama P1 y P2 a las entradas, las cuales coinciden con el nombre pero lo que hace es copiarlas con el mismo nombre.
		PARAMETRO_CALCULADO : COORDENADA;
	begin
		PARAMETRO_CALCULADO.m	:= (PB.Y - PA.Y) / (PB.X - PA.X);					-- Calcula la pendiente con los dos valores los dos objetos tipo COORDENADA
		PARAMETRO_CALCULADO.b	:= PB.Y - PARAMETRO_CALCULADO.m*PB.X;		-- Calculamos el punto de corte de la recta con el eje de las ordenadas
		return PARAMETRO_CALCULADO;
	end parametros_recta;

	Procedure calcula_tiempo_asentamiento is
		p6, p7, PARAMETRO95 : COORDENADA;		-- Se definen  objetos, los cuales son de tipo COORDENADA. El tipo COORDENADA tiene 3 componentes: X, Y y m
	begin
		k 	:= v(n);
		k95	:= k*0.95;
		ik95	:= 1;				-- Iteraciones que se hara para el calculo del 95%
		while (float(v(ik95)) < k95 ) loop		-- ik10 va a guardar la cantidad de muestreos que hay antes de llegar al valor del 10% mas una (para cubrir el valor si se pasa)
			ik95 := ik95 + 1;
		end loop;
		--  SUPONEMOS QUE ENTRE K95 Y K95-1 HAY UNA RECTA, QUE CORTA AL EJE DE LAS ORDENADAS Y TIENE UNA PENDIENTE ESPECIFICA, CALCULAMOS ENTONCES
		if (float(v(ik95)) = k95) then
			t95 := float(t(ik95));			-- Si el valor es exacto, este es el valor al 90%
		else								-- de lo contrario lo interpola
			p6.X	:= float(t(ik90-1));				-- El tiempo justo antes del 10% -- Define la componente X de la coordenada P1
			p6.Y	:= float(v(ik90-1));				-- El valor muestreado justo antes del 10% -- Define la componente Y de la coordenada P1
			p7.X	:= float(t(ik90));				-- El tiempo justo despues del 10% -- Define la componente X de la coordenada P2
			p7.Y	:= float(v(ik90));				-- El valor muestreado justo despues del 10% -- Define la componente Y de la coordenada P2
			PARAMETRO95 := parametros_recta( p6, p7 );	-- Hace P3 igual a COORDENADA CALCULADA (resultado que arroja la funcion parametros_recta)
			t95	:= (k95-PARAMETRO95.b)/PARAMETRO95.m;	-- Ecuacion de la recta simplificada -- ver http://es.wikipedia.org/wiki/Recta
		end if;
		TAS := t95;
	end calcula_tiempo_asentamiento;

	Procedure calcula_sobrepasomaximo is
		contador : integer	:= 1;					-- Variable usada para controlar el punto de muestreo en analisis
		VALOR_PICO : float 	:= 0.0;					-- Valor Pico de la señal
	begin
		k := v(n);									-- Valor final de la señal
		while  ((v(contador) < k) and (contador /= n)) loop					-- Mientras el punto de muestreo analizado no supere o iguale a k entra en loop
			contador := contador+1;									-- Se analizara el siguiente punto
		end loop;
		--Put_Line("contador= " & contador'img & ", k= " & n'img);
		if ((v(contador) = k) and (contador=n)) then						-- Si el analisis llego al final de los datos y no se encontro sobre paso
			MP			:= 0.0;
			--Put_Line("Sistema sobre-amortiguado, no hay sobrepaso");
		end if;
		if contador < n then											-- Si el sobre paso se encontro, el punto muestreado esta antes del final de los datos
			while ((v(contador) < v(contador+1))) loop						-- Calculo del sobre paso maximo
				contador := contador+1;								-- Se analizara el siguiente punto
				--Put_Line("Punto actual= " & V(contador)'img & ", Punto proximo= " & V(contador + 1)'img);
			end loop;
			VALOR_PICO	:= v(contador);
			--Put_Line("Valor Pico= " & VALOR_PICO'img);
			MP			:= 100.0 * ((VALOR_PICO-k)/k);
		end if;
	end calcula_sobrepasomaximo;


	Procedure especificaciones_curva(Nombre_Archivo: in String; Tiemp_levant, Tiemp_asent, Sobre_Paso: out float) is
	Begin
	lee_archivo_de_datos(Nombre_Archivo);	-- Se guardan los valores de salida y de tiempo en vectores
	calcula_tiempo_levantamiento;			-- Haya valor de Tr
	calcula_tiempo_asentamiento;				-- Haya valor de TAS
	calcula_sobrepasomaximo;				-- Haya MP
	Tiemp_levant := Tr;
	Tiemp_asent:= TAS;
	Sobre_Paso := MP;
	End especificaciones_curva;

End biblioteca_esp_curv;
