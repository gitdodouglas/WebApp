{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Lista where

import Import
import Handler.Funcs as F
import Network.HTTP.Types.Status
import Network.Wai as NW
import Database.Persist.Postgresql
import qualified Data.Text as T
import qualified Data.Maybe as M

--------------------------------------
optionsListasUserR :: Handler ()
optionsListasUserR = anyOriginIn [ F.OPTIONS, F.GET ]

optionsListasCompR :: Handler ()
optionsListasCompR = anyOriginIn [ F.OPTIONS, F.GET ]

optionsCadListR :: Handler()
optionsCadListR = anyOriginIn [ F.OPTIONS, F.POST ]
--------------------------------------



-- busca todas as listas que foram compartilhadas com o usuário
getListasCompR :: Handler Value
getListasCompR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            _ <- runDB $ get404 uid
            objuser <- runDB $ selectFirst [UsuarioId ==. uid] []
            emailuser <- return $ fmap(\user -> usuarioEmail $ entityVal user) objuser
            listascomp <- runDB $ selectList [PossuiEmailcomp ==. emailuser] []
            listaid <- return $ fmap(\ls -> possuiListaid $ entityVal ls) listascomp
            lista <- runDB $ selectList [ListaId <-. listaid] [Asc ListaNome]
            sendStatusJSON ok200 (object ["resp" .= lista])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

-- busca todas as listas que o usuário possui
getListasUserR :: Handler Value
getListasUserR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            _ <- runDB $ get404 uid
            possui <- runDB $ selectList [PossuiUsuarioid ==. uid] []
            listaid <- return $ fmap(\ls -> possuiListaid $ entityVal ls) possui
            lista <- runDB $ selectList [ListaId <-. listaid] [Asc ListaNome]
            sendStatusJSON ok200 (object ["resp" .= lista])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

-- atualiza todos os campos de uma lista pelo id
putOpListR :: ListaId -> Handler Value
putOpListR lid = do
    _ <- runDB $ get404 lid
    listaNova <- requireJsonBody :: Handler Lista
    runDB $ replace lid listaNova
    sendStatusJSON noContent204 (object [])

-- deleta uma lista pelo id
deleteOpListR :: ListaId -> Handler Value
deleteOpListR lid = do
    _ <- runDB $ get404 lid
    runDB $ delete lid
    sendStatusJSON noContent204 (object [])

-- recupera uma lista pelo id
getOpListR :: ListaId -> Handler Value
getOpListR lid = do
    lista <- runDB $ get404 lid
    sendStatusJSON ok200 (object ["resp" .= lista])

-- recupera todas as listas
getRecListR :: Handler Value
getRecListR = do
    listas <- runDB $ selectList [] [Asc ListaNome]
    sendStatusJSON ok200 (object ["resp" .= listas])

-- cadastra uma lista
postCadListR :: Handler Value
postCadListR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            lista <- requireJsonBody :: Handler Lista
            lid <- runDB $ insert lista -- inseriu na tabela lista
            pid <- runDB $ insert (Possui Nothing uid lid)
            sendStatusJSON created201 (object ["id" .= fromSqlKey lid, "nome" .= (tiraNome lista), "total" .= ("0.00"::Text)])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

tiraNome :: Lista -> Text
tiraNome (Lista nome total) = nome

tiraEmail :: Usuario -> Maybe Text
tiraEmail (Usuario nome email senha token) = Just email