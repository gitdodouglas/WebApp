{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Produto where

import Import
import Handler.Funcs as F
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-------------------------------------------------------
optionsCadItemProdR :: Handler ()
optionsCadItemProdR = anyOriginIn [ F.OPTIONS, F.POST ]

optionsRecProdR :: ListaId -> Handler ()
optionsRecProdR _ = anyOriginIn [ F.OPTIONS, F.GET ]
-------------------------------------------------------

postCadItemProdR :: Handler Value
postCadItemProdR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            itemProduto <- requireJsonBody :: Handler ItemProduto
            pid <- runDB $ insert itemProduto
            dataProd <- runDB $ selectFirst [ProdutoId ==. (pegaIdProduto itemProduto)] []
            sendStatusJSON created201 (object ["resp" .= dataProd])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])


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
getRecProdR :: ListaId -> Handler Value --recebe o id da lista?
getRecProdR lid = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    itensProd <- runDB $ selectList [ItemProdutoListaid ==. lid] []
    idProds <- return $ fmap(\itpr -> itemProdutoProdutoid $ entityVal itpr) itensProd
    prodsN <- runDB $ selectList [ProdutoId /<-. idProds] []
    -- produtos <- runDB $ selectList [] [Asc ProdutoNome]
    sendStatusJSON ok200 (object ["resp" .= prodsN])

-- cadastra um produto
postCadProdR :: Handler Value
postCadProdR = do
    produto <- requireJsonBody :: Handler Produto
    pid <- runDB $ insert produto
    sendStatusJSON created201 (object ["resp" .= fromSqlKey pid])

pegaIdProduto:: ItemProduto -> ProdutoId
pegaIdProduto (ItemProduto _ _ _ _ pid) = pid