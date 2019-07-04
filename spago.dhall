{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "aff"
    , "console"
    , "debug"
    , "effect"
    , "node-fs"
    , "node-fs-aff"
    , "node-path"
    , "node-process"
    , "pathy"
    , "psci-support"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
