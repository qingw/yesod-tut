import Database.Persist.Sqlite
import Database.Persist.TH
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistUpperCase|
Person
    name String
    age Int Maybe
    deriving Show
|]


john = Person "John" (Just 35)
jim = Person "Jim" (Just 20)

main :: IO ()
main = do
    print $ john
    print $ jim
    print $ john { personAge = Nothing}
