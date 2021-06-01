{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Handler.Auxiliar

formLogin :: Form Usuario
formLogin = renderDivs $ Usuario
    <$> areq textField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getAutR :: Handler Html
getAutR = do 
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout (formWidget widget msg AutR "Entrar")

postAutR :: Handler Html
postAutR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (Usuario "admin@admin.com" "123") -> do
            setSession "_ID" "admin"
            redirect AdminR
        FormSuccess (Usuario email senha) -> do
            usuarioExiste <- runDB $ getBy (UniqueEmail email)
            case usuarioExiste of
                Nothing -> do
                    setMessage [shamlet|
                        USUARIO NÃO CADASTRADO!
                    |]
                    redirect AutR
                Just (Entity _ usuario) -> do
                    if senha == usuarioSenha usuario then do
                        setSession "_ID" (usuarioEmail usuario)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            USUARIO E/OU SENHA NÃO CONFEREM
                        |]
                        redirect AutR
        _ -> redirect HomeR
        
postSairR :: Handler Html
postSairR = do
    deleteSession "_ID"
    redirect HomeR
    
getAdminR :: Handler Html
getAdminR = do
    defaultLayout [whamlet|
        SEJA BEM-VINDO, ADMIN.
    |]
    redirect HomeR
