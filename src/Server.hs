{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
module Server
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import Schema
import Postgre
import Database.Persist.Postgresql (SqlBackend, ConnectionPool)
import Control.Monad.Cont (liftIO)
import Data.Int (Int64)


type API = "rooms" :> Capture "roomId" Int64 :> Get '[JSON] Room

startApp :: ConnectionPool -> IO ()
startApp pool = run 8080 $ app pool

app :: ConnectionPool -> Application
app pool = serve api $ server pool

api :: Proxy API
api = Proxy

fetchRoom :: ConnectionPool -> Int64 -> Handler Room
fetchRoom pool key = do
  room <- liftIO $ getRoom pool key
  case room of
    Just r -> return r
    Nothing -> Handler (throwError $ err404 {errBody = "Not found"})

server :: ConnectionPool -> Server API
server = fetchRoom

