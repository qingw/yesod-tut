import Yesod
import qualified Data.Text as Text
import Control.Applicative

data Person = Person
    { personName :: String
    , personAge :: Maybe Int
    } deriving Show

data App = App


instance Yesod App
instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

parseInt :: String -> Maybe Int
parseInt str = case reads str of
    [(i,_)] -> Just i
    _ -> Nothing

mkYesod "App" [parseRoutes|
/person PersonR GET POST
|]

getPersonR = defaultLayout [whamlet|
<form method="post">                                                                                  
  <label>Name
  <input type="text" name="personName">                                                               
  <label>Age
  <input type="text" name="personAge">
  <input type="submit" value="提交" name="submit">
|]

postPersonR = do
  name <- Text.unpack <$> runInputPost (ireq textField "personName")
  age <- Text.unpack <$> runInputPost (ireq textField "personAge")
  let you = Person (name) (parseInt age)
  defaultLayout [whamlet|
You are: #{show you}
|]

main :: IO ()
main = warpDebug 3000 App

