{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Handler.Auxiliar

formLogin :: Form (Usuario, Text)
formLogin = renderDivs $ (,)
        <$> (Usuario
            <$> areq textField "Email: " Nothing
            <*> areq passwordField "Senha: " Nothing
            )
        <*> areq passwordField "Confirmação: " Nothing
    
getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout (formWidget widget msg UsuarioR "Cadastrar")
--
postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (usuario@(Usuario email senha), conf) -> do
            usuarioExiste <- runDB $ getBy (UniqueEmail email)
            case usuarioExiste of
                Just _ -> do
                    setMessage [shamlet|
                        <div>
                            EMAIL JÁ CADASTRADO!
                        |]
                    redirect UsuarioR
                Nothing -> do
                    if senha == conf then do
                        runDB $ insert usuario
                        setMessage [shamlet|
                            <div>
                                USUARIO INSERIDO COM SUCESSO!
                        |]
                        redirect UsuarioR
                    else do
                        setMessage [shamlet|
                            <div>
                                SENHA E CONFIRMAÇÃO DIFERENTES!
                        |]
                        redirect UsuarioR
        _ -> redirect HomeR
