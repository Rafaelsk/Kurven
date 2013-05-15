with Ada.Text_IO; 		use Ada.Text_IO;
with Ada.Command_Line;	use Ada.Command_Line;

procedure entonar is
--Valores de la expresion
   K 	: Long_Float;
   Tau 	: Long_Float;
   Kp	: Long_Float;
   Ki	: Long_Float;
   Chi	: Long_Float;
   Wn	: Long_Float;
   Tas	: Long_Float;

begin
   K	:= Long_Float'Value(Argument(1));
   tau	:= Long_FLoat'Value(Argument(2));
   Chi	:= Long_Float'Value(Argument(3));
   Tas	:= Long_Float'Value(Argument(4));
   Wn	:= 4.0/(Chi*Tas);
   --Igualando los coeficientes de la funcion de transf PI*G y el polinomio
   --caracteristico deseado, queda lo siguiente:
   Kp	:= ((2.0*Chi*Wn*Tau)-1.0)/K;
   Ki	:= ((Wn**2)*Tau)/K;
   Put(Kp'Img & "," & Ki'img);

end entonar;

