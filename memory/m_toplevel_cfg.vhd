configuration memory_structural_cfg of memory is
	for structural
		for all: m_resethandler use configuration work.m_resethandler_structural_cfg;
		end for;
		for all: writelogic use configuration work.writelogic_cfg;
		end for;
		for all: ram_4b use configuration work.ram_4b_cfg;
		end for;
		--for all: ram_10b use configuration work.ram_10b_cfg;
		--end for;
		for all: ram_8b use configuration work.ram_8b_cfg;
		end for;
		for all: ram_9b use configuration work.ram_9b_cfg;
		end for;
	end for;
end memory_structural_cfg;