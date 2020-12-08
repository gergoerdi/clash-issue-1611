{-# LANGUAGE ScopedTypeVariables, ApplicativeDo, Rank2Types #-}
{-# LANGUAGE TupleSections #-}
module RetroClash.Utils
    ( withEnableGen

    , mealyState
    , mealyStateB

    , mooreState
    , mooreStateB
    ) where

import Clash.Prelude
import Control.Monad.State

withEnableGen
    :: (KnownDomain dom)
    => (HiddenClockResetEnable dom => r)
    -> Clock dom -> Reset dom -> r
withEnableGen board clk rst = withClockResetEnable clk rst enableGen board

mealyState
   :: (HiddenClockResetEnable dom, NFDataX s)
   => (i -> State s o) -> s -> (Signal dom i -> Signal dom o)
mealyState f = mealy step
  where
    step s x = let (y, s') = runState (f x) s in (s', y)

mealyStateB
    :: (HiddenClockResetEnable dom, NFDataX s, Bundle i, Bundle o)
    => (i -> State s o) -> s -> (Unbundled dom i -> Unbundled dom o)
mealyStateB f s0 = unbundle . mealyState f s0 . bundle

mooreState
    :: (HiddenClockResetEnable dom, NFDataX s)
    => (i -> State s ()) -> (s -> o) -> s -> (Signal dom i -> Signal dom o)
mooreState step = moore step'
  where
    step' s x = execState (step x) s

mooreStateB
    :: (HiddenClockResetEnable dom, NFDataX s, Bundle i, Bundle o)
    => (i -> State s ()) -> (s -> o) -> s -> (Unbundled dom i -> Unbundled dom o)
mooreStateB step out s0 = unbundle . mooreState step out s0 . bundle
