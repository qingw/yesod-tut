import Control.Monad
import Data.Text(Text)
import qualified Data.Text.Lazy as TL
import Text.Markdown
import Database.Persist.Sqlite
import Control.Applicative
import Control.Monad.Logger
import Yesod

instance MonadLogger IO where
    monadLoggerLog _ _ _ _ = return ()
instance Yesod App
instance YesodPersist App where
    type YesodPersistBackend App = SqlPersist
    runDB action = getYesod >>= runSqlConn action . appConn

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

data App = App{
    appConn :: Connection
}

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistUpperCase|
Entry
  title Text
  content Text |]
mkYesod "App" [parseRoutes|
/     HomeR GET POST |]

form = renderDivs $ Entry <$> areq textField "标题" Nothing
    <*> (unTextarea <$> areq textareaField "正文" Nothing)

getHomeR = do
    (widget, enctype) <- generateFormPost form
    es <- runDB $ selectList [] []
    let blogs = map entityVal es
    defaultLayout $ do
        setTitle $ "我的博客"
        toWidget [whamlet|
$forall entry <- blogs    
    <h1> 标题 : #{entryTitle entry}
    <p> 内容
    <div>  #{renderMD $ entryContent entry}
<h3>张贴新文章
<form method=post action=@{HomeR} enctype=#{enctype}>
    ^{widget}
    <input type=submit value=发布>
|] where renderMD = markdown def . TL.fromStrict

postHomeR = do
    ((result, widget), enctype) <- runFormPost form
    case result of
        FormSuccess (entry :: Entry) -> void $ runDB $ insert entry
        _ -> setMessage "表单不正确"
    void $ redirect HomeR

main = withSqliteConn "blog.db" $ \conn -> do
    runSqlConn (runMigration migrateAll) conn
    warpDebug 3000 (App conn)
