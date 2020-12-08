Run `build.sh`, and it will fail with:

<no location info>: error:
    Clash error call:
    Internal error: 'reduceBindersCleanup' encountered a variable reference that was 
    neither in 'doneInl', 'origInl', or in the transformation's in scope set. Unique 
    was: '6989586621679258275'.
    CallStack (from HasCallStack):
      error, called at src/Clash/Normalize/Transformations.hs:2664:11 in clash-lib-1.3.0-BtaSQT9Z6y828nb9DyhjHh:Clash.Normalize.Transformations
      reduceBindersCleanup, called at src/Clash/Normalize/Transformations.hs:2625:30 in clash-lib-1.3.0-BtaSQT9Z6y828nb9DyhjHh:Clash.Normalize.Transformations
      inlineBndrsCleanup, called at src/Clash/Normalize/Transformations.hs:2510:19 in clash-lib-1.3.0-BtaSQT9Z6y828nb9DyhjHh:Clash.Normalize.Transformations
      inlineCleanup, called at src/Clash/Normalize/Strategy.hs:57:53 in clash-lib-1.3.0-BtaSQT9Z6y828nb9DyhjHh:Clash.Normalize.Strategy
