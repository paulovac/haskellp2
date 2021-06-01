{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cliente where

import Import
import Handler.Auxiliar

formCliente :: Maybe Cliente -> Form Cliente
formCliente mc = renderDivs $ Cliente
    <$> areq textField "Nome: " (fmap clienteNome mc)
    <*> areq textField "Email: " (fmap clienteEmail mc)
    <*> areq textField "CPF: " (fmap clienteCpf mc)
    
getClienteR :: Handler Html
getClienteR = do
    (widget,_) <- generateFormPost (formCliente Nothing)
    msg <- getMessage
    defaultLayout (formWidget widget msg ClienteR "Cadastrar")

postClienteR :: Handler Html
postClienteR = do
    ((result,_),_) <- runFormPost (formCliente Nothing)
    case result of
        FormSuccess cliente -> do
            runDB $ insert cliente
            setMessage [shamlet|
                <div>
                    CLIENTE CADASTRADO COM SUCESSO!
            |]
            redirect ClienteR
        _ -> redirect HomeR
            
getPerfilR :: ClienteId -> Handler Html
getPerfilR cid = do
    cliente <- runDB $ get404 cid
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/perfil.hamlet")
    
getListaCliR :: Handler Html
getListaCliR = do
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/clientes.hamlet")
        
postApagarCliR :: ClienteId -> Handler Html
postApagarCliR cid = do
    runDB $ delete cid
    redirect ListaCliR

getEditarCliR :: ClienteId -> Handler Html
getEditarCliR cid = do
    cliente <- runDB $ get404 cid
    (widget,_) <- generateFormPost (formCliente (Just cliente))
    msg <- getMessage
    defaultLayout (formWidget widget msg (EditarCliR cid) "Editar")
    
postEditarCliR :: ClienteId -> Handler Html
postEditarCliR cid = do
    _ <- runDB $ get404 cid 
    ((result,_),_) <- runFormPost (formCliente Nothing)
    case result of
         FormSuccess clienteNovo -> do
             runDB $ replace cid clienteNovo
             redirect ListaCliR
         _ -> redirect HomeR
