stack build
stack exec -- clash -isrc -outputdir _build/ --verilog src/Board.hs \
      -fclash-debug DebugSilent \
      -fclash-inline-limit=1000 \
      2>&1 | tee log.txt
