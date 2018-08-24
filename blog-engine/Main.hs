{-# LANGUAGE OverloadedStrings #-}

-- base
import Control.Applicative
import Control.Monad
import Data.Monoid

-- hakyll
import Hakyll

-- pandoc
import Text.Pandoc


rules :: Rules ()
rules = do
  match "templates/*" $
    compile templateCompiler

  match "css/***.css" $ do
    route idRoute
    compile copyFileCompiler

  match "img/***" $ do
    route idRoute
    compile copyFileCompiler

  match "posts/***.md" $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= saveSnapshot "content"
      >>= loadAndApplyTemplate "templates/post.html" defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  create ["index.html"] $ do
    route idRoute
    compile $ do
      posts <- loadAll "posts/*" >>= recentFirst

      postItem <- loadBody "templates/postitem.html"
      postStr <- applyTemplateList postItem defaultContext posts

      makeItem ""
        >>= loadAndApplyTemplate "templates/home.html"
              (constField "posts" postStr <>
               defaultContext)
        >>= relativizeUrls


main :: IO ()
main =
  hakyll rules
