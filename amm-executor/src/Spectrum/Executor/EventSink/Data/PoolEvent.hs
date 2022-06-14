module Spectrum.Executor.EventSink.Data.PoolEvent
  ( NewPool(..)
  , DiscardedPool(..)
  ) where

import Spectrum.Executor.Types (PoolStateId)
import Spectrum.Executor.Data.PoolState (Pool)
import ErgoDex.Amm.Pool (PoolId)

newtype NewPool st = NewPool (st Pool)

data DiscardedPool = DiscardedPool PoolId PoolStateId