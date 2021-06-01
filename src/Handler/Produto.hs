{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Produto where

import Import
import Handler.Auxiliar

formProduto :: Maybe Produto -> Form Produto
formProduto mc = renderDivs $ Produto
    <$> areq textField "Nome: " (fmap produtoNome mc)
    <*> areq textField "Código: " (fmap produtoCod mc)
    <*> areq intField  "Peso: " (fmap produtoPeso mc)
    <*> areq intField  "Volume: " (fmap produtoVolume mc)

getProdutoR :: Handler Html
getProdutoR = do
    (widget,_) <- generateFormPost (formProduto Nothing)
    msg <- getMessage
    defaultLayout (formWidget widget msg ProdutoR "Cadastrar")
        
postProdutoR :: Handler Html
postProdutoR = do
    ((result,_),_) <- runFormPost (formProduto Nothing)
    case result of
        FormSuccess produto -> do
            runDB $ insert produto
            setMessage [shamlet|
                <div>
                    PRODUTO INCLUÍDO COM SUCESSO!
            |]
            redirect ProdutoR
        _ -> redirect HomeR

getPerfilProdR :: ProdutoId -> Handler Html
getPerfilProdR pid = do
    produto <- runDB $ get404 pid
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/perfilprod.hamlet")
    
getListaProR :: Handler Html
getListaProR = do
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/produtos.hamlet")

postApagarProR :: ProdutoId -> Handler Html
postApagarProR pid = do
    runDB $ delete pid
    redirect ListaProR

getEditarProR :: ProdutoId -> Handler Html
getEditarProR pid = do
    produto <- runDB $ get404 pid
    (widget,_) <- generateFormPost (formProduto (Just produto))
    msg <- getMessage
    defaultLayout (formWidget widget msg (EditarProR pid) "Editar")
    
postEditarProR :: ProdutoId -> Handler Html
postEditarProR pid = do
    _ <- runDB $ get404 pid 
    ((result,_),_) <- runFormPost (formProduto Nothing)
    case result of
         FormSuccess produtoNovo -> do
             runDB $ replace pid produtoNovo
             redirect ListaProR
         _ -> redirect HomeR
