{-# LANGUAGE OverloadedStrings #-}
module Postgre where

import Database.Persist
import Database.Persist.Postgresql
import Control.Monad.IO.Class

import Schema
import Data.Int (Int64)
import Control.Monad.Reader (runReaderT)


getRoom :: ConnectionPool -> Int64 -> IO (Maybe Room)
getRoom pool key = runSqlPool (get (toSqlKey key)) pool

insertRoom :: ConnectionPool -> Room -> IO Int64
insertRoom pool room = fromSqlKey <$> runSqlPool (insert room) pool

insertMessage :: (MonadIO m) => Message -> SqlPersistT m (Key Message)
insertMessage = insert
