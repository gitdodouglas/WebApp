{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Possui where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- atualiza todos os campos de um 'possui' pelo id
putOpPossR :: PossuiId -> Handler Value
putOpPossR pid = do
    _ <- runDB $ get404 pid
    possuiNovo <- requireJsonBody :: Handler Possui
    runDB $ replace pid possuiNovo
    sendStatusJSON noContent204 (object [])

-- deleta um 'possui' pelo id
deleteOpPossR :: PossuiId -> Handler Value
deleteOpPossR pid = do
    _ <- runDB $ get404 pid
    runDB $ delete pid
    sendStatusJSON noContent204 (object [])

-- recupera um 'possui' pelo id
getOpPossR :: PossuiId -> Handler Value
getOpPossR pid = do
    possui <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= possui])

-- recupera todos os 'possui'
getRecPossR :: Handler Value
getRecPossR = do
    todosp <- runDB $ selectList [] [Asc PossuiId]
    sendStatusJSON ok200 (object ["resp" .= todosp])

-- cadastra um 'possui'
postCadPossR :: Handler Value
postCadPossR = do
    possui <- requireJsonBody :: Handler Possui
    pid <- runDB $ insert possui
    sendStatusJSON created201 (object ["resp" .= fromSqlKey pid])