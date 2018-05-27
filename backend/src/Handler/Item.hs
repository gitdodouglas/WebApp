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
getBuscarItensR :: ListaId -> Handler Value
getBuscarItensR lid = do
    _ <- runDB $ get404 lid
    itemP <- runDB $ selectList [ItemProdutoListaid ==. lid] []
    prodid <- return $ fmap(\ls -> itemProdutoProdutoid $ entityVal ls) itemP
    produto <- runDB $ selectList [ProdutoId <-. prodid] []
    sendStatusJSON ok200 (object ["resp" .= object(["produto" .= produto, "item" .= itemP]) ])

-- atualiza todos os campos de um item de produto pelo id
putItemEspecR :: ItemProdutoId -> Handler Value
putItemEspecR ipid = do
    _ <- runDB $ get404 ipid
    itemNovo <- requireJsonBody :: Handler ItemProduto
    runDB $ replace ipid itemNovo
    sendStatusJSON noContent204 (object [])

-- deleta um item de produto pelo id
deleteItemEspecR :: ItemProdutoId -> Handler Value
deleteItemEspecR ipid = do
    _ <- runDB $ get404 ipid
    runDB $ delete ipid
    sendStatusJSON noContent204 (object [])

-- recupera um item de produto pelo id
getItemEspecR :: ItemProdutoId -> Handler Value
getItemEspecR ipid = do
    item <- runDB $ get404 ipid
    sendStatusJSON ok200 (object ["resp" .= item])

-- recupera todos os itens de produto
getItemR :: Handler Value
getItemR = do
    itens <- runDB $ selectList [] [Asc ItemProdutoId]
    sendStatusJSON ok200 (object ["resp" .= itens])

-- insere um item de produto
postItemR :: Handler Value
postItemR = do
    item <- requireJsonBody :: Handler ItemProduto
    ipid <- runDB $ insert item
    sendStatusJSON created201 (object ["resp" .= fromSqlKey ipid])