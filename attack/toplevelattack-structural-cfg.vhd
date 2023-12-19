configuration toplevelattack-structural-cfg of toplevelattack is
	for structural
		for all: attackp use configuration work.attackpressed-behavioural-cfg;
			end for;
		for all: damagacalculator use configuration work.damagecalculator-behavioural-cfg;
			end for;
		for all: killzonedetector use configuration work.killzonedetector-behavioural-cfg;
			end for;
		for all: coldet use configuration work.coldet-behaviour-cfg;
			end for;
	end for;
end configuration toplevelattack-structural-cfg;
