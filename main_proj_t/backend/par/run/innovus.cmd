#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Jan 11 15:09:05 2024                
#                                                     
#######################################################

#@(#)CDS: Innovus v17.11-s080_1 (64bit) 08/04/2017 11:13 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 17.11-s080_1 NR170721-2155/17_11-UB (database version 2.30, 390.7.1) {superthreading v1.44}
#@(#)CDS: AAE 17.11-s034 (64bit) 08/04/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 17.11-s053_1 () Aug  1 2017 23:31:41 ( )
#@(#)CDS: SYNTECH 17.11-s012_1 () Jul 21 2017 02:29:12 ( )
#@(#)CDS: CPE v17.11-s095
#@(#)CDS: IQRC/TQRC 16.1.1-s215 (64bit) Thu Jul  6 20:18:10 PDT 2017 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
setPreference CmdLogMode 2
set init_lef_file /data/designkit/tsmc-180nm/lib/TSMCHOME/digital/Back_End/lef/tcb018gbwp7t_270a/lef/tcb018gbwp7t_6lm.lef
set init_mmmc_file ../in/mmmc.view
set init_verilog ../in/top.v
set init_top_cell chip_toplevel
set init_gnd_net dgnd
set init_pwr_net dvdd
suppressMessage TECHLIB IMPLF IMPVL IMPFP IMPCTE IMPRM IMPSP IMPCTE NRDB IMPEXT
encMessage info 0
encMessage warning 0
init_design
generateVias
floorPlan -site core7T -s 325 325 0 0 0 0
addStripe -nets {dgnd dvdd} -layer METAL4 -width 2 -number_of_sets 5 -spacing 0.5
addWellTap -cell TAPCELLBWP7T -cellInterval 30 -prefix WELLTAP
editPin -pin clk -layer 2 -fixedPin -assign {20.86 0} -side TOP
editPin -pin reset -layer 2 -fixedPin -assign {21.42 0} -side TOP
editPin -pin p1_controller -layer 2 -fixedPin -assign {21.98 0} -side TOP
editPin -pin p2_controller -layer 2 -fixedPin -assign {22.54 0} -side TOP
editPin -pin controller_latch -layer 2 -fixedPin -assign {29.82 0} -side TOP
editPin -pin controller_clk -layer 2 -fixedPin -assign {30.38 0} -side TOP
editPin -pin Vsync -layer 2 -fixedPin -assign {30.94 0} -side TOP
editPin -pin Hsync -layer 2 -fixedPin -assign {31.50 0} -side TOP
editPin -pin {R_data[3]} -layer 2 -fixedPin -assign {32.06 0} -side TOP
editPin -pin {R_data[2]} -layer 2 -fixedPin -assign {32.62 0} -side TOP
editPin -pin {R_data[1]} -layer 2 -fixedPin -assign {33.18 0} -side TOP
editPin -pin {R_data[0]} -layer 2 -fixedPin -assign {33.74 0} -side TOP
editPin -pin {G_data[3]} -layer 2 -fixedPin -assign {34.30 0} -side TOP
editPin -pin {G_data[2]} -layer 2 -fixedPin -assign {34.86 0} -side TOP
editPin -pin {G_data[1]} -layer 2 -fixedPin -assign {35.42 0} -side TOP
editPin -pin {G_data[0]} -layer 2 -fixedPin -assign {35.98 0} -side TOP
editPin -pin {B_data[3]} -layer 2 -fixedPin -assign {36.54 0} -side TOP
editPin -pin {B_data[2]} -layer 2 -fixedPin -assign {37.10 0} -side TOP
editPin -pin {B_data[1]} -layer 2 -fixedPin -assign {37.66 0} -side TOP
editPin -pin {B_data[0]} -layer 2 -fixedPin -assign {38.22 0} -side TOP
set_analysis_view -setup {setup_wc} -hold {hold_bc}
setNanoRouteMode -routeTopRoutingLayer 4
setNanoRouteMode -routeBottomRoutingLayer 1
encMessage info 1
encMessage warning 1
sroute
placeDesign -prePlaceOpt
refinePlace -checkRoute 0 -preserveRouting 0 -rmAffectedRouting 0 -swapEEQ 0 -checkPinLayerForAccess 1
timeDesign -preCTS
timeDesign -preCTS -hold
optDesign -preCTS -incr
set_ccopt_property buffer_cells { CKBD0BWP7T CKBD10BWP7T CKBD12BWP7T CKBD1BWP7T CKBD2BWP7T CKBD3BWP7T CKBD4BWP7T CKBD6BWP7T CKBD8BWP7T }
set_ccopt_property inverter_cells { CKND0BWP7T CKND10BWP7T CKND12BWP7T CKND1BWP7T CKND2BWP7T CKND3BWP7T CKND4BWP7T CKND6BWP7T CKND8BWP7T }
create_ccopt_clock_tree_spec
ccopt_design
timeDesign -postCTS
timeDesign -postCTS -hold
optDesign -postCTS -incr
optDesign -postCTS -hold
routeDesign -globalDetail
setNanoRouteMode -drouteUseMultiCutViaEffort high
setNanoRouteMode -droutePostRouteSwapVia multiCut
routeDesign -viaOpt
setAnalysisMode -analysisType onChipVariation
timeDesign -postRoute
timeDesign -postRoute -hold
optDesign -postRoute
optDesign -postRoute -hold
addFiller -cell FILL8BWP7T FILL64BWP7T FILL4BWP7T FILL32BWP7T FILL2BWP7T FILL1BWP7T FILL16BWP7T -prefix FILLER
verifyGeometry
verifyConnectivity
encMessage info 0
write_sdf ../out/$init_top_cell.sdf
saveDesign ../out/chip_toplevel.enc
streamOut ../out/chip_toplevel.gds -mapFile ./streamOut.map -libName TOP_DIG -units 2000 -mode ALL
saveNetlist ../out/chip_toplevel.v -excludeLeafCell
encMessage info 1
reportGateCount
win
setLayerPreference block -isVisible 0
setLayerPreference coverCell -isVisible 0
setLayerPreference phyCell -isVisible 0
setLayerPreference io -isVisible 0
setLayerPreference areaIo -isVisible 0
setLayerPreference blackBox -isVisible 0
setLayerPreference stdCell -isVisible 0
setLayerPreference stdCell -isVisible 1
get_visible_nets
gui_select -rect {374.092 -1.933 -39.719 335.123}
setLayerPreference stdCell -isVisible 0
setLayerPreference stdCell -isVisible 1
setLayerPreference instanceCell -isVisible 1
setLayerPreference block -isVisible 1
setLayerPreference stdCell -isVisible 1
setLayerPreference coverCell -isVisible 1
setLayerPreference phyCell -isVisible 1
setLayerPreference io -isVisible 1
setLayerPreference areaIo -isVisible 1
setLayerPreference blackBox -isVisible 1
setLayerPreference instanceCell -isVisible 0
setLayerPreference block -isVisible 0
setLayerPreference stdCell -isVisible 0
setLayerPreference coverCell -isVisible 0
setLayerPreference phyCell -isVisible 0
setLayerPreference io -isVisible 0
setLayerPreference areaIo -isVisible 0
setLayerPreference blackBox -isVisible 0
setLayerPreference block -isVisible 1
setLayerPreference stdCell -isVisible 1
setLayerPreference block -isVisible 0
deselectAll
setLayerPreference instanceCell -isVisible 1
setLayerPreference block -isVisible 1
setLayerPreference stdCell -isVisible 1
setLayerPreference coverCell -isVisible 1
setLayerPreference phyCell -isVisible 1
setLayerPreference io -isVisible 1
setLayerPreference areaIo -isVisible 1
setLayerPreference blackBox -isVisible 1
setLayerPreference hinst -isVisible 0
setLayerPreference guide -isVisible 0
setLayerPreference fence -isVisible 0
setLayerPreference region -isVisible 0
setLayerPreference partition -isVisible 0
setLayerPreference pinObj -isVisible 1
setLayerPreference cellBlkgObj -isVisible 1
setLayerPreference layoutObj -isVisible 1
setLayerPreference pinObj -isVisible 0
setLayerPreference cellBlkgObj -isVisible 0
setLayerPreference layoutObj -isVisible 0
setLayerPreference obstruct -isVisible 0
setLayerPreference screen -isVisible 0
setLayerPreference macroOnly -isVisible 0
setLayerPreference layerBlk -isVisible 0
setLayerPreference fillBlk -isVisible 0
setLayerPreference trimBlk -isVisible 0
setLayerPreference drcRegion -isVisible 0
setLayerPreference blockHalo -isVisible 0
setLayerPreference routingHalo -isVisible 0
setLayerPreference lithoHalo -isVisible 0
setLayerPreference blkLink -isVisible 0
setLayerPreference sitePattern -isVisible 1
setLayerPreference macroSitePattern -isVisible 1
setLayerPreference stdRow -isVisible 0
setLayerPreference ioRow -isVisible 0
setLayerPreference sitePattern -isVisible 0
setLayerPreference macroSitePattern -isVisible 0
setLayerPreference overlapMacro -isVisible 1
setLayerPreference overlapGuide -isVisible 1
setLayerPreference overlapBlk -isVisible 1
setLayerPreference relFPlan -isVisible 0
setLayerPreference sdpGroup -isVisible 0
setLayerPreference sdpConnect -isVisible 0
setLayerPreference sizeBlkg -isVisible 0
setLayerPreference resizeFPLine1 -isVisible 0
setLayerPreference resizeFPLine2 -isVisible 0
setLayerPreference congTag -isVisible 0
setLayerPreference ioSlot -isVisible 0
setLayerPreference overlapMacro -isVisible 0
setLayerPreference overlapGuide -isVisible 0
setLayerPreference overlapBlk -isVisible 0
setLayerPreference datapath -isVisible 0
setLayerPreference routeGuide -isVisible 0
setLayerPreference ptnPinBlk -isVisible 0
setLayerPreference ptnFeed -isVisible 0
setLayerPreference netRect -isVisible 1
setLayerPreference substrateNoise -isVisible 1
setLayerPreference pwrdm -isVisible 0
setLayerPreference netRect -isVisible 0
setLayerPreference substrateNoise -isVisible 0
setLayerPreference powerNet -isVisible 0
setLayerPreference net -isVisible 0
setLayerPreference power -isVisible 0
setLayerPreference pgPower -isVisible 0
setLayerPreference pgGround -isVisible 0
setLayerPreference clock -isVisible 0
setLayerPreference shield -isVisible 0
setLayerPreference unknowState -isVisible 0
setLayerPreference metalFill -isVisible 0
setLayerPreference wire -isVisible 0
setLayerPreference via -isVisible 0
setLayerPreference patch -isVisible 0
setLayerPreference trim -isVisible 0
setLayerPreference allM0 -isVisible 1
setLayerPreference allM1 -isVisible 1
setLayerPreference allM2 -isVisible 1
setLayerPreference allM3 -isVisible 1
setLayerPreference allM4 -isVisible 1
setLayerPreference allM5 -isVisible 1
setLayerPreference allM6 -isVisible 1
setLayerPreference bump -isVisible 0
setLayerPreference bumpBack -isVisible 0
setLayerPreference bumpConnect -isVisible 0
setLayerPreference allM0 -isVisible 0
setLayerPreference allM1Cont -isVisible 0
setLayerPreference allM1 -isVisible 0
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM2 -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM3 -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM4 -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM5 -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM6 -isVisible 0
setLayerPreference gdsii -isVisible 1
setLayerPreference portNum -isVisible 1
setLayerPreference gdsii -isVisible 0
setLayerPreference term -isVisible 0
setLayerPreference violation -isVisible 0
setLayerPreference busguide -isVisible 0
setLayerPreference aggress -isVisible 0
setLayerPreference text -isVisible 0
setLayerPreference pinText -isVisible 0
setLayerPreference flightLine -isVisible 0
setLayerPreference portNum -isVisible 0
setLayerPreference dpt -isVisible 0
setLayerPreference blackBox -isVisible 0
setLayerPreference areaIo -isVisible 0
setLayerPreference io -isVisible 0
setLayerPreference phyCell -isVisible 0
setLayerPreference coverCell -isVisible 0
setLayerPreference block -isVisible 0
setLayerPreference block -isVisible 1
setLayerPreference instanceCell -isVisible 1
setLayerPreference hinst -isVisible 1
setLayerPreference guide -isVisible 1
setLayerPreference fence -isVisible 1
setLayerPreference region -isVisible 1
setLayerPreference partition -isVisible 1
setLayerPreference pinObj -isVisible 1
setLayerPreference cellBlkgObj -isVisible 1
setLayerPreference layoutObj -isVisible 1
setLayerPreference obstruct -isVisible 1
setLayerPreference screen -isVisible 1
setLayerPreference macroOnly -isVisible 1
setLayerPreference layerBlk -isVisible 1
setLayerPreference fillBlk -isVisible 1
setLayerPreference trimBlk -isVisible 1
setLayerPreference drcRegion -isVisible 1
setLayerPreference blockHalo -isVisible 1
setLayerPreference routingHalo -isVisible 1
setLayerPreference lithoHalo -isVisible 1
setLayerPreference blkLink -isVisible 1
setLayerPreference stdRow -isVisible 1
setLayerPreference ioRow -isVisible 1
setLayerPreference sitePattern -isVisible 1
setLayerPreference macroSitePattern -isVisible 1
setLayerPreference relFPlan -isVisible 1
setLayerPreference sdpGroup -isVisible 1
setLayerPreference sdpConnect -isVisible 1
setLayerPreference sizeBlkg -isVisible 1
setLayerPreference resizeFPLine1 -isVisible 1
setLayerPreference resizeFPLine2 -isVisible 1
setLayerPreference congTag -isVisible 1
setLayerPreference ioSlot -isVisible 1
setLayerPreference overlapMacro -isVisible 1
setLayerPreference overlapGuide -isVisible 1
setLayerPreference overlapBlk -isVisible 1
setLayerPreference datapath -isVisible 1
setLayerPreference routeGuide -isVisible 1
setLayerPreference ptnPinBlk -isVisible 1
setLayerPreference ptnFeed -isVisible 1
setLayerPreference pwrdm -isVisible 1
setLayerPreference netRect -isVisible 1
setLayerPreference substrateNoise -isVisible 1
setLayerPreference powerNet -isVisible 1
setLayerPreference densityMap -isVisible 1
setLayerPreference pinDensityMap -isVisible 1
setLayerPreference timingMap -isVisible 1
setLayerPreference metalDensityMap -isVisible 1
setLayerPreference powerDensity -isVisible 1
setLayerPreference groupmain_Congestion -isVisible 1
::fit main.layout.win
setLayerPreference densityMap -isVisible 0
setLayerPreference pinDensityMap -isVisible 0
setLayerPreference timingMap -isVisible 0
setLayerPreference metalDensityMap -isVisible 0
setLayerPreference powerDensity -isVisible 0
setLayerPreference groupmain_Congestion -isVisible 0
setLayerPreference pwrdm -isVisible 0
setLayerPreference netRect -isVisible 0
setLayerPreference substrateNoise -isVisible 0
setLayerPreference powerNet -isVisible 0
setLayerPreference pwrdm -isVisible 1
setLayerPreference netRect -isVisible 1
setLayerPreference substrateNoise -isVisible 1
setLayerPreference powerNet -isVisible 1
setLayerPreference routeGuide -isVisible 0
setLayerPreference ptnPinBlk -isVisible 0
setLayerPreference ptnFeed -isVisible 0
setLayerPreference routeGuide -isVisible 1
setLayerPreference ptnPinBlk -isVisible 1
setLayerPreference ptnFeed -isVisible 1
setLayerPreference relFPlan -isVisible 0
setLayerPreference sdpGroup -isVisible 0
setLayerPreference sdpConnect -isVisible 0
setLayerPreference sizeBlkg -isVisible 0
setLayerPreference resizeFPLine1 -isVisible 0
setLayerPreference resizeFPLine2 -isVisible 0
setLayerPreference congTag -isVisible 0
setLayerPreference ioSlot -isVisible 0
setLayerPreference overlapMacro -isVisible 0
setLayerPreference overlapGuide -isVisible 0
setLayerPreference overlapBlk -isVisible 0
setLayerPreference datapath -isVisible 0
setLayerPreference relFPlan -isVisible 1
setLayerPreference sdpGroup -isVisible 1
setLayerPreference sdpConnect -isVisible 1
setLayerPreference sizeBlkg -isVisible 1
setLayerPreference resizeFPLine1 -isVisible 1
setLayerPreference resizeFPLine2 -isVisible 1
setLayerPreference congTag -isVisible 1
setLayerPreference ioSlot -isVisible 1
setLayerPreference overlapMacro -isVisible 1
setLayerPreference overlapGuide -isVisible 1
setLayerPreference overlapBlk -isVisible 1
setLayerPreference datapath -isVisible 1
setLayerPreference stdRow -isVisible 0
setLayerPreference ioRow -isVisible 0
setLayerPreference sitePattern -isVisible 0
setLayerPreference macroSitePattern -isVisible 0
setLayerPreference trackObj -isVisible 1
setLayerPreference nonPrefTrackObj -isVisible 1
setLayerPreference net -isVisible 1
setLayerPreference power -isVisible 1
setLayerPreference pgPower -isVisible 1
setLayerPreference pgGround -isVisible 1
setLayerPreference clock -isVisible 1
setLayerPreference shield -isVisible 1
setLayerPreference unknowState -isVisible 1
setLayerPreference metalFill -isVisible 1
setLayerPreference wire -isVisible 1
setLayerPreference via -isVisible 1
setLayerPreference patch -isVisible 1
setLayerPreference trim -isVisible 1
setLayerPreference bump -isVisible 1
setLayerPreference bumpBack -isVisible 1
setLayerPreference bumpConnect -isVisible 1
setLayerPreference mGrid -isVisible 1
setLayerPreference pGrid -isVisible 1
setLayerPreference userGrid -isVisible 1
setLayerPreference iGrid -isVisible 1
setLayerPreference fmGrid -isVisible 1
setLayerPreference fiGrid -isVisible 1
setLayerPreference fpGrid -isVisible 1
setLayerPreference gcell -isVisible 1
setLayerPreference trimGridObj -isVisible 1
setLayerPreference pgViaGridObj -isVisible 1
setLayerPreference gdsii -isVisible 1
setLayerPreference term -isVisible 1
setLayerPreference violation -isVisible 1
setLayerPreference busguide -isVisible 1
setLayerPreference aggress -isVisible 1
setLayerPreference text -isVisible 1
setLayerPreference pinText -isVisible 1
setLayerPreference flightLine -isVisible 1
setLayerPreference portNum -isVisible 1
setLayerPreference dpt -isVisible 1
setLayerPreference mGrid -isVisible 0
setLayerPreference pGrid -isVisible 0
setLayerPreference userGrid -isVisible 0
setLayerPreference iGrid -isVisible 0
setLayerPreference fmGrid -isVisible 0
setLayerPreference fiGrid -isVisible 0
setLayerPreference fpGrid -isVisible 0
setLayerPreference gcell -isVisible 0
setLayerPreference trimGridObj -isVisible 0
setLayerPreference pgViaGridObj -isVisible 0
setLayerPreference stdRow -isVisible 1
setLayerPreference ioRow -isVisible 1
setLayerPreference sitePattern -isVisible 1
setLayerPreference macroSitePattern -isVisible 1
setLayerPreference densityMap -isVisible 1
setLayerPreference pinDensityMap -isVisible 1
setLayerPreference timingMap -isVisible 1
setLayerPreference metalDensityMap -isVisible 1
setLayerPreference powerDensity -isVisible 1
setLayerPreference groupmain_Congestion -isVisible 1
::fit main.layout.win
