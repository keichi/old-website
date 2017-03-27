--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.List        (isPrefixOf, isSuffixOf)
import           Data.Monoid ((<>))
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match ("images/*" .||. "fonts/*" .||. fromList staticFiles) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "index.md" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/index.html" baseCtx
            >>= loadAndApplyTemplate "templates/default.html" baseCtx
            >>= relativizeUrls

    match (fromList pages) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" baseCtx
            >>= loadAndApplyTemplate "templates/default.html" baseCtx
            >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

    create ["sitemap.xml"] $ do
        route   idRoute
        compile $ do
            pages <- mapM load (["index.md"] ++ pages)
            let ctx = listField "entries" baseCtx (return pages) <>
                      baseCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/sitemap.xml" ctx

  where
    config = defaultConfiguration {
        ignoreFile = ignoreFile'
    }

    ignoreFile' fileName
        | ".static" == fileName        = False
        | "."    `isPrefixOf` fileName = True
        | "#"    `isPrefixOf` fileName = True
        | "~"    `isSuffixOf` fileName = True
        | ".swp" `isSuffixOf` fileName = True
        | otherwise                    = False

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
        , ".static"
        , "keybase.txt"
        ]

    pages =
        [ "contact.md"
        , "projects.md"
        , "research-topics.md"
        , "publications.md"
        ]

    baseCtx = modificationTimeField "lastmod" "%F" <>
              constField "siteroot" "https://keichi.net" <>
              constField "sitetitle" "Keichi Takahashi" <>
              defaultContext
