import Database.Sqlite
import Database.Persist.Store
import Data.Maybe
import Data.Text

data Person = Person
    { personName :: String
    , personAge :: Maybe Int
    } deriving Show

john = Person "John" (Just 55)
tom  = Person "Tom" (Just 30)

insertPerson conn (Person name age) = do
    insertStmt <- prepare conn "insert into person values (?, ?);"
    bindText insertStmt 1 (pack name)
    maybe (bindNull insertStmt 2) (\i -> bindInt insertStmt 2 i) age
    step insertStmt

main = do
    conn <- open "a.db"
    createStmt <- prepare conn "CREATE TABLE person (name VARCHAR NOT NULL, age INT)"
    step createStmt

    insertPerson conn john
    insertPerson conn tom

    selectStmt <- prepare conn "select name from person order by age limit 1";
    step selectStmt
    [PersistText name] <- columns selectStmt
    print $ name

