module Tracker.Models.AppConfig 
    ( RedisSettings(..)
    , BlockRequestConfig(..)
    , TrackerProgrammConfig(..)
    , TrackerServiceConfig(..)
    , AppConfig(..)
    ) where

import RIO
import Dhall
import Explorer.Config
import System.Logging.Hlog
import Streaming.Config

data TrackerProgrammConfig = TrackerProgrammConfig
   { pollTime :: Natural
   , minIndex :: Natural
   } deriving (Generic)

instance FromDhall TrackerProgrammConfig

newtype BlockRequestConfig = BlockRequestConfig
  { period :: Natural 
  } deriving (Generic)

instance FromDhall BlockRequestConfig

data RedisSettings = RedisSettings
  { redisHost :: String
  , redisPort :: String
  , redisPassword :: Maybe String
  } deriving (Generic)

instance FromDhall RedisSettings

data TrackerServiceConfig = TrackerServiceConfig
  { limitOffset :: Natural
  , maxAttempts :: Natural
  } deriving (Generic)

instance FromDhall TrackerServiceConfig

data AppConfig = AppConfig
  { explorerConfig        :: ExplorerConfig
  , blockRequestConfig    :: BlockRequestConfig
  , poolsProducerConfig   :: KafkaProducerConfig
  , poolsTopicName        :: Text
  , ordersProducerConfig  :: KafkaProducerConfig
  , ordersTopicName       :: Text
  , trackerProgrammConfig :: TrackerProgrammConfig
  , redisConfig           :: RedisSettings
  , trackerServiceConfig  :: TrackerServiceConfig
  , loggingConfig       :: LoggingConfig
  } deriving (Generic)

instance FromDhall AppConfig