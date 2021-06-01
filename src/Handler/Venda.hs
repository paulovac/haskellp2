{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Venda where

import Import
import Handler.Auxiliar

formVenda :: Maybe Venda -> Form Venda
formVenda mc = renderDivs $ Venda
    <$> areq textField "Cliente: " (fmap vendaCliente mc)
    <*> areq textField "Produto: " (fmap vendaProduto mc)
    <*> areq intField  "Data: " (fmap vendaData mc) 
    <*> areq intField  "Valor: " (fmap vendaValor mc) 

getVendaR :: Handler Html
getVendaR = do
    (widget,_) <- generateFormPost (formVenda Nothing)
    msg <- getMessage
    defaultLayout (formWidget widget msg VendaR "Cadastrar")

postVendaR :: Handler Html
postVendaR = do
    ((result,_),_) <- runFormPost (formVenda Nothing)
    case result of
        FormSuccess venda -> do
            runDB $ insert venda
            setMessage [shamlet|
                <div>
                    VENDA INCLUÍDA COM SUCESSO!
            |]
            redirect VendaR
        _ -> redirect HomeR

getPerfilVendR :: VendaId -> Handler Html
getPerfilVendR vid = do
    venda <- runDB $ get404 vid
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/perfilvenda.hamlet")
        
getListaVendR :: Handler Html
getListaVendR = do
    vendas <- runDB $ selectList [] [Asc VendaCliente]
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/vendas.hamlet")

postApagarVendR :: VendaId -> Handler Html
postApagarVendR vid = do
    runDB $ delete vid
    redirect ListaVendR
    
getEditarVendR :: VendaId -> Handler Html
getEditarVendR vid = do
    venda <- runDB $ get404 vid
    (widget,_) <- generateFormPost (formVenda (Just venda))
    msg <- getMessage
    defaultLayout (formWidget widget msg (EditarVendR vid) "Editar")

postEditarVendR :: VendaId -> Handler Html
postEditarVendR vid = do
    _ <- runDB $ get404 vid 
    ((result,_),_) <- runFormPost (formVenda Nothing)
    case result of
         FormSuccess vendaNovo -> do
             runDB $ replace vid vendaNovo
             redirect ListaVendR
         _ -> redirect HomeR
