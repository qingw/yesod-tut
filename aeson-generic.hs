import Data.Aeson
import GHC.Generics
import Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy.Char8 as BL

data Person = Person
    { personName :: String
    , personAge :: Maybe Int
    } deriving (Generic, Show)

instance FromJSON Person
instance ToJSON Person

john = Person "John" (Just 20)
girl = Person "Alic" Nothing

str = "{\"personAge\": 100, \"personName\": \"Tom\"}"

main = do
    BL.putStrLn $ encodePretty john
    BL.putStrLn $ encodePretty girl
    let tom = decode str :: Maybe Person
    let badman = decode "eval drop table *" :: Maybe Person
    BL.putStrLn $ encodePretty tom
    BL.putStrLn $ encodePretty badman
