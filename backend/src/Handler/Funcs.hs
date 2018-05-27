module Handler.Funcs where

import Yesod
import Foundation
import Data.Text as T
import Text.Show as S

data HttpMethod = OPTIONS | GET | POST | PUT | PATCH | DELETE deriving Show

anyOriginIn :: [HttpMethod] -> Handler ()
anyOriginIn methods = do
    addHeader (T.pack "Access-Control-Allow-Origin") (T.pack "*")
    addHeader (T.pack "Access-Control-Allow-Methods") $ T.intercalate (T.pack ", ") Prelude.$ Prelude.map T.pack Prelude.$ Prelude.map Prelude.show methods
    addHeader (T.pack "Access-Control-Allow-Headers") (T.pack "Content-Type")