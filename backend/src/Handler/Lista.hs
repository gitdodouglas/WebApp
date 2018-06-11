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
import Prelude (read)

--------------------------------------
optionsListasUserR :: Handler ()
optionsListasUserR = anyOriginIn [ F.OPTIONS, F.GET ]

optionsListasCompR :: Handler ()
optionsListasCompR = anyOriginIn [ F.OPTIONS, F.GET ]

optionsCadListR :: Handler()
optionsCadListR = anyOriginIn [ F.OPTIONS, F.POST ]

optionsOpListR :: ListaId -> Handler ()
optionsOpListR _ = anyOriginIn [ F.OPTIONS, F.POST, F.GET, F.DELETE ]

optionsOpNLista :: ListaId -> Text -> Handler ()
optionsOpNLista _ _ = anyOriginIn [ F.OPTIONS, F.PATCH ]

optionsOpTLista :: ListaId -> Text -> Handler ()
optionsOpTLista _ _ = anyOriginIn [ F.OPTIONS, F.PATCH ]
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

-- atualiza o nome da lista pelo id
patchOpNLista :: ListaId -> Text -> Handler Value
patchOpNLista lid novoNomeLista = do
    anyOriginIn [ F.OPTIONS, F.PATCH ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            _ <- runDB $ get404 lid
            runDB $ update lid [ListaNome =. novoNomeLista]
            sendStatusJSON ok200 (object ["resp" .= ("ok"::Text)])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

-- atualiza o valor total da lista pelo id
patchOpTLista :: ListaId -> Text -> Handler Value
patchOpTLista lid total = do
    anyOriginIn [ F.OPTIONS, F.PATCH ]
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            _ <- runDB $ get404 lid
            runDB $ update lid [ListaTotal =. (read $ unpack total)]
            sendStatusJSON ok200 (object ["resp" .= ("ok"::Text)])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

-- deleta uma lista pelo id
deleteOpListR :: ListaId -> Handler Value
deleteOpListR lid = do
    _ <- runDB $ get404 lid
    runDB $ delete lid
    sendStatusJSON noContent204 (object [])

-- recupera uma lista pelo id
getOpListR :: ListaId -> Handler Value
getOpListR lid = do
    token <- getTokenHeader
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of
        Just (Entity uid usuario) -> do
            anyOriginIn [ F.OPTIONS, F.GET ]
            lista <- runDB $ get404 lid
            sendStatusJSON ok200 (object ["resp" .= lista])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])

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