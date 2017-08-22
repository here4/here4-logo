module Here4.Logo
    exposing
        ( logo
        , logoWith
        , textureLogo
        )

import Here4.Appearance exposing (..)
import Math.Vector3 exposing (..)
import Math.Vector4 exposing (Vec4, vec4)
import Math.Matrix4 as M4 exposing (..)
import Shaders.TextureFragment exposing (textureFragment)
import Shaders.WorldVertex exposing (Vertex, worldVertex)
import WebGL exposing (..)


type alias Triple a =
    ( a, a, a )



logo =
    render logoMesh

logoWith f =
    renderNSV (logoMeshWith f)



-- render : Mesh vertex -> Shader vertex ShaderPerception a -> Shader {} ShaderPerception a -> Appearance


render mesh vertexShader fragmentShader p =
    let
        resolution =
            vec3 (toFloat p.windowSize.width) (toFloat p.windowSize.height) 0

        s =
            p.globalTime

        iHMD =
            if p.cameraVR then
                1.0
            else
                0.0
    in
        [ entity vertexShader
            fragmentShader
            mesh
            { iResolution = resolution
            , iHMD = iHMD
            , iGlobalTime = s
            , iLensDistort = p.lensDistort
            , modelViewProjectionMatrix = M4.mul p.perspective p.lookAt
            , modelMatrix = M4.identity
            , viewPosition = p.cameraPos
            , lightPosition = p.lightPosition
            , ambientColor = p.ambientColor
            }
        ]


renderNSV mesh vertexShader fragmentShader p =
    let
        resolution =
            vec3 (toFloat p.windowSize.width) (toFloat p.windowSize.height) 0

        s =
            p.globalTime

        detail =
            p.measuredFPS / 3.0

        iHMD =
            if p.cameraVR then
                1.0
            else
                0.0
    in
        [ entity vertexShader
            fragmentShader
            mesh
            { iResolution = resolution
            , iHMD = iHMD
            , iGlobalTime = s
            , iLensDistort = p.lensDistort
            , modelViewProjectionMatrix = M4.mul p.perspective p.lookAt
            , modelMatrix = M4.identity
            , viewPosition = p.cameraPos
            , lightPosition = p.lightPosition
            , ambientColor = p.ambientColor
            , iDetail = detail
            , iGlobalTimeV = s
            }
        ]


textureLogo : WebGL.Texture -> Appearance
textureLogo texture p =
    let
        resolution =
            vec3 (toFloat p.windowSize.width) (toFloat p.windowSize.height) 0

        iHMD =
            if p.cameraVR then
                1.0
            else
                0.0
    in
        [ entity worldVertex
            textureFragment
            logoMesh
            { iResolution = resolution
            , iHMD = iHMD
            , iTexture = texture
            , iLensDistort = p.lensDistort
            , modelViewProjectionMatrix = M4.mul p.perspective p.lookAt
            , modelMatrix = M4.identity
            , viewPosition = p.cameraPos
            , lightPosition = p.lightPosition
            , ambientColor = p.ambientColor
            }
        ]


map3 : (a -> b) -> Triple a -> Triple b
map3 f ( v1, v2, v3 ) =
    ( f v1, f v2, f v3 )


logoMesh : Mesh Vertex
logoMesh =
    triangles <| List.concatMap rotatedFace [ ( 0, 0, 0 ), ( 90, 0, 1 ), ( 180, 0, 2 ), ( 270, 0, 3 ), ( 0, 90, 0 ), ( 0, -90, 0 ) ]


logoMeshWith : (Vertex -> v) -> Mesh v
logoMeshWith f =
    triangles <| List.map (map3 f) <| List.concatMap rotatedFace [ ( 0, 0, 0 ), ( 90, 0, 1 ), ( 180, 0, 2 ), ( 270, 0, 3 ), ( 0, 90, 0 ), ( 0, -90, 0 ) ]


rotatedFace : ( Float, Float, Float ) -> List (Triple Vertex)
rotatedFace ( angleX, angleY, coordX ) =
    let
        x =
            makeRotate (degrees angleX) (vec3 1 0 0)

        y =
            makeRotate (degrees angleY) (vec3 0 1 0)

        t =
            M4.transform (mul x (mul y (makeTranslate (vec3 0 0 0.5))))
                >> add (vec3 0 0.5 0)

        each f ( a, b, c ) =
            ( f a, f b, f c )
    in
        List.map
            ( each
                (\x -> { x | position = t x.position
                           , normal = t x.normal
                           , coord = add (vec3 coordX 0 0) x.coord
                       }
                )
            )
            face


face : List (Triple Vertex)
face =
    let
        white =
            vec4 1 1 1 1

        normal = 
            vec3 0 0 1

        topLeft =
            { position = vec3 -0.5 0.5 0
            , normal = normal
            , coord = vec3 0 1 0
            , color = white
            }

        topRight =
            { position = vec3 0.5 0.5 0
            , normal = normal
            , coord = vec3 1 1 0
            , color = white
            }

        bottomLeft =
            { position = vec3 -0.5 -0.5 0
            , normal = normal
            , coord = vec3 0 0 0
            , color = white
            }

        bottomRight =
            { position = vec3 0.5 -0.5 0
            , normal = normal
            , coord = vec3 1 0 0
            , color = white
            }
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]
