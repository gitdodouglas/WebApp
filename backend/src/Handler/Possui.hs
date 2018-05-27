{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Possui where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- busca todas as listas que foram compartilhadas com o usuário
getBuscarListasCompR :: UsuarioId -> Handler Value
getBuscarListasCompR uid = do
    _ <- runDB $ get404 uid
    usuario <- runDB $ selectFirst [UsuarioId ==. uid] []
    emailuser <- return $ fmap(\user -> usuarioEmail $ entityVal user) usuario
    listascomp <- runDB $ selectList [PossuiEmailcomp ==. emailuser] []
    listaid <- return $ fmap(\ls -> possuiListaid $ entityVal ls) listascomp
    lista <- runDB $ selectList [ListaId <-. listaid] [Asc ListaNome]
    sendStatusJSON ok200 (object ["resp" .= lista])

-- busca todas as listas que o usuário possui
getBuscarListasR :: UsuarioId -> Handler Value
getBuscarListasR uid = do
    _ <- runDB $ get404 uid
    possui <- runDB $ selectList [PossuiUsuarioid ==. uid] []
    listaid <- return $ fmap(\ls -> possuiListaid $ entityVal ls) possui
    lista <- runDB $ selectList [ListaId <-. listaid] [Asc ListaNome]
    sendStatusJSON ok200 (object ["resp" .= lista])

-- atualiza todos os campos de um 'possui' pelo id
putPossEspecR :: PossuiId -> Handler Value
putPossEspecR pid = do
    _ <- runDB $ get404 pid
    possuiNovo <- requireJsonBody :: Handler Possui
    runDB $ replace pid possuiNovo
    sendStatusJSON noContent204 (object [])

-- deleta um 'possui' pelo id
deletePossEspecR :: PossuiId -> Handler Value
deletePossEspecR pid = do
    _ <- runDB $ get404 pid
    runDB $ delete pid
    sendStatusJSON noContent204 (object [])

-- recupera um 'possui' pelo id
getPossEspecR :: PossuiId -> Handler Value
getPossEspecR pid = do
    possui <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= possui])

-- recupera todos os 'possui'
getPossuiR :: Handler Value
getPossuiR = do
    todosp <- runDB $ selectList [] [Asc PossuiId]
    sendStatusJSON ok200 (object ["resp" .= todosp])

-- insere um 'possui'
postPossuiR :: Handler Value
postPossuiR = do
    possui <- requireJsonBody :: Handler Possui
    pid <- runDB $ insert possui
    sendStatusJSON created201 (object ["resp" .= fromSqlKey pid])