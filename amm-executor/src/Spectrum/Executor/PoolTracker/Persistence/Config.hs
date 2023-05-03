module Spectrum.Executor.PoolTracker.Persistence.Config
  ( PoolStoreConfig(..)
  ) where

import GHC.Generics
  ( Generic )
import Dhall
  ( FromDhall )

data PoolStoreConfig = PoolStoreConfig
  { storePath       :: !FilePath
  , createIfMissing :: !Bool
  , persistent      :: !Bool
  }
  deriving (Generic, FromDhall)
