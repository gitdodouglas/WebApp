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
---------------------------------------------------
optionsLoginnR :: Handler ()
optionsLoginnR = anyOriginIn [ F.OPTIONS, F.POST ]
---------------------------------------------------
optionsRegisterR :: Handler ()
optionsRegisterR = anyOriginIn [ F.OPTIONS, F.POST ]
----------------------------------------------------
optionsLogouttR :: Handler ()
optionsLogouttR = anyOriginIn [ F.OPTIONS, F.POST ]
----------------------------------------------------

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
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Usuario
    hashUser <- setPassword (usuarioEmail usu) usu
    usuarioId <- runDB $ insert hashUser
    sendStatusJSON created201 (object ["resp" .= (usuarioToken hashUser)])


postLogouttR :: Handler Value
postLogouttR = do 
    token <- getTokenHeader
    anyOriginIn [ F.OPTIONS, F.POST ]
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of 
        Just (Entity uid usuario) -> do
            newHashUser <- setPassword (usuarioEmail usuario) usuario
            runDB $ update uid [UsuarioToken =. (usuarioToken newHashUser)]
            sendStatusJSON ok200 (object ["resp" .= ("usuario deslogado"::Text)])
        _ -> 
            sendStatusJSON status404 (object ["resp" .= ("Usuário não cadastrado"::Text)] )
