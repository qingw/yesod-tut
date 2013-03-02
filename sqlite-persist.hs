{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell,
                 OverloadedStrings, GADTs, FlexibleContexts #-}
import Database.Persist.Sqlite
import Database.Persist.TH
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistUpperCase|
Person
    name String
    age Int
    deriving Show
BlogPost
    title String
    authorId PersonId
    deriving Show
|]

main :: IO ()
main = runSqlite ":memory:" $ do
    runMigration migrateAll

    johnId <- insert $ Person "John Doe" 35
    janeId <- insert $ Person "Jane Doe" 20

    insert $ BlogPost "My fr1st post" johnId
    insert $ BlogPost "One post" johnId

    oneJohnPost <- selectList [BlogPostAuthorId ==. johnId] [LimitTo 1]
    liftIO . print $ map entityVal oneJohnPost

    john <- get johnId
    liftIO $ print (john :: Maybe Person)

    delete janeId
    deleteWhere [BlogPostAuthorId ==. johnId]
