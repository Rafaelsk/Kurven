with Ada.Text_IO; 			use Ada.Text_IO;
with Ada.Strings;			use Ada.Strings;
with Ada.Strings.Fixed;			use Ada.Strings.Fixed;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Real_Arrays;  	use Ada.Numerics.Real_Arrays;
with Interfaces.C; 			use Interfaces.C;
with variables_fuzzytuning;		use variables_fuzzytuning;
with Ada.Command_Line;	use Ada.Command_Line;
with System;


package body biblioteca_fuzzytuning is



	-- Proceso de fuzzificacion, en donde se buscara el grado de pertenencia en los conjuntos borrosos diseñados con respecto a la variable de entrada
	-- cada conjunto borroso tendra solo dos posibilidades: con pendiente negativa y pendiente positiva.
	Procedure Fuzzificar is
	begin
		--New_Line;
		-- #### UNIVERSO DE DISCURSO DE SOBRE PASO####
		-- Si MP:VALOR es menor que 20.0, toca al conjunto MP.NULO. Aqui se calcula el grado de pertenencia.
		if MP.VALOR <= 0.0 Then
			MP.NULO := 1.0;
		else
			if (MP.VALOR > 0.0) and (MP.VALOR < 5.0) Then
				MP.NULO := (5.0 - MP.VALOR)/5.0;
			else
				MP.NULO := 0.0;
			End if;
		End if;

		--Put_Line("MP.NULO= " & MP.NULO'Img);

		-- Si MP:VALOR es mayor que 0.0 y Menor que 40.0, toca al conjunto MUY POCO. Aqui se calcula el grado de pertenencia.
		if (MP.VALOR > 0.0) and (MP.VALOR < 5.0) then
			MP.MUY_POCO := MP.VALOR/5.0;
		else
			if (MP.VALOR >= 5.0) and (MP.VALOR < 10.0) then
				MP.MUY_POCO := (10.0 - MP.VALOR)/5.0;
			else
				MP.MUY_POCO := 0.0;
			end if;
		end if;

		--Put_Line("MP.MUY_POCO= " & MP.MUY_POCO'Img);

		-- Si MP es mayor que 20 y menor que 60 cae dentro del conjunto POCO. Aqui se calcula el grado de pertenencia
		if (MP.VALOR > 5.0) and (MP.VALOR < 10.0) then
			MP.POCO := (MP.VALOR -5.0)/5.0;
		else
			if (MP.VALOR >= 10.0) and (MP.VALOR < 20.0) then
				MP.POCO := (20.0 - MP.VALOR)/10.0;
			else
				MP.POCO := 0.0;
			end if;
		end if;

		--Put_Line("MP.POCO= " & MP.POCO'Img);

		-- Si MP es mayor que 40 y menor que 80 cae dentro del conjunto MEDIO. Aqui se calcula el grado de pertenencia
		if (MP.VALOR > 10.0) and (MP.VALOR < 20.0) then
			MP.MEDIO := (MP.VALOR -10.0)/10.0;
		else
			if (MP.VALOR >= 20.0) and (MP.VALOR < 60.0) then
				MP.MEDIO := (60.0 - MP.VALOR)/40.0;
			else
				MP.MEDIO := 0.0;
			end if;
		end if;

		--Put_Line("MP.MEDIO= " & MP.MEDIO'Img);

		-- Si MP es mayor que 60 y menor que 100 cae dentro del conjunto GRANDE. Aqui se calcula el grado de pertenencia
		if (MP.VALOR > 20.0) and (MP.VALOR < 60.0) then
			MP.GRANDE := (MP.VALOR - 20.0)/40.0;
		else
			if (MP.VALOR >= 60.0) and (MP.VALOR < 100.0) then
				MP.GRANDE := (100.0 - MP.VALOR)/40.0;
			else
				MP.GRANDE := 0.0;
			end if;
		end if;

		--Put_Line("MP.GRANDE= " & MP.GRANDE'Img);

		-- Si MP es mayor que 80, cae en el conjunto MUY GRANDE, Aqui se calcula el grado de pertenencia
		if (MP.VALOR > 80.0) and (MP.VALOR < 100.0) then
			MP.MUY_GRANDE := (MP.VALOR -60.0)/40.0;
		else
			if (MP.VALOR >= 100.0) then
				MP.MUY_GRANDE := 1.0;
			end if;
		end if;

		--Put_Line("MP.MUY_GRANDE= " & MP.MUY_GRANDE'Img);


		-- #### UNIVERSO DE DISCURSO DE TIEMPO DE ASENTAMIENTO ####
  		-- Si TAS.VALOR es menor que 20.0, toca al conjunto IGUAL. Aqui se calcula el grado de pertenencia.
		TAS.VALOR := 100.0 - (TAS.ACTUAL*100.0/TAS.INICIAL);
		if TAS.VALOR <= 0.0 Then
			TAS.IGUAL_AL_ESCALON := 1.0;
		else
			if (TAS.VALOR > 0.0) and (TAS.VALOR < 20.0) Then
				TAS.IGUAL_AL_ESCALON := (20.0 - TAS.VALOR)/20.0;
			else
				TAS.IGUAL_AL_ESCALON := 0.0;
			End if;
		End if;

		--Put_Line("TAS.IGUAL_AL_ESCALON= " & TAS.IGUAL_AL_ESCALON'Img);

		-- Si TAS.VALOR es mayor que 0.0 y Menor que 40.0, toca al conjunto 20% MAS RAPIDO. Aqui se calcula el grado de pertenencia.
		if (TAS.VALOR > 0.0) and (TAS.VALOR < 20.0) then
			TAS.ESTA_20_PORCIENTO_MASRAPIDO := TAS.VALOR/20.0;
		else
			if (TAS.VALOR >= 20.0) and (TAS.VALOR < 40.0) then
				TAS.ESTA_20_PORCIENTO_MASRAPIDO := (40.0 - TAS.VALOR)/20.0;
			else
				TAS.ESTA_20_PORCIENTO_MASRAPIDO := 0.0;
			end if;
		end if;

		--Put_Line("TAS.ESTA_20_PORCIENTO_MASRAPIDO= " & TAS.ESTA_20_PORCIENTO_MASRAPIDO'Img);

		-- Si TAS.VALOR es mayor que 20 y menor que 60 cae dentro del conjunto 40% MAS RAPIDO. Aqui se calcula el grado de pertenencia
		if (TAS.VALOR > 20.0) and (TAS.VALOR < 40.0) then
			TAS.ESTA_40_PORCIENTO_MASRAPIDO := (TAS.VALOR -20.0)/20.0;
		else
			if (TAS.VALOR >= 40.0) and (TAS.VALOR < 60.0) then
				TAS.ESTA_40_PORCIENTO_MASRAPIDO := (60.0 - TAS.VALOR)/20.0;
			else
				TAS.ESTA_40_PORCIENTO_MASRAPIDO := 0.0;
			end if;
		end if;

		--Put_Line("TAS.ESTA_40_PORCIENTO_MASRAPIDO= " & TAS.ESTA_40_PORCIENTO_MASRAPIDO'Img);

		-- Si TAS.VALOR es mayor que 40 y menor que 80 cae dentro del conjunto 60% MAS RAPIDO. Aqui se calcula el grado de pertenencia
		if (TAS.VALOR > 40.0) and (TAS.VALOR < 60.0) then
			TAS.ESTA_60_PORCIENTO_MASRAPIDO := (TAS.VALOR -40.0)/20.0;
		else
			if (TAS.VALOR >= 60.0) and (TAS.VALOR < 80.0) then
				TAS.ESTA_60_PORCIENTO_MASRAPIDO := (80.0 - TAS.VALOR)/20.0;
			else
				TAS.ESTA_60_PORCIENTO_MASRAPIDO := 0.0;
			end if;
		end if;

		--Put_Line("TAS.ESTA_60_PORCIENTO_MASRAPIDO= " & TAS.ESTA_60_PORCIENTO_MASRAPIDO'Img);

		-- Si TAS.VALOR es mayor que 60 y menor que 100 cae dentro del conjunto 80% MAS RAPIDO. Aqui se calcula el grado de pertenencia
		if (TAS.VALOR > 60.0) and (TAS.VALOR < 80.0) then
			TAS.ESTA_80_PORCIENTO_MASRAPIDO := (TAS.VALOR - 60.0)/20.0;
		else
			if (TAS.VALOR >= 80.0) and (TAS.VALOR < 100.0) then
				TAS.ESTA_80_PORCIENTO_MASRAPIDO := (100.0 - TAS.VALOR)/20.0;
			else
				TAS.ESTA_80_PORCIENTO_MASRAPIDO := 0.0;
			end if;
		end if;

		--Put_Line("TAS.ESTA_80_PORCIENTO_MASRAPIDO= " & TAS.ESTA_80_PORCIENTO_MASRAPIDO'Img);

		-- Si TAS.VALOR es mayor que 80, cae en el conjunto 100% MAS RAPIDO, Aqui se calcula el grado de pertenencia
		if (TAS.VALOR > 80.0) and (TAS.VALOR < 100.0) then
			TAS.ESTA_100_PORCIENTO_MASRAPIDO := (TAS.VALOR -80.0)/20.0;
		else
			if (TAS.VALOR >= 100.0) then
				TAS.ESTA_100_PORCIENTO_MASRAPIDO := 1.0;
			end if;
		end if;

		--Put_Line("TAS.ESTA_100_PORCIENTO_MASRAPIDO= " & TAS.ESTA_100_PORCIENTO_MASRAPIDO'Img);


	End Fuzzificar;

	-- Aqui se calcula (dependiendo de que conjuntos de entradas se activaron y de las reglas) el grado de pertenencia del conjunto de salida
	-- del sistema. Siempre habra dos salidas, una para la modificacion de el tiempo de Asentamiento
	-- (TAS) y otra para el factor de amortiguamiento (CHI)
	Procedure Inferencia_Fuzzy is
	begin
		-- ##### REGLAS ORIGINALES ####
--		If ((MP.NULO) and (TAS.IGUAL_AL_ESCALON)) 		then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.AUMENTAR_100_PORCIENTO := True; end if;
--		If ((MP.NULO) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.AUMENTAR_80_PORCIENTO  := True; end if;
--		If ((MP.NULO) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.AUMENTAR_60_PORCIENTO  := True; end if;
--		If ((MP.NULO) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.AUMENTAR_40_PORCIENTO  := True; end if;
--		If ((MP.NULO) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.AUMENTAR_20_PORCIENTO  := True; end if;
--		If ((MP.NULO) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_MUCHO_REBOTAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR		  := True; end if;
--
--		If ((MP.MUY_POCO) and (TAS.IGUAL_AL_ESCALON)) 			then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.AUMENTAR_80_PORCIENTO := True; end if;
--		If ((MP.MUY_POCO) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.AUMENTAR_60_PORCIENTO := True; end if;
--		If ((MP.MUY_POCO) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.AUMENTAR_40_PORCIENTO := True; end if;
--		If ((MP.MUY_POCO) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.AUMENTAR_20_PORCIENTO := True; end if;
--		If ((MP.MUY_POCO) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_POCO) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.APURAR_POCO_REBOTAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--
--		If ((MP.POCO) and (TAS.IGUAL_AL_ESCALON)) 		then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.AUMENTAR_60_PORCIENTO := True; end if;
--		If ((MP.POCO) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.AUMENTAR_40_PORCIENTO := True; end if;
--		If ((MP.POCO) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.AUMENTAR_20_PORCIENTO := True; end if;
--		If ((MP.POCO) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.POCO) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.POCO) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.AMORTIGUAR := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--
--		If ((MP.MEDIO) and (TAS.IGUAL_AL_ESCALON)) 		then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.AUMENTAR_40_PORCIENTO := True; end if;
--		If ((MP.MEDIO) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.AUMENTAR_20_PORCIENTO := True; end if;
--		If ((MP.MEDIO) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MEDIO) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MEDIO) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MEDIO) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--
--		If ((MP.GRANDE) and (TAS.IGUAL_AL_ESCALON)) 		then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.AUMENTAR_20_PORCIENTO := True; end if;
--		If ((MP.GRANDE) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.GRANDE) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.GRANDE) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.GRANDE) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.GRANDE) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) then MODIFICACION_CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--
--		If ((MP.MUY_GRANDE) and (TAS.IGUAL_AL_ESCALON)) 		then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_GRANDE) and (TAS.ESTA_20_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_GRANDE) and (TAS.ESTA_40_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_GRANDE) and (TAS.ESTA_60_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_GRANDE) and (TAS.ESTA_80_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
--		If ((MP.MUY_GRANDE) and (TAS.ESTA_100_PORCIENTO_MASRAPIDO)) 	then MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO := True; MODIFICACION_TAS.NO_AUMENTAR := True; end if;
  --		-- ##

		-- Aqui se calcula el grado de pertenencia de los conjuntos borrosos de los universos de salidas con
		-- la metodologia de las Reglas de Union e Interseccion en la Inferencia Fuzzy


 --PARA LA SALIDA Operacion_CHI()

		-- Inicializamos las variables
		Operacion_CHI(1) := 0.0;	-- (1) OSCILAR
		Operacion_CHI(2) := 0.0;	-- (2) APURAR_MUCHO_REBOTAR_MUCHO
		Operacion_CHI(3) := 0.0;	-- (3) APURAR_POCO_REBOTAR_POCO
		Operacion_CHI(4) := 0.0;	-- (4) AMORTIGUAR
		Operacion_CHI(5) := 0.0;	-- (5) RELENTIZAR_POCO_AMORTIGUAR_POCO
		Operacion_CHI(6) := 0.0;	-- (6) RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO



		--New_Line;
		-- PARA LA SALIDA CHI.APURAR_MUCHO_REBOTAR_MUCHO
		declare
			Resultado_Minimo : array(INTEGER range 1..6) of Float;
			Actual_Maximo	 : float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO), (TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(2) := Min((MP.NULO), (TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.NULO), (TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.NULO), (TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.NULO), (TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min((MP.NULO), (TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..6 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_CHI(2) := Actual_Maximo;
		end;

		--Put_Line("CHI.APURAR_MUCHO_REBOTAR_MUCHO= " & Operacion_CHI(2)'Img);

  		-- PARA LA SALIDA CHI.APURAR_POCO_REBOTAR_POCO
		declare
			Resultado_Minimo : array(INTEGER range 1..6) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.MUY_POCO),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.MUY_POCO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.MUY_POCO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.MUY_POCO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min((MP.MUY_POCO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..6 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_CHI(3) := Actual_Maximo;
		end;

		--Put_Line("CHI.APURAR_POCO_REBOTAR_POCO= " & Operacion_CHI(3)'Img);

		  --PARA LA SALIDA MODIFICACION_CHI.AMORTIGUAR
		declare
			Resultado_Minimo : array(INTEGER range 1..6) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.POCO),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(2) := Min((MP.POCO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.POCO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.POCO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.POCO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min((MP.POCO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..6 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_CHI(4) := Actual_Maximo;
		end;

		--Put_Line("CHI.AMORTIGUAR= " & Operacion_CHI(4)'Img);

		  --PARA LA SALIDA CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO
		declare
			Resultado_Minimo : array(INTEGER range 1..12) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min( (MP.MEDIO),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(2) := Min( (MP.MEDIO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min( (MP.MEDIO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min( (MP.MEDIO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min( (MP.MEDIO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min( (MP.MEDIO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(7) := Min((MP.GRANDE),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(8) := Min((MP.GRANDE),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(9) := Min((MP.GRANDE),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(10):= Min((MP.GRANDE),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(11):= Min((MP.GRANDE),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(12):= Min((MP.GRANDE),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..12 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_CHI(5) := Actual_Maximo;
		end;

		--Put_Line("CHI.RELENTIZAR_POCO_AMORTIGUAR_POCO= " & Operacion_CHI(5)'Img);

		  --PARA LA SALIDA MODIFICACION_CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO
		declare
			Resultado_Minimo : array(INTEGER range 1..6) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.MUY_GRANDE),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(2) := Min((MP.MUY_GRANDE),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.MUY_GRANDE),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.MUY_GRANDE),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.MUY_GRANDE),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min((MP.MUY_GRANDE),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..6 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_CHI(6) := Actual_Maximo;
		end;

		--Put_Line("CHI.RELENTIZAR_MUCHO_AMORTIGUAR_MUCHO= " & Operacion_CHI(6)'Img);

 --PARA LA SALIDA Operacion_TAS()

		-- Inicializamos las variables
		Operacion_TAS(6) := 0.0;	-- (6) AUMENTAR_100_PORCIENTO
		Operacion_TAS(5) := 0.0;	-- (5) AUMENTAR_80_PORCIENTO
		Operacion_TAS(4) := 0.0;	-- (4) AUMENTAR_60_PORCIENTO
		Operacion_TAS(3) := 0.0;	-- (3) AUMENTAR_40_PORCIENTO
		Operacion_TAS(2) := 0.0;	-- (2) AUMENTAR_20_PORCIENTO
		Operacion_TAS(1) := 0.0;	-- (1) NO_AUMENTAR

		--PARA LA SALIDA TAS.AUMENTAR_100_PORCIENTO
		Operacion_TAS(6) :=  Min((MP.NULO) , (TAS.IGUAL_AL_ESCALON));

		--Put_Line("TAS.AUMENTAR_100_PORCIENTO= " &Operacion_TAS(6)'Img);

		--PARA LA SALIDA TAS.AUMENTAR_80_PORCIENTO
		declare
			Resultado_Minimo : array(INTEGER range 1..2) of Float;
			Actual_Maximo	 : Float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.IGUAL_AL_ESCALON));
			Operacion_TAS(5)    := Max( Resultado_Minimo(1) , Resultado_Minimo(2) );
		end;

		--Put_Line("TAS.AUMENTAR_80_PORCIENTO= " &Operacion_TAS(5)'Img);

		--PARA LA SALIDA TAS.AUMENTAR_60_PORCIENTO
			declare
			Resultado_Minimo : array(INTEGER range 1..3) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.POCO),(TAS.IGUAL_AL_ESCALON));
			for i in 1..3 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_TAS(4) := Actual_Maximo;
		end;

		--Put_Line("TAS.AUMENTAR_60_PORCIENTO= " &Operacion_TAS(4)'Img);

		--PARA LA SALIDA AS.AUMENTAR_40_PORCIENTO
			declare
			Resultado_Minimo : array(INTEGER range 1..4) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.POCO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.MEDIO),(TAS.IGUAL_AL_ESCALON));
			for i in 1..4 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_TAS(3) := Actual_Maximo;
		end;

		--Put_Line("TAS.AUMENTAR_40_PORCIENTO= " &Operacion_TAS(3)'Img);

		--PARA LA SALIDA TAS.AUMENTAR_20_PORCIENTO
			declare
			Resultado_Minimo : array(INTEGER range 1..5) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.POCO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.MEDIO),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.GRANDE),(TAS.IGUAL_AL_ESCALON));
			for i in 1..5 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_TAS(2) := Actual_Maximo;
		end;

		--Put_Line("TAS.AUMENTAR_20_PORCIENTO= " &Operacion_TAS(2)'Img);

		--PARA LA SALIDA TAS.NO_AUMENTAR
		declare
			Resultado_Minimo : array(INTEGER range 1..21) of Float;
			Actual_Maximo	 : Float := 0.0;
			Maximo_Temporal	 : float := 0.0;
		begin
			Resultado_Minimo(1) := Min((MP.NULO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(2) := Min((MP.MUY_POCO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(3) := Min((MP.MUY_POCO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(4) := Min((MP.POCO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(5) := Min((MP.POCO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(6) := Min((MP.POCO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(7) := Min((MP.MEDIO),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(8) := Min((MP.MEDIO),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(9) := Min((MP.MEDIO),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(10) := Min((MP.MEDIO),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(11) := Min((MP.GRANDE),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(12) := Min((MP.GRANDE),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(13) := Min((MP.GRANDE),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(14) := Min((MP.GRANDE),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(15) := Min((MP.GRANDE),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(16) := Min((MP.MUY_GRANDE),(TAS.IGUAL_AL_ESCALON));
			Resultado_Minimo(17) := Min((MP.MUY_GRANDE),(TAS.ESTA_20_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(18) := Min((MP.MUY_GRANDE),(TAS.ESTA_40_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(19) := Min((MP.MUY_GRANDE),(TAS.ESTA_60_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(20) := Min((MP.MUY_GRANDE),(TAS.ESTA_80_PORCIENTO_MASRAPIDO));
			Resultado_Minimo(21) := Min((MP.MUY_GRANDE),(TAS.ESTA_100_PORCIENTO_MASRAPIDO));
			for i in 1..21 loop
				Actual_Maximo	:= Max( Resultado_Minimo(i) , Maximo_Temporal );
				Maximo_Temporal := Actual_Maximo;
			end loop;
			Operacion_TAS(1) := Actual_Maximo;
		end;

		--Put_Line("TAS.NO_AUMENTAR= " &Operacion_TAS(1)'Img);
	end Inferencia_Fuzzy;

	function Min(A,B : in Float) return Float is	-- Funcion que devuelve el menor de la comparacion de dos numeros
	begin
		If (A < B) then
			return A;
		else
			return B;
		end if;
	end Min;

	Function Max(A,B :in Float) return Float is	--Funcion que devuelve el mas alto de la comparacion de dos numeros
	begin
		If (A>B) then
			Return A;
		else
			return B;
		end if;
	end Max;

	Function Max_3(A,B,C :in Float) return Float is	--Funcion que devuelve el mas alto de la comparacion de dos numeros
	begin
		If (A>B) and (A>C) then
			Return A;
		end if;
		if (B>A) and (B>C) then
			Return B;
		else
			Return C;
		end if;
	end Max_3;





 -- Dependiendo de cuantos conjuntos borrosos haya tocado el proceso de inferencia, el proceso de desfuzzificacion calculara la salida
 -- gracias al procedimiento de centro de Masa o centroide.
 --
 --	y =  SUM(De todas conjuntos de salidas de: La media del conjunto activado x Grado de pertenencia del conjunto de salida
 --          ----------------------------------------------------------------------------------------------------------------
 --			             SUM(De los grados de pertenencia del conjunto de salida)
 --
	Procedure Desfuzzificar is
		Numerador_TAS : float := 0.0;
		Denominador_TAS : float := 0.0;
		Numerador_CHI : float := 0.0;
		Denominador_CHI : float := 0.0;
	begin
		--New_Line;
		Media_CHI(1) := 0.2;	-- Media_Oscilar
		Media_CHI(2) := 0.4;	-- Media_Apurar_Mucho_Rebotar_Mucho
		Media_CHI(3) := 0.8;	-- Media_Apurar_Poco_Rebotar_Poco
		Media_CHI(4) := 1.0;	-- Media_Amortiguar
		Media_CHI(5) := 1.1;	-- Media_Relentizar_Poco_Amortiguar_Poco
		Media_CHI(6) := 1.4;	-- Media_Relentizar_Mucho_Amortiguar_Mucho
		-- Va del conjunto mas grande al menos pesado. ya que las operaciones TAS: el 1 es aumentar 100%

		Media_TAS(1) := 10.0;	-- Media_No_Aumentar
		Media_TAS(2) := 20.0;	-- Media_Aumentar_20_Porciento
		Media_TAS(3) := 40.0;	-- Media_Aumentar_40_Porciento
		Media_TAS(4) := 50.0;	-- Media_Aumentar_60_Porciento
		Media_TAS(5) := 80.0;	-- Media_Aumentar_80_Porciento
		Media_TAS(6) := 100.0;	-- Media_Aumentar_100_Porciento

		-- Para la accion de tiempo de asentamiento
		For i in 1..6 loop
			Numerador_TAS := Numerador_TAS + (Media_TAS(i)*Operacion_TAS(i));
			Denominador_TAS := Denominador_TAS + (Operacion_TAS(i));
			--Put_Line("Numerador: " & Numerador_TAS'Img & ", Denominador: " & Denominador_TAS'Img & ", Media_TAS(i): " & Media_TAS(i)'img & ", Operacion_TAS(i): " & Operacion_TAS(i)'img);
		End loop;
		Salida_TAS := Numerador_TAS/Denominador_TAS;

		-- Para la accion de modificacion de CHI
		For i in 1..6 loop
			Numerador_CHI := Numerador_CHI + (Media_CHI(i)*Operacion_CHI(i));
			Denominador_CHI := Denominador_CHI + (Operacion_CHI(i));
			--Put_Line("Numerador y denominador CHI= " & Numerador_CHI'Img & ", " & Denominador_CHI'Img);
		End loop;
		Salida_CHI := Numerador_CHI/Denominador_CHI;
		--Put_Line("Valores de Aplicacion de Fuzzy Logic :");
		--Put_Line("    Ajuste de Tiempo de Asentamiento= " & Salida_TAS'Img & "%");
		--Put_Line("    Ajuste de Factor de Amortiguamiento= " & Salida_CHI'Img);
	end Desfuzzificar;



	procedure calcular_ganancias_pi(k, tau: in float) is
		Porcentaje_Cambio_TAS	: Float := Salida_TAS;
		Chi		: Float := Salida_CHI;
		Wn		: Float := 0.0;
		Asentamiento	: Float := 0.0;
	begin
		Asentamiento	:= TAS.ACTUAL*((Porcentaje_Cambio_TAS / 100.0)+1.0);
		Wn	:= 4.0/(Chi*Asentamiento);
   		--Igualando los coeficientes de la funcion de transf PI*G y el polinomio
   		--caracteristico deseado, queda lo siguiente:
		Kp	:= ((2.0*Chi*Wn*Tau)-1.0)/K;
		Ki	:= ((Wn**2)*Tau)/K;
		--Put(Kp'Img & "," & Ki'img);
	end calcular_ganancias_pi;

	Procedure mostrar_resultado is
	begin
		Put_Line(Kp'Img & ", " & Ki'Img);
	end mostrar_resultado;

	function guarda_resultado(Nombre_Salida : in string) return Boolean is
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
					--Put_Line ("Archivo no existe. Paso a crearlo");
					Create (Arch, Name => Nombre_Salida);	-- Se devuelve al comienzo delo loop para abrir el archivo creado
				when Status_Error =>
					--Put_Line ("El archivo ya estÃ¡ abierto. Sigo");
					exit;
				when Use_Error =>		-- No se puede abrir o crear
					--Put_Line ("No he podido crear o abrir el archivo. Salgo del programa");
					regreso := False;
			end;
		end loop;
		if regreso = True then
			-- Escribo el texto
			Put_Line(Arch, Kp'Img & "," & Ki'Img);
			Close (Arch);
		end if;
		return regreso;
	end guarda_resultado;
end biblioteca_fuzzytuning;
