{-# LANGUAGE RebindableSyntax #-}
module Board where

import Clash.Prelude hiding (rom)
import Clash.Annotations.TH
import RetroClash.Memory

topEntity
    :: "CLK"   ::: Clock System
    -> "RESET" ::: Reset System
    -> "OUT"   ::: Signal System (Maybe (Unsigned 8))
topEntity clk rst = withClockResetEnable clk rst enableGen board

board
    :: (HiddenClockResetEnable dom)
    => Signal dom (Maybe (Unsigned 8))
board = dataIn
  where
    _dataOut = Just <$> cnt
      where
        cnt = register (0 :: Unsigned 8) $ cnt + 1

    _addrOut = Just <$> cnt
      where
        cnt = register (0 :: Unsigned 16) $ cnt + 1

    (dataIn, (), NilR) = runAddressing _addrOut _dataOut $ do
        rom <- romFromFile (SNat @0x0800) "_build/intel8080/image.bin"
        ram <- ram0 (SNat @0x1800)

        from 0x0000 $ connect rom
        from 0x0800 $ connect ram
      where
        return = Return
        (>>=) = Bind
        (=<<) = flip (>>=)
        m >> n = m >>= \_ -> n


makeTopEntity 'topEntity
