{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Lista where

import Import
import Handler.Funcs as F
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

--------------------------------------
optionsListasUserR :: Text -> Handler ()
optionsListasUserR _ = anyOriginIn [ F.OPTIONS, F.GET ]
--------------------------------------



-- busca todas as listas que foram compartilhadas com o usuário
getListasCompR :: UsuarioId -> Handler Value
getListasCompR uid = do
    _ <- runDB $ get404 uid
    usuario <- runDB $ selectFirst [UsuarioId ==. uid] []
    emailuser <- return $ fmap(\user -> usuarioEmail $ entityVal user) usuario
    listascomp <- runDB $ selectList [PossuiEmailcomp ==. emailuser] []
    listaid <- return $ fmap(\ls -> possuiListaid $ entityVal ls) listascomp
    lista <- runDB $ selectList [ListaId <-. listaid] [Asc ListaNome]
    sendStatusJSON ok200 (object ["resp" .= lista])

-- busca todas as listas que o usuário possui
getListasUserR :: Text -> Handler Value
getListasUserR token = do
    anyOriginIn [ F.OPTIONS, F.GET ]
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
postCadListR :: Text -> Handler Value
postCadListR token = do
    maybeUser <- runDB $ selectFirst [UsuarioToken ==. token] []
    case maybeUser of 
        Just (Entity uid usuario) -> do
            lista <- requireJsonBody :: Handler Lista
            lid <- runDB $ insert lista
            sendStatusJSON created201 (object ["resp" .= fromSqlKey lid])
        _ -> sendStatusJSON forbidden403 (object [ "resp" .= ("acao proibida"::Text)])