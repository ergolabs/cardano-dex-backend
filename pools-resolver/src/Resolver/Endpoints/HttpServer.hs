{-# LANGUAGE TypeOperators #-}

module Resolver.Endpoints.HttpServer
  ( HttpServer(..)
  , mkHttpServer
  ) where

import RIO

import Resolver.Settings as AppSettings
import Resolver.Repositories.PoolRepository
import Resolver.Services.PoolResolver
import Servant
import Network.Wai.Handler.Warp as Warp
import ErgoDex.Amm.Pool
import Core.Types

data HttpServer f = HttpServer
  { runHttpServer :: f ()
  }

mkHttpServer :: (MonadIO f) => HttpServerSettings -> PoolResolver f -> PoolRepository f -> UnliftIO f -> HttpServer f
mkHttpServer settings resolver repo uIO = HttpServer $ runHttpServer' settings resolver repo uIO

runHttpServer' :: (MonadIO f) => HttpServerSettings -> PoolResolver f -> PoolRepository f -> UnliftIO f -> f ()
runHttpServer' HttpServerSettings{..} resolver repo uIO =
  liftIO $ Warp.run (fromIntegral getPort) (httpApp resolver repo uIO)

type Api =
  "resolve" :> ReqBody '[JSON] PoolId         :> Post '[JSON] (Maybe ConfirmedPool) :<|>
  "update"  :> ReqBody '[JSON] PredictedPool  :> Post '[JSON] ()

apiProxy :: Proxy Api
apiProxy = Proxy

f2Handler :: UnliftIO f -> f a -> Servant.Handler a
f2Handler UnliftIO{..} = liftIO . unliftIO

httpApp :: PoolResolver f -> PoolRepository f -> UnliftIO f -> Application
httpApp r p un = serve apiProxy $ hoistServer apiProxy (f2Handler un) (server r p)

server :: PoolResolver f -> PoolRepository f -> ServerT Api f
server r p =
  resolvePool r :<|>
  update p

resolvePool :: PoolResolver f -> PoolId -> f (Maybe ConfirmedPool)
resolvePool PoolResolver{..} = resolve

update :: PoolRepository f -> PredictedPool -> f ()
update PoolRepository{..} = putPredicted
