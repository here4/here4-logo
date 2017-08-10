module Main exposing (main)

import Html exposing (Html)
import Here4.Location exposing (..)
import Here4.Navigator exposing (..)
import Here4.Object as Object
import Here4.Object.Attributes exposing (..)
import Here4.Orientation
import Here4.Placement exposing (defaultPlacement)
import Here4.Primitive.Cube exposing (skyCube, fireCube, fogMountainsCube, voronoiCube, cubeMesh)
import Here4.Primitive.Diamond exposing (cloudsDiamond, fogMountainsDiamond)
import Here4.Primitive.Sphere exposing (skySphere, cloudsSphere)
import Here4.RAM as RAM
import Here4.Vehicle.DreamBird as DreamBird
import Here4.Vehicle.DreamBuggy as DreamBuggy
import Here4.Vehicle.Walking as Walking
import Math.Vector3 as V3 exposing (vec3)
import Boids
import BoxRoom
import Balls
import Sky
import StaticGround
import WaterWalls
import Body.Terrain as Terrain
import Body.Wedge exposing (wedge)


main : Navigator RAM.Flags RAM.Model RAM.Msg
main =
    RAM.create
        [ { id = "world1"
          , label = "Logolia"
          , backgroundColor = rgb 135 206 235
          , apps =
                [ StaticGround.create Terrain.generate
                , WaterWalls.create defaultPlacement
                , Sky.create skySphere
                ]
          , defaultSelf = avatar 8.0
          }
        ]


avatar : Float -> ( App, Cmd AppMsg )
avatar speed =
    let
        html =
            Html.div []
                [ Html.h2 []
                    [ Html.text "Avatar" ]
                , Html.br [] []
                , Html.hr [] []
                , Walking.overlay
                ]
    in
        Object.create
            [ id "avatar"
            , label "Walking"
            , position <| vec3 0 0 0
            , overlay <| html
            , object <|
                Object.reflectiveObjWith
                    "avatar/suzanne.obj"
                    "avatar/elmLogoDiffuse.png"
                    [ offset <| FloorCenter
                    , scale <| Height 0.6
                    ]
            , vehicle <|
                { drive = Walking.drive
                , vehicle =
                    { speed = speed
                    , height = 1.0
                    , radius = 0.5
                    }
                }
            ]
