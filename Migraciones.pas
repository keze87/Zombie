Unit Migraciones;

Interface

type

	TRegMatriz = record
		codigo : char;
		Descripcion : string;
		caracter : char;
		CantSuceptibles : longint;
		CantInfectados : longint;
		CantZombies : longint;
		TasaNatalidad : real;
		FactorMovilidad : real;
		end;

	TMatriz = array[1..100,1..100] of TRegMatriz;

	Tregpos = record
		x:integer;
		y:integer;
		end;

	Function InViaje(poblacionTotal: longint; poblacionInfectada: longint; cantidadDePasajeros: integer): integer;
	Procedure MigracionAire(var mapatriz:TMatriz;topex:integer;topey:integer);
	Procedure MigracionTierra (Var mapatriz:TMatriz;topex:integer;topey:integer);

Implementation

	Uses

		crt;

	function InViaje(poblacionTotal: longint; poblacionInfectada: longint; cantidadDePasajeros: integer): integer;
	var

		i:integer;
		infectadosEnViaje: integer;

	begin

		infectadosEnViaje:=0;

		for i:=1 to cantidadDePasajeros do
		begin

			if(random(poblacionTotal) <= poblacionInfectada) then
			begin

				infectadosEnViaje := infectadosEnViaje + 1;

			end;

		end;

		InViaje := infectadosEnViaje;

	end;

	Procedure MigracionAire(var mapatriz:TMatriz;topex:integer;topey:integer);
	var

		pobTotal:longint;
		pobInfectada:longint;
		I:integer;
		J:integer;
		k:integer;
		h:integer;
		viajantes:real;
		VecRecep: array [1..6] of Tregpos;

	begin

		pobTotal:=0;
		pobInfectada:=0;
		viajantes:=0;
		k:=1;

		for J:=1 to topey do
		begin

			for I:=1 to topex do
			begin

				if mapatriz[i,j].codigo = '9' then
				begin

					VecRecep[k].x := i;
					VecRecep[k].y := j;
					k := k+1;

				end;

			end;

		end;

		for J:=1 to topey do
		begin

			for I:=1 to topex do

				if mapatriz[i,j].codigo = '8' then
				begin

				pobTotal := Mapatriz[i,j].CantSuceptibles + Mapatriz[i,j].cantInfectados;

				pobInfectada:=Mapatriz[i,j].cantInfectados;

				viajantes:= mapatriz[i,j].CantSuceptibles*0.00250/600;

				for h:=1  to 6 do
				begin

					mapatriz[VecRecep[h].x,VecRecep[h].y].cantSuceptibles := mapatriz[VecRecep[h].x,VecRecep[h].y].cantSuceptibles +trunc(viajantes);

					mapatriz[VecRecep[h].x,VecRecep[h].y].cantInfectados := mapatriz[VecRecep[h].x,VecRecep[h].y].cantInfectados + trunc(InViaje(pobTotal,pobInfectada,trunc(viajantes)));

				end;

			end;

		end;

	end;

	Procedure MigracionTierra (Var mapatriz:TMatriz;topex:integer;topey:integer);
	var

		i:integer;
		j:integer;
		cant:integer;
		porcentajeZ:real;
		porcentajeS:real;
		VecPos:array[1..4] of Tregpos;

	begin

		cant:=0;

		for j:=1 to topey do
			for i:=1 to topex do

				if mapatriz[i,j].codigo <> ' '  then
				begin

					if mapatriz[i+1,j].codigo<>' ' then
					begin

						VecPos[1].x:=i+1;

						VecPos[1].y:=j;

						cant:=cant+1;

					end;

					if mapatriz[i-1,j].codigo<>' ' then
					begin

						VecPos[2].x:=i-1;

						VecPos[2].y:=j;

						cant:=cant+1;

					end;

					if mapatriz[i,j-1].codigo<>' ' then
					begin

						VecPos[3].x:=i;

						VecPos[3].y:=j-1;

						cant := cant+1;

					end;

					if mapatriz[i,j+1].codigo<>' ' then
					begin

						VecPos[4].x:=i;

						VecPos[4].y:=j+1;

						cant:=cant+1;

					end;

					porcentajeZ:=(mapatriz[i,j].CantInfectados)*100/(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados);

					porcentajeS:=(porcentajeZ*mapatriz[i,j].CantSuceptibles)/100;

					mapatriz[i,j].CantSuceptibles :=  mapatriz[i,j].CantSuceptibles-abs(trunc(porcentajeS));

					case cant of
						1: begin

							mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles := mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles+abs(trunc(porcentajeS));

							mapatriz[VecPos[1].x,VecPos[1].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS)); end;

						2: begin

							mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles := mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles+trunc(porcentajeS / 2);

							mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles := mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles+trunc(porcentajeS / 2);

							mapatriz[VecPos[1].x,VecPos[1].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 2));

							mapatriz[VecPos[2].x,VecPos[2].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 2)); end;

						3: begin

							mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles := mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles+trunc (porcentajeS / 3);

							mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles := mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles+trunc (porcentajeS / 3);

							mapatriz[VecPos[3].x,VecPos[3].y].CantSuceptibles := mapatriz[VecPos[3].x,VecPos[3].y].CantSuceptibles+trunc (porcentajeS / 3);

							mapatriz[VecPos[1].x,VecPos[1].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc (porcentajeS / 3));

							mapatriz[VecPos[2].x,VecPos[2].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc (porcentajeS / 3));

							mapatriz[VecPos[3].x,VecPos[3].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc (porcentajeS / 3)); end;

						4: begin

							mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles := mapatriz[VecPos[1].x,VecPos[1].y].CantSuceptibles+trunc(porcentajeS / 4);

							mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles := mapatriz[VecPos[2].x,VecPos[2].y].CantSuceptibles+trunc(porcentajeS / 4);

							mapatriz[VecPos[3].x,VecPos[3].y].CantSuceptibles := mapatriz[VecPos[3].x,VecPos[3].y].CantSuceptibles+trunc(porcentajeS / 4);

							mapatriz[VecPos[4].x,VecPos[4].y].CantSuceptibles := mapatriz[VecPos[4].x,VecPos[4].y].CantSuceptibles+trunc(porcentajeS / 4);

							mapatriz[VecPos[1].x,VecPos[1].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 4));

							mapatriz[VecPos[2].x,VecPos[2].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 4));

							mapatriz[VecPos[3].x,VecPos[3].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 4));

							mapatriz[VecPos[4].x,VecPos[4].y].CantInfectados := InViaje(mapatriz[i,j].CantSuceptibles+mapatriz[i,j].CantInfectados,mapatriz[i,j].CantInfectados,trunc(porcentajeS / 4));

							end;

				end;

			end;

	end;

end.
