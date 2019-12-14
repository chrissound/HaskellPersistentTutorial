{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
module User where

import           Database.Persist
import           Database.Persist.TH
import           Database.Persist.Postgresql
import           Control.Monad.IO.Class  (liftIO)

import Control.Monad.Reader

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    name String
    age Int Maybe
    deriving Show
BlogPost
    title String
    authorId PersonId
    deriving Show
|]

-- :: (MonadBaseControl IO m, MonadIO m, IsSqlBackend backend)  
-- => Text 

-- getUser :: Key Person -> ReaderT backend (NoLoggingT (ResourceT m)) a 
getUser :: (MonadIO m) => Int -> ReaderT SqlBackend m Person
getUser x = do
  maybePerson <- get $ toSqlKey $ fromIntegral x
  case maybePerson of
      Nothing -> error "Just kidding, not really there"
      Just person -> pure person
