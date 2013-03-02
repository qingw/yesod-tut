import Yesod
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

data REST = REST

mkYesod "REST" [parseRoutes|
/person PersonR GET
|]

instance Yesod REST

john = Person "John" (Just 20)
getPersonR = do
    let html = [whamlet|name:#{personName john}, age:#{show $ personAge john}|]
    defaultLayoutJson html john

main :: IO ()
main = warpDebug 3000 REST



