module Demo exposing (create, Flags, Model, Msg)

import Here4.App exposing (..)
import Here4.Control exposing (..)
import Here4.Dispatch exposing (..)
import Here4.Navigator.Control exposing (NavMsg)
import Here4.Model as Model
import Here4.World as World exposing (..)
import Task


type alias Flags = ()


type alias DemoMsg
    = ()


type alias Msg =
    WorldMsg (NavMsg DemoMsg)


type alias DemoModel = ()


type alias Model =
    Multiverse DemoModel


create :
    List World.Attributes
    -> Program Flags (Model.Model Model Msg) (Model.Msg Msg)
create attributes =
    World.create init update subscriptions attributes


init : Flags -> ( DemoModel, Cmd (NavMsg DemoMsg) )
init flags =
    ( () , Cmd.none )


update : NavMsg DemoMsg -> DemoModel -> ( DemoModel, Cmd (NavMsg DemoMsg) )
update msg model = ( model, Cmd.none )


subscriptions : Multiverse DemoModel -> Sub (NavMsg DemoMsg)
subscriptions model = Sub.none
