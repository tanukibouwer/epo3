configuration coloring_cfg of coloring is
    for behavioural
        for all: char_offset_adder use configuration work.char_offset_adder_cfg;
		end for;
	for all: dig3_num_splitter use configuration work.dig3_num_splitter_cfg;
		end for;
	for all: number_sprite use configuration work.number_sprite_cfg;
		end for;
	for all: char_sprites use configuration work.char_sprites_cfg;
    end for;
end configuration coloring_cfg;
