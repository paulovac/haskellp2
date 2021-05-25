{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Calculos where

import Import

getSomaR :: Int -> Int -> Handler Html
getSomaR n1 n2 = do
    defaultLayout $ do
        res <- return (n1+n2)
        [whamlet|
            <h1>
                A SOMA E': #{res}
        |]
