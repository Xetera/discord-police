{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "discord-police"
, dependencies =
    [ "aff"
    , "ansi"
    , "console"
    , "debug"
    , "effect"
    , "node-fs"
    , "node-fs-aff"
    , "node-path"
    , "node-process"
    , "prelude"
    , "psci-support"
    , "test-unit"
    , "yargs"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
