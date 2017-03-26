--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match ("images/*" .||. fromList staticFiles) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "index.html" $ do
        route   idRoute
        let ctx = constField "title" "About Me" <>
                  constField "index" "yes" <>
                  defaultContext
        compile $ getResourceBody
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    match (fromList pages) $ do
        route   $ setExtension "html"
        let ctx = defaultContext
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
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
        , "skills.md"
        ]