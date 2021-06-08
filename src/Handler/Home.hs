{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Text.Lucius
import Text.Julius

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        usuario <- lookupSession "_ID"
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/home.hamlet")
        
getSobreR :: Handler Html
getSobreR = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/sobre.hamlet")
