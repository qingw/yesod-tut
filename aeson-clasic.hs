import Control.Applicative
import Control.Monad
import Data.Aeson
import Data.HashMap.Strict
import qualified Data.ByteString.Lazy.Char8 as BL

data Person = Person
    { personName :: String
    , personAge :: Maybe Int
    } deriving Show

instance FromJSON Person where
    parseJSON (Object v) = Person 
        <$> v .: "personName"
        <*> v .: "personAge"
    parseJSON _ = mzero

instance ToJSON Person where
    toJSON (Person name age) = Object . fromList $
        ["personName" .= name, "personAge" .= age]

john = Person "John" (Just 20)
girl = Person "Alic" Nothing

str = "{\"personAge\": 100, \"personName\": \"Tom\"}"

main = do
    BL.putStrLn $ encode john
    BL.putStrLn $ encode girl

    let tom = decode str :: Maybe Person
    let badman = decode "eval drop table *" :: Maybe Person

    BL.putStrLn $ encode tom
    BL.putStrLn $ encode badman
