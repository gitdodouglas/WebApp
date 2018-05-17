{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postCadastroR :: Handler Value
postCadastroR = do
    dadosUsuario <- requireJsonBody :: Handler Usuario
    hashUser <- return (trocaToken dadosUsuario) -- usar funcao de hash?
    usuarioId <- runDB $ insert hashUser
    sendStatusJSON created201 (object ["resp" .= (hashUser)])

trocaToken :: Usuario -> Usuario
trocaToken (Usuario a b c d) = (Usuario a b c "troca")