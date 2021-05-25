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
-- import Network.HTTP.Types.Status
-- import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/home.hamlet")
        
getPagina1 :: Handler Html
getPagina1 = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/p1.hamlet")
        
getPagina2 :: Handler Html
getPagina2 = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/p2.hamlet")
        
getPagina3 :: Handler Html
getPagina3 = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/p3.hamlet")
        
getPagina4 :: Handler Html
getPagina4 = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/p4.hamlet")

getPagina5 :: Handler Html
getPagina5 = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/home.julius")
        toWidgetHead $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/p5.hamlet")
