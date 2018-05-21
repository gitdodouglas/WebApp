{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Produto where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- atualiza todos os campos de um produto pelo id
putProdEspecR :: ProdutoId -> Handler Value
putProdEspecR pid = do
    _ <- runDB $ get404 pid
    produtoNovo <- requireJsonBody :: Handler Produto
    runDB $ replace pid produtoNovo
    sendStatusJSON noContent204 (object [])

-- deleta um produto pelo id
deleteProdEspecR :: ProdutoId -> Handler Value
deleteProdEspecR pid = do
    _ <- runDB $ get404 pid
    runDB $ delete pid
    sendStatusJSON noContent204 (object [])

-- recupera um produto pelo id
getProdEspecR :: ProdutoId -> Handler Value
getProdEspecR pid = do
    produto <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= produto])

-- recupera todos os produtos
getProdutoR :: Handler Value
getProdutoR = do
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    sendStatusJSON ok200 (object ["resp" .= produtos])

-- insere um produto
postProdutoR :: Handler Value
postProdutoR = do
    produto <- requireJsonBody :: Handler Produto
    pid <- runDB $ insert produto
    sendStatusJSON created201 (object ["resp" .= fromSqlKey pid])