-- This file is auto-generated by dhall-to-cabal-meta. Look but don't touch (unless you want your edits to be over-written).
let types = ../types.dhall

in  { autogen-modules =
        [] : List Text
    , build-depends =
        [] : List types.Dependency
    , build-tool-depends =
        [] : List
               { component :
                   Text
               , package :
                   Text
               , version :
                   types.VersionRange
               }
    , build-tools =
        [] : List { exe : Text, version : types.VersionRange }
    , buildable =
        True
    , c-sources =
        [] : List Text
    , cc-options =
        [] : List Text
    , compiler-options =
        ./CompilerOptions.dhall
    , cpp-options =
        [] : List Text
    , default-extensions =
        [] : List types.Extension
    , default-language =
        None types.Language
    , extra-framework-dirs =
        [] : List Text
    , extra-ghci-libraries =
        [] : List Text
    , extra-lib-dirs =
        [] : List Text
    , extra-libraries =
        [] : List Text
    , frameworks =
        [] : List Text
    , hs-source-dirs =
        [] : List Text
    , includes =
        [] : List Text
    , include-dirs =
        [] : List Text
    , install-includes =
        [] : List Text
    , js-sources =
        [] : List Text
    , ld-options =
        [] : List Text
    , other-extensions =
        [] : List types.Extension
    , other-languages =
        [] : List types.Language
    , other-modules =
        [] : List Text
    , pkgconfig-depends =
        [] : List { name : Text, version : types.PkgconfigVersionRange }
    , profiling-options =
        ./CompilerOptions.dhall
    , shared-options =
        ./CompilerOptions.dhall
    , static-options =
        ./CompilerOptions.dhall
    , mixins =
        [] : List types.Mixin
    , asm-options =
        [] : List Text
    , asm-sources =
        [] : List Text
    , cmm-options =
        [] : List Text
    , cmm-sources =
        [] : List Text
    , cxx-options =
        [] : List Text
    , cxx-sources =
        [] : List Text
    , virtual-modules =
        [] : List Text
    , extra-lib-flavours =
        [] : List Text
    , extra-bundled-libs =
        [] : List Text
    , autogen-includes =
        [] : List Text
    , extra-dyn-lib-flavours =
        [] : List Text
    }
