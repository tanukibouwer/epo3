#*********************************************************
# synthesize script for cell: chip_toplevel
# company: ontwerp_practicum
# designer: tglab
#*********************************************************
set_db lib_search_path /data/designkit/tsmc-180nm/lib/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcb018gbwp7t_270a/
set_db init_hdl_search_path ../../../VHDL/
set_db library {tcb018gbwp7twc.lib}
set_db use_scan_seqs_for_non_dft false

#include backend/syn/tcl/read_hdl.tcl
read_hdl -vhdl {attackpressed.vhd}
read_hdl -vhdl {VGA_char_animation_fsm.vhd}
read_hdl -vhdl {VGA_char_offset_adder.vhd}
read_hdl -vhdl {VGA_char_sprites.vhd}
read_hdl -vhdl {toplevel.vhd}
read_hdl -vhdl {coldet.vhd}
read_hdl -vhdl {collision_resolver.vhd}
read_hdl -vhdl {VGA_coloring.vhd}
read_hdl -vhdl {damagecalculator.vhd}
read_hdl -vhdl {VGA_dig3_num_splitter.vhd}
read_hdl -vhdl {VGA_frame_cnt.vhd}
read_hdl -vhdl {VGA_graphics_card.vhd}
read_hdl -vhdl {gravity.vhd}
read_hdl -vhdl {VGA_H_pix_cnt.vhd}
read_hdl -vhdl {h_player_movement.vhd}
read_hdl -vhdl {VGA_Hsync_gen.vhd}
read_hdl -vhdl {input_buffer.vhd}
read_hdl -vhdl {input_deserializer.vhd}
read_hdl -vhdl {input_driver.vhd}
read_hdl -vhdl {input_jump.vhd}
read_hdl -vhdl {input_register.vhd}
read_hdl -vhdl {input_toplevel.vhd}
read_hdl -vhdl {jump_calculator.vhd}
read_hdl -vhdl {killzonedetector.vhd}
read_hdl -vhdl {m_resethandler.vhd}
read_hdl -vhdl {m_toplevel.vhd}
read_hdl -vhdl {VGA_number_sprite.vhd}
read_hdl -vhdl {knockback_calculator.vhd}
read_hdl -vhdl {p_mux.vhd}
read_hdl -vhdl {physics_system.vhd}
read_hdl -vhdl {physics_top.vhd}
read_hdl -vhdl {position_adder.vhd}
read_hdl -vhdl {m_ram10bit.vhd}
read_hdl -vhdl {m_ram4bit.vhd}
read_hdl -vhdl {m_ram8bit.vhd}
read_hdl -vhdl {m_ram9bit.vhd}
read_hdl -vhdl {VGA_screen_scan.vhd}
read_hdl -vhdl {t_8bregs.vhd}
read_hdl -vhdl {toplevelattack.vhd}
read_hdl -vhdl {VGA_V_line_cnt.vhd}
read_hdl -vhdl {velocity_interpolator.vhd}
read_hdl -vhdl {VGA_Vsync_gen.vhd}
read_hdl -vhdl {m_writelogic.vhd}
read_hdl -vhdl {coldet-behaviour.vhd}
read_hdl -vhdl {VGA_frame_cnt_cfg.vhd}
read_hdl -vhdl {VGA_char_animation_fsm_cfg.vhd}
read_hdl -vhdl {jump_calculator_behaviour_cfg.vhd}
read_hdl -vhdl {collision_resolver_behaviour_cfg.vhd}
read_hdl -vhdl {position_adder_behaviour_cfg.vhd}
read_hdl -vhdl {gravity_behaviour_cfg.vhd}
read_hdl -vhdl {velocity_interpolator_behaviour_cfg.vhd}
read_hdl -vhdl {h_player_movement_behaviour_cfg.vhd}
read_hdl -vhdl {p_knockback_calculator_behaviour_cfg.vhd}
read_hdl -vhdl {VGA_char_sprites_cfg.vhd}
read_hdl -vhdl {VGA_number_sprite_cfg.vhd}
read_hdl -vhdl {VGA_dig3_num_splitter_cfg.vhd}
read_hdl -vhdl {VGA_char_offset_adder_cfg.vhd}
read_hdl -vhdl {VGA_H_pix_cnt_cfg.vhd}
read_hdl -vhdl {VGA_V_line_cnt_cfg.vhd}
read_hdl -vhdl {VGA_Hsync_gen_cfg.vhd}
read_hdl -vhdl {VGA_Vsync_gen_cfg.vhd}
read_hdl -vhdl {input_jump_behavioural_cfg.vhd}
read_hdl -vhdl {input_register_behavioural_cfg.vhd}
read_hdl -vhdl {input_deserializer_behavioural_cfg.vhd}
read_hdl -vhdl {input_buffer_behavioural_cfg.vhd}
read_hdl -vhdl {input_driver_behavioural_cfg.vhd}
read_hdl -vhdl {coldet-behaviour-cfg.vhd}
read_hdl -vhdl {killzonedetector-behavioural-cfg.vhd}
read_hdl -vhdl {damagecalculator-behavioural-cfg.vhd}
read_hdl -vhdl {attackpressed-behavioural-cfg.vhd}
read_hdl -vhdl {physics_system_behaviour_cfg.vhd}
read_hdl -vhdl {p_mux_behavioural_cfg.vhd}
read_hdl -vhdl {VGA_coloring_cfg.vhd}
read_hdl -vhdl {VGA_screen_scan_cfg.vhd}
read_hdl -vhdl {m_ram9bit_cfg.vhd}
read_hdl -vhdl {m_ram8bit_cfg.vhd}
read_hdl -vhdl {m_ram10bit_cfg.vhd}
read_hdl -vhdl {m_ram4bit_cfg.vhd}
read_hdl -vhdl {m_writelogic_cfg.vhd}
read_hdl -vhdl {m_resethandler_cfg.vhd}
read_hdl -vhdl {input_toplevel_structural_cfg.vhd}
read_hdl -vhdl {t_8bregs_rtl_cfg.vhd}
read_hdl -vhdl {toplevelattack-structural-cfg.vhd}
read_hdl -vhdl {physics_top_structural_cfg.vhd}
read_hdl -vhdl {graphics_card_structural_cfg.vhd}
read_hdl -vhdl {m_toplevel_cfg.vhd}
read_hdl -vhdl {chip_toplevel_structural_cfg.vhd}
#endincl

elaborate chip_toplevel_structural_cfg

#include backend/syn/in/chip_toplevel.sdc
# We will use a 25 MHz clock, 
# but use 33 MHz as constraint to be more sure it works.
dc::create_clock -name clk -period 30 -waveform {0 15} [dc::get_ports clk]
dc::set_driving_cell -cell INVD0BWP7T [dc::all_inputs]
dc::set_input_delay  .2 -clock clk [dc::all_inputs]
dc::set_output_delay .5 -clock clk [dc::all_outputs]
dc::set_load 1 [dc::all_outputs]
#endincl

synthesize -to_mapped
#set_db syn_generic_effort medium
#syn_generic
#syn_map

ungroup -all -flat
insert_tiehilo_cells
write_hdl -mapped > ../out/chip_toplevel.v
write_sdf > ../out/chip_toplevel.sdf
write_sdc > ../out/chip_toplevel.sdc

report timing
report gates

gui_show


