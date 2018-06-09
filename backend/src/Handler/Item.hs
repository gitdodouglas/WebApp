{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveAnyClass #-}
module Handler.Item where

import Import
import Handler.Funcs as F
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import qualified Data.Text as T
import qualified Data.Maybe as M

-----------------------------------------------
optionsItensListaR :: ListaId -> Handler ()
optionsItensListaR _ = anyOriginIn [ F.OPTIONS, F.GET ]

optionsOpItemR :: ListaId -> ProdutoId -> Handler () 
optionsOpItemR _ _ = anyOriginIn [ F.OPTIONS, F.DELETE ]
-----------------------------------------------
-- busca todos os itens de uma lista
getItensListaR :: ListaId -> Handler Value
getItensListaR lid = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            _ <- runDB $ get404 lid
            itemP <- runDB $ selectList [ItemProdutoListaid ==. lid] [Asc ItemProdutoProdutoid]
            prodid <- return $ map (\ls -> itemProdutoProdutoid $ entityVal ls) itemP
            produto <- runDB $ selectList [ProdutoId <-. prodid] [Asc ProdutoId]
            sendStatusJSON ok200 (object ["resp" .= object(["produtoLista" .= (zipWith unificaItemProduto (map entityVal itemP) (map entityVal produto))])])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

-- atualiza todos os campos de um item de produto pelo id
{-
putOpItemR :: ItemProdutoId -> Handler Value
putOpItemR ipid = do
    _ <- runDB $ get404 ipid
    itemNovo <- requireJsonBody :: Handler ItemProduto
    runDB $ replace ipid itemNovo
    sendStatusJSON noContent204 (object [])
-}
-- deleta um item de produto pelo id
deleteOpItemR :: ListaId -> ProdutoId -> Handler Value
deleteOpItemR lid pid = do
    anyOriginIn [ F.OPTIONS, F.DELETE ]
    listaProd <- runDB $ selectFirst [ItemProdutoListaid ==.lid, ItemProdutoProdutoid ==. pid] []
    runDB $ delete $ entityKey $ M.fromJust listaProd
    sendStatusJSON noContent204 ()

-- recupera um item de produto pelo id
{-
getOpItemR :: ItemProdutoId -> Handler Value
getOpItemR ipid = do
    item <- runDB $ get404 ipid
    sendStatusJSON ok200 (object ["resp" .= item])
-}
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

data ItemProd = ItemProd {
    nome::Text,
    valor::Double,
    qtItem::Int,
    listaid::ListaId,
    produtoid::ProdutoId
    } deriving Show

unificaItemProduto :: ItemProduto -> Produto -> ItemProd
unificaItemProduto (ItemProduto vluni qti _ lid pid) (Produto nome) = (ItemProd nome vluni qti lid pid)

instance ToJSON ItemProd where
    toJSON (ItemProd nome vluni qti lid pid) =
        object ["nome" .= nome, "vlunitario" .= vluni, "qtditem" .= qti, "listaId" .= lid, "produtoId" .= pid]