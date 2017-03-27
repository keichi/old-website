--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match ("images/*" .||. "fonts/*" .||. fromList staticFiles) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "index.md" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/index.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match (fromList pages) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

  where
    staticFiles =
        [ "android-chrome-192x192.png"
        , "android-chrome-512x512.png"
        , "apple-touch-icon.png"
        , "browserconfig.xml"
        , "crossdomain.xml"
        , "favicon-16x16.png"
        , "favicon-32x32.png"
        , "favicon.ico"
        , "manifest.json"
        , "mstile-144x144.png"
        , "mstile-150x150.png"
        , "mstile-310x150.png"
        , "mstile-310x310.png"
        , "mstile-70x70.png"
        , "robots.txt"
        , "safari-pinned-tab.svg"
        , "tile-wide.png"
        , "tile.png"
        ]

    pages =
        [ "contact.md"
        , "projects.md"
        , "research-topics.md"
        , "publications.md"
        ]
