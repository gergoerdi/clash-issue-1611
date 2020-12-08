stack build
stack exec -- clash -isrc -outputdir _build/ --verilog src/Board.hs -fclash-debug DebugSilent 2>&1 | tee log.txt
