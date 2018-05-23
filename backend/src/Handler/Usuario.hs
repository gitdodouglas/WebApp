{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Yesod
import Foundation
import Import 
import Handler.Funcs as F
import Data.Text as T
import Yesod.Auth.HashDB (setPassword)
---------------------------------------------
optionsLoginnR :: Handler ()
optionsLoginnR = anyOriginIn [ F.OPTIONS, F.POST ]
---------------------------------------------

postLoginnR :: Handler Value    
postLoginnR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    (email,senha) <- requireJsonBody :: Handler (Text,Text)
    maybeUsuario <- runDB $ getBy $ UsuarioLogin email senha
    case maybeUsuario of
        Just (Entity uid usuario) -> do
            newHashUser <- setPassword (usuarioEmail usuario) usuario
            runDB $ update uid [UsuarioToken =. (usuarioToken newHashUser)]
            sendStatusJSON ok200 (object ["resp" .= (usuarioToken newHashUser) ])
        _ -> 
            sendStatusJSON status404 (object ["resp" .= ("Usuário não cadastrado"::Text)] )


postRegisterR :: Handler Value
postRegisterR = do
    addHeader (T.pack "Access-Control-Allow-Origin") (T.pack "*")
    addHeader (T.pack "Access-Control-Allow-Methods") (T.pack "POST, OPTIONS")
    addHeader (T.pack "Access-Control-Allow-Headers") (T.pack "Content-Type")
    usu <- requireJsonBody :: Handler Usuario
    hashUser <- setPassword (usuarioEmail usu) usu
    usuarioId <- runDB $ insert hashUser
    sendStatusJSON created201 (object ["resp" .= (usuarioToken hashUser)])


