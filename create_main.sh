#!/bin/bash
cd `dirname $0`
sh link.sh main_proj "../../main/* ../../physics/* ../../memory/* ../../input/* ../../attack/* ../../VGA/*"
cd `dirname $0`
cd main_proj/VHDL
ls -1 | grep "_tb" | xargs rm -f
