{-# LANGUAGE OverloadedStrings #-}
module Postgre where

import Database.Persist
import Database.Persist.Postgresql
import Control.Monad.IO.Class

import Schema
import Data.Int (Int64)
import Control.Monad.Reader (runReaderT)



insertRoom :: ConnectionPool -> Room -> IO Int64
insertRoom pool room = fromSqlKey <$> runSqlPool (insert room) pool

insertMessage :: ConnectionPool -> Message -> IO Int64
insertMessage pool message = fromSqlKey <$> runSqlPool (insert message) pool

insertUser :: ConnectionPool -> User -> IO Int64
insertUser pool user = fromSqlKey <$> runSqlPool (insert user) pool


getRoom :: ConnectionPool -> Int64 -> IO (Maybe Room)
getRoom pool key = runSqlPool (get (toSqlKey key)) pool
