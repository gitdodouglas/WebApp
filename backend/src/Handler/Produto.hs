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
putOpProdR :: ProdutoId -> Handler Value
putOpProdR pid = do
    _ <- runDB $ get404 pid
    produtoNovo <- requireJsonBody :: Handler Produto
    runDB $ replace pid produtoNovo
    sendStatusJSON noContent204 (object [])

-- deleta um produto pelo id
deleteOpProdR :: ProdutoId -> Handler Value
deleteOpProdR pid = do
    _ <- runDB $ get404 pid
    runDB $ delete pid
    sendStatusJSON noContent204 (object [])

-- recupera um produto pelo id
getOpProdR :: ProdutoId -> Handler Value
getOpProdR pid = do
    produto <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= produto])

-- recupera todos os produtos
getRecProdR :: Handler Value
getRecProdR = do
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    sendStatusJSON ok200 (object ["resp" .= produtos])

-- cadastra um produto
postCadProdR :: Handler Value
postCadProdR = do
    produto <- requireJsonBody :: Handler Produto
    pid <- runDB $ insert produto
    sendStatusJSON created201 (object ["resp" .= fromSqlKey pid])