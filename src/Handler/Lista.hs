{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Lista where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- atualiza todos os campos de uma lista pelo id
putListEspecR :: ListaId -> Handler Value
putListEspecR lid = do
    _ <- runDB $ get404 lid
    listaNova <- requireJsonBody :: Handler Lista
    runDB $ replace lid listaNova
    sendStatusJSON noContent204 (object [])

-- deleta uma lista pelo id
deleteListEspecR :: ListaId -> Handler Value
deleteListEspecR lid = do
    _ <- runDB $ get404 lid
    runDB $ delete lid
    sendStatusJSON noContent204 (object [])

-- recupera uma lista pelo id
getListEspecR :: ListaId -> Handler Value
getListEspecR lid = do
    lista <- runDB $ get404 lid
    sendStatusJSON ok200 (object ["resp" .= lista])

-- recupera todas as listas
getListaR :: Handler Value
getListaR = do
    listas <- runDB $ selectList [] [Asc ListaNome]
    sendStatusJSON ok200 (object ["resp" .= listas])

-- insere uma lista
postListaR :: Handler Value
postListaR = do
    lista <- requireJsonBody :: Handler Lista
    lid <- runDB $ insert lista
    sendStatusJSON created201 (object ["resp" .= fromSqlKey lid])