configuration toplevelattack_structural_cfg of topattack is
	for structural
		for all: attackp use configuration work.attackpressed_behavioural_cfg;
			end for;
		for all: damagecalculator use configuration work.damagecalculator_behavioural_cfg;
			end for;
		for all: killzonedetector use configuration work.killzonedetector_behavioural_cfg;
			end for;
		for all: coldet use configuration work.coldet_behaviour_cfg;
			end for;
	end for;
end configuration toplevelattack_structural_cfg;
