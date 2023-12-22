configuration input_toplevel_structural_cfg of input_toplevel is
	for structural
		for all: input_driver use configuration work.input_driver_behavioural_cfg;
end for;
		for all: input_buffer use configuration work.input_buffer_behavioural_cfg;
end for;
		for all: input_deserializer use configuration work.input_deserializer_behavioural_cfg;
end for;
		for all: input_register use configuration work.input_register_behavioural_cfg;
end for;
		for all: input_jump use configuration work.input_jump_behavioural_cfg;
end for;
	end for;
end configuration input_toplevel_structural_cfg;
