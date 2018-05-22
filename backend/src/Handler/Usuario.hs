{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Handler.Funcs as F
import Yesod.Auth.HashDB (setPassword)
---------------------------------------------
optionsLoginnR :: Handler ()
optionsLoginnR = anyOriginIn [ F.OPTIONS, F.POST ]
---------------------------------------------

postLoginnR :: Handler Value    
postLoginnR = do
    (email,senha) <- requireJsonBody :: Handler (Text,Text)
    maybeUsuario <- runDB $ getBy $ UsuarioLogin email senha
    case maybeUsuario of
        Just (Entity uid usuario) -> do
            newHashUser <- setPassword (usuarioEmail usuario) usuario
            runDB $ update uid [UsuarioToken =. (usuarioToken newHashUser)]
            sendStatusJSON ok200 (object ["resp" .= (usuarioToken newHashUser) ])
        _ -> 
            sendStatusJSON status404 (object ["resp" .= ("Usuário não cadastrado"::Text)] )


postCadastroR :: Handler Value
postCadastroR = do
    usu <- requireJsonBody :: Handler Usuario
    hashUser <- setPassword (usuarioEmail usu) usu
    usuarioId <- runDB $ insert hashUser
    sendStatusJSON created201 (object ["resp" .= (usuarioToken hashUser)])


