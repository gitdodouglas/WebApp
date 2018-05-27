{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Item where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- busca todos os itens de uma lista
getItensListaR :: ListaId -> Handler Value
getItensListaR lid = do
    _ <- runDB $ get404 lid
    itemP <- runDB $ selectList [ItemProdutoListaid ==. lid] []
    prodid <- return $ fmap(\ls -> itemProdutoProdutoid $ entityVal ls) itemP
    produto <- runDB $ selectList [ProdutoId <-. prodid] []
    sendStatusJSON ok200 (object ["resp" .= object(["produto" .= produto, "item" .= itemP]) ])

-- atualiza todos os campos de um item de produto pelo id
putOpItemR :: ItemProdutoId -> Handler Value
putOpItemR ipid = do
    _ <- runDB $ get404 ipid
    itemNovo <- requireJsonBody :: Handler ItemProduto
    runDB $ replace ipid itemNovo
    sendStatusJSON noContent204 (object [])

-- deleta um item de produto pelo id
deleteOpItemR :: ItemProdutoId -> Handler Value
deleteOpItemR ipid = do
    _ <- runDB $ get404 ipid
    runDB $ delete ipid
    sendStatusJSON noContent204 (object [])

-- recupera um item de produto pelo id
getOpItemR :: ItemProdutoId -> Handler Value
getOpItemR ipid = do
    item <- runDB $ get404 ipid
    sendStatusJSON ok200 (object ["resp" .= item])

-- recupera todos os itens de produto
getRecItemR :: Handler Value
getRecItemR = do
    itens <- runDB $ selectList [] [Asc ItemProdutoId]
    sendStatusJSON ok200 (object ["resp" .= itens])

-- cadastra um item de produto
postCadItemR :: Handler Value
postCadItemR = do
    item <- requireJsonBody :: Handler ItemProduto
    ipid <- runDB $ insert item
    sendStatusJSON created201 (object ["resp" .= fromSqlKey ipid])