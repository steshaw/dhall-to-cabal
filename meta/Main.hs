{-# language LambdaCase #-}
{-# language OverloadedStrings #-}
{-# language RecordWildCards #-}
{-# language ViewPatterns #-}
module Main
  ( main
  )
  where

import Control.Applicative ( (<**>) )
import Data.Foldable ( for_ )
import Data.String ( fromString )
import System.Directory ( createDirectoryIfMissing )
import System.FilePath
  ( (</>), (<.>), dropTrailingPathSeparator, normalise
  , splitDirectories, splitFileName, takeDirectory
  )

import CabalToDhall
  ( KnownDefault, PreludeReference (..), getDefault )
import DhallToCabal.Util
  ( relativeTo )

import qualified Data.Text.Prettyprint.Doc as Pretty
import qualified Data.Text.Prettyprint.Doc.Render.Text as Pretty
import qualified Dhall.Core
import qualified Dhall.Core as Expr ( Expr(..) )
import qualified Dhall.Parser
import qualified Options.Applicative as OptParse
import qualified System.IO


data MetaOptions = MetaOptions
  { prefix :: FilePath }


metaOptionsParser :: OptParse.Parser MetaOptions
metaOptionsParser =
  MetaOptions
    <$>
      OptParse.strOption
        ( mconcat
            [ OptParse.long "prefix"
            , OptParse.value "dhall/"
            , OptParse.metavar "PATH"
            ]
        )


defaultFile :: KnownDefault -> FilePath
defaultFile typ = "./defaults" </> show typ <.> "dhall"


importFile :: FilePath -> Dhall.Core.Import
importFile ( splitFileName -> ( directory, filename ) ) =
  let
    components =
      fromString <$>
        splitDirectories ( dropTrailingPathSeparator directory )
  in
    Dhall.Core.Import
      { Dhall.Core.importHashed =
          Dhall.Core.ImportHashed
            { Dhall.Core.hash =
                Nothing
            , Dhall.Core.importType =
                Dhall.Core.Local
                  Dhall.Core.Here
                  ( Dhall.Core.File
                     ( Dhall.Core.Directory ( reverse components ) )
                     ( fromString filename )
                  )
            }
      , Dhall.Core.importMode =
          Dhall.Core.Code
      }


meta :: MetaOptions -> IO ()
meta (MetaOptions {..}) = do
  putStrLn $
    "Generating defaults underneath " ++ prefix ++ "."

  for_ [ minBound .. maxBound ] $ \ defaultType -> do
    let localDest =
          defaultFile defaultType

        -- normalise for prettiness in display (otherwise we get /./ components)
        dest =
          normalise ( prefix </> localDest )

        resolve = \case
          PreludeDefault typ ->
            Expr.Embed
              ( importFile ( relativeTo localDest ( defaultFile typ ) ) )
          PreludeConstructorsLicense ->
            Expr.Var "types" `Expr.Field` "License"
          PreludeConstructorsRepoKind ->
            Expr.Var "types" `Expr.Field` "RepoKind"
          PreludeConstructorsScope ->
            Expr.Var "types" `Expr.Field` "Scope"
          PreludeV ->
            Expr.Embed
              ( importFile ( relativeTo localDest "./Version/v.dhall" ) )

        expr :: Expr.Expr Dhall.Parser.Src Dhall.Core.Import
        expr =
          getDefault
            ( importFile ( relativeTo localDest "./types.dhall" ) )
            resolve
            defaultType

    putStrLn $
      "  Writing default for " ++ show defaultType ++ " to " ++ dest ++ "."

    createDirectoryIfMissing True ( takeDirectory dest )

    System.IO.withFile dest System.IO.WriteMode $ \ hnd -> do
      System.IO.hPutStrLn hnd $
           "-- This file is auto-generated by dhall-to-cabal-meta. Look but"
        ++ " don't touch (unless you want your edits to be over-written)."
      Pretty.renderIO
        hnd
        ( Pretty.layoutSmart prettyOpts
            ( Pretty.pretty expr )
        )


-- Shamelessly taken from dhall-format
prettyOpts :: Pretty.LayoutOptions
prettyOpts =
  Pretty.defaultLayoutOptions
    { Pretty.layoutPageWidth = Pretty.AvailablePerLine 80 1.0 }


main :: IO ()
main = do
  metaOpts <-
    OptParse.execParser opts

  meta metaOpts

  where

  opts =
    OptParse.info ( metaOptionsParser <**> OptParse.helper ) mempty