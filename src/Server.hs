{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
module Server
    ( startApp
    , app
    ) where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import Schema
import Postgre
import Database.Persist.Postgresql (ConnectionPool)
import Control.Monad.Cont (liftIO)
import Data.Int (Int64)


type API =
       "room" :> Capture "roomId" Int64 :> Get '[JSON] Room
  :<|> "room" :> "create" :> ReqBody '[JSON] Room :> Post '[JSON] Int64
  :<|> "user" :> "create" :> ReqBody '[JSON] User :> Post '[JSON] Int64
  :<|> "message" :> ReqBody '[JSON] Message :> Post '[JSON] Int64

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

createUser :: ConnectionPool -> User -> Handler Int64
createUser pool user = liftIO $ insertUser pool user

createRoom :: ConnectionPool -> Room -> Handler Int64
createRoom pool room = liftIO $ insertRoom pool room

createMessage :: ConnectionPool -> Message -> Handler Int64
createMessage pool message = liftIO $ insertMessage pool message


server :: ConnectionPool -> Server API
server pool = fetchRoom pool
  :<|> createRoom pool
  :<|> createUser pool
  :<|> createMessage pool

