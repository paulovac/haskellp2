{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Carrinho where

import Import
import Handler.Auxiliar
import Database.Persist.Postgresql

formCarrinho :: ClienteId -> Form Carrinho
formCarrinho cid = renderDivs $ Carrinho
    <$> pure cid
    <*> areq (selectField prodCB) "Produto: " Nothing
    <*> lift (liftIO (map utctDay getCurrentTime))
    <*> areq intField "Quantidade: " Nothing

prodCB :: Handler (OptionList (Key Produto))
prodCB = do
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    optionsPairs $
        map (\r -> (produtoNome $ entityVal r, entityKey r)) produtos
    
getCompraR :: ClienteId -> Handler Html
getCompraR cid = do
    (widget,_) <- generateFormPost (formCarrinho cid)
    msg <- getMessage
    defaultLayout $
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}

            <h1>
                CADASTRO DE COMPRAS

            <form method=post action=@{CompraR cid}>
                ^{widget}
                <input type="submit" value="Comprar">
        |]
        
postCompraR :: ClienteId -> Handler Html
postCompraR cid = do
    ((result,_),_) <- runFormPost (formCarrinho cid)
    case result of
        FormSuccess carrinho -> do
            runDB $ insert carrinho
            setMessage [shamlet|
                <div>
                    COMPRA INCLUÍDA COM SUCESSO!
            |]
            redirect (CarrinhoR cid)
        _ -> redirect HomeR

mult :: Double -> Double -> Double
mult = (*)
        
getCarrinhoR :: ClienteId -> Handler Html
getCarrinhoR cid = do
    let sql = "SELECT ??,??,?? FROM produto \
          \ INNER JOIN carrinho ON carrinho.prodid = produto.id \
          \ INNER JOIN cliente ON carrinho.cliid = cliente.id \
          \ WHERE cliente.id = ?"
    cliente <- runDB $ get404 cid
    tudo <- runDB $ rawSql sql [toPersistValue cid] :: Handler [(Entity Produto,Entity Carrinho,Entity Cliente)]
    defaultLayout $ do
        [whamlet|
            <h1>
                CARRINHO DE #{clienteNome cliente}
            <ul>
                $forall (Entity _ produto, Entity _ carrinho, Entity _ _) <- tudo
                    <li>
                        #{produtoNome produto}, #{mult (produtoPreco produto) (fromIntegral (carrinhoQt carrinho))} no dia #{show $ carrinhoDia carrinho}
        |]
