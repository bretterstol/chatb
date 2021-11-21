{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE DataKinds #-}


module Schema where
  
import qualified Database.Persist.TH as PTH
import Data.Text
import Data.Time
import Data.Aeson
import Data.Aeson.TH


PTH.share [PTH.mkPersist PTH.sqlSettings, PTH.mkMigrate "migrateAll"] [PTH.persistLowerCase|
    User
      name Text
      created UTCTime default=CURRENT_TIME
      deriving Show Read
    Room
      name Text
      created UTCTime default=CURRENT_TIME
      deriving Show Read
   Message
      text Text
      created UTCTime default=CURRENT_TIME
      roomId RoomId
      userId UserId
      deriving Show Read
|]

$(deriveJSON defaultOptions ''User)
$(deriveJSON defaultOptions ''Room)
$(deriveJSON defaultOptions ''Message)
