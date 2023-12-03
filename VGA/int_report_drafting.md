# VGA module design

<!-- 
Structure
    -introduction
        -? tell what the role of the VGA module is and why it should be made/why it is a seperate submodule
    -required specifications and boundary conditions of the module
        -? first a general description of what the VGA module should be able to do
            -? then use that description to draft a set of specifications
        -? now Take It To The Limit
    -deconstruction of the vga module in submodules
        -the scanner (rtl description)
            -? how one counts and keeps track of which horizontal pixel and which vertical row is being set now. Also synchronises the display to the chip
            -> the 2 sync generators
            -> the 2 counters
        -coloring (structural?/rtl description)
            -? the pixel coloring logic -> this module outputs what color a pixel should be based on the game data recieved from memory (player location, time left, player percentages)
            -> the top of coloring will house the gigantic if-tree that decides what color to draw
            -> the game data will be processed by subblocks of coloring so the desired RELATIVE pixel locations and colors will be known
                -char_offset_adder
                -number_sprite with the dig3_num_splitter
    -design of the submodules and their components
        -? information on how the module should look and how much combinatorial logic compared to registers/latches will be included
    -testbenches/simulation and synthesis 
        -> TODO make testbenches for all the components/submodules
    
 -->


