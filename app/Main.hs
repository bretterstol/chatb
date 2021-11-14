{-# LANGUAGE OverloadedStrings #-}

module Main where


import Control.Monad.Logger
import Database.Persist.Postgresql (withPostgresqlPool, runSqlPersistMPool, runMigration, ConnectionString, insert)
import Control.Monad.IO.Class (liftIO)

import Server
import Schema
import Postgre

connString :: ConnectionString
connString = "host=127.0.0.1 port=5432 user=unicorn_user dbname=chatb password=magical_password"


main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connString 10 $ \pool -> liftIO $ do
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll
      insert $ Room "Test" 
    startApp pool

