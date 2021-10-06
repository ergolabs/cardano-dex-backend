module Executor.Models.Settings 
    ( KafkaConsumerSettings(..)
    , HttpSettings(..)
    , HasKafkaConsumerSettings(..)
    , HasSettings(..)
    , AppSettings(..)
    ) where

import RIO
import Dhall

data AppSettings = AppSettings
  { getKafkaSettings :: KafkaConsumerSettings
  , getHttpSettings :: HttpSettings
  } deriving (Generic)

instance FromDhall AppSettings

data KafkaConsumerSettings = KafkaConsumerSettings
  { getBrokerList :: [Text]
  , getGroupId :: Text
  , getTopicsList :: [Text]
  , getPollRate :: Natural
  , getBatchSize :: Natural
  } deriving (Generic)

instance FromDhall KafkaConsumerSettings

data HttpSettings = HttpSettings
    { hostS :: String
    , portS :: Natural
    } deriving (Generic, Show)

instance FromDhall HttpSettings

class HasKafkaConsumerSettings env where
  kafkaSettingsL :: Lens' env KafkaConsumerSettings
instance HasKafkaConsumerSettings KafkaConsumerSettings where
  kafkaSettingsL = id
instance HasKafkaConsumerSettings AppSettings where
  kafkaSettingsL = lens getKafkaSettings (\x y -> x { getKafkaSettings = y })

class HasSettings env where
  httpSettingsL :: Lens' env HttpSettings
instance HasSettings HttpSettings where
  httpSettingsL = id
instance HasSettings AppSettings where
  httpSettingsL = lens getHttpSettings (\x y -> x { getHttpSettings = y })