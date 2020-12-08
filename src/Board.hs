{-# LANGUAGE RebindableSyntax #-}
module Board where

import Clash.Prelude hiding (rom)
import Clash.Annotations.TH

import RetroClash.Utils
import RetroClash.Port
import RetroClash.Memory

import Hardware.ACIA

topEntity
    :: "CLK"   ::: Clock System
    -> "RESET" ::: Reset System
    -> "IN"    ::: Signal System (Maybe (Unsigned 8))
    -> "OUT"   ::: Signal System (Maybe (Unsigned 8))
topEntity = withEnableGen board
  where
    board inByte = outByte
      where
        outByte = logicBoard inByte (pure True)

logicBoard
    :: (HiddenClockResetEnable dom)
    => Signal dom (Maybe (Unsigned 8)) -> Signal dom Bool -> Signal dom (Maybe (Unsigned 8))
logicBoard inByte outReady = outByte
  where
    _dataOut = Just <$> cnt
      where
        cnt = register (0 :: Unsigned 8) $ cnt + 1

    _addrOut = Just . Right <$> cnt
      where
        cnt = register (0 :: Unsigned 16) $ cnt + 1

    (dataIn, (), ConsR outByte NilR) = runAddressing _addrOut _dataOut $ do
        rom <- romFromFile (SNat @0x0800) "_build/intel8080/image.bin"
        ram <- ram0 (SNat @0x1800)
        acia <- port $ acia inByte outReady

        matchLeft $ do
            from 0x10 $ connect acia
        matchRight $ do
            from 0x0000 $ connect rom
            from 0x0800 $ connect ram
      where
        return = Return
        (>>=) = Bind
        (=<<) = flip (>>=)
        m >> n = Bind m (const n)


makeTopEntity 'topEntity
