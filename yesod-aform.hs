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

personForm :: Html -> MForm App App (FormResult Person, Widget)
personForm = renderDivs $ Person
    <$> (Text.unpack <$> areq textField "personName" Nothing)
    <*> aopt intField "personAge" Nothing

getPersonR = do
    (widget, enctype) <- generateFormPost personForm
    defaultLayout [whamlet|
<form method=post action=@{PersonR} enctype=#{enctype}>
    ^{widget}
    <input type=submit value=提交>
|]

postPersonR = do
    ((result, widget), enctype) <- runFormPost personForm
    case result of
        FormSuccess (person :: Person) -> defaultLayout [whamlet|You are: #{show person} .|]
        _ -> defaultLayout [whamlet| Invalid input, let's try again.|]

main :: IO ()
main = warpDebug 3000 App

