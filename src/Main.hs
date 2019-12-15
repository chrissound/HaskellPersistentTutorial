{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
import           Control.Monad.IO.Class  (liftIO)
import           Database.Persist
import           Database.Persist.TH
import           Database.Persist.Postgresql
import           Control.Monad.IO.Class  (liftIO)
import           Control.Monad.Logger    (runStderrLoggingT)
import Data.List (find)
import User
import Data.String


dbConStr :: ConnectionString
dbConStr = "host=127.0.0.1 port=5432 user=postgres dbname=postgres password=mysecretpassword"

usermapper :: String -> String -> Update Person
usermapper "name" = (PersonName =.)
usermapper "age" = (PersonAge =.) . Just . read
usermapper _ = error "Invalid field"

main :: IO ()
main = do
  let input = [
          ("id", "1")
        , ("name", "Chris")
        , ("age", "100")
        ]
  let x = Person "" Nothing
  print x
  let inputId = case lookup "id" input of
        Just x -> read x
        Nothing -> error "no id specified"

  let updates = fmap (\(a,b) -> usermapper a b) $ tail input

  runStderrLoggingT $ withPostgresqlPool dbConStr 10 $ \pool -> liftIO $ do
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll

      maybePerson <- getUser inputId
      liftIO $ print "Found user:"
      liftIO $ print $ maybePerson

      update (toSqlKey 10) updates
