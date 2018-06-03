{-# LANGUAGE OverloadedStrings #-}

module Handler.Funcs where

import Import
import qualified Data.Text as T
import Network.Wai as NW
import qualified Data.Maybe as M
import qualified Data.ByteString.Char8 as BS

data HttpMethod = OPTIONS | GET | POST | PUT | PATCH | DELETE deriving Show

anyOriginIn :: [HttpMethod] -> Handler ()
anyOriginIn methods = do
    addHeader (T.pack "Access-Control-Allow-Origin") (T.pack "*")
    addHeader (T.pack "Access-Control-Allow-Methods") $ T.intercalate (T.pack ", ") $ Prelude.map T.pack $ Prelude.map Prelude.show methods
    addHeader (T.pack "Access-Control-Allow-Headers") (T.pack "*")

-- getTokenHeader :: UsuarioId
getTokenHeader :: Handler Text
getTokenHeader = do
    a <- waiRequest
    listaHeader <- return $ NW.requestHeaders a
    return $ T.pack $ BS.unpack $ M.fromJust $ Prelude.lookup "key" listaHeader
