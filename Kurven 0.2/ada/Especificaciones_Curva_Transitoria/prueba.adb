With biblioteca_esp_curv;	use biblioteca_esp_curv;
with Ada.Text_IO; 			use Ada.Text_IO;

Procedure prueba is
	Tr, TAS, MP : float := 0.0;
	Nombre	: string := "Fuzzy_loop.txt";
Begin
	Especificaciones_Curva(Nombre, Tr, TAS, MP);
	Put_Line(Nombre & ", " & Tr'Img & ", " & TAS'Img & ", " & MP'Img);
End prueba;
