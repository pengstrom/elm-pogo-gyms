module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time)
import Date exposing (Date)
import Html.App as App
import GymApi exposing (..)
import Http
import Task
import View exposing (..)
import PokeAPI exposing (..)


(.) f g x =
    f (g x)


fromTeam : Team -> String
fromTeam t =
    case t of
        Neutral ->
            "Neutral"

        Mystic ->
            "Mystic"

        Valor ->
            "Valor"

        Instinct ->
            "Instinct"


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Maybe
        { gyms : List Gym
        , modified : Date
        }


init : ( Model, Cmd Msg )
init =
    Nothing ! [ getGyms ]


getGyms : Cmd Msg
getGyms =
    Task.perform GymsFailure GymsSuccess fetchGyms



--------------
--  UPDATE  --
--------------


type Msg
    = Update
    | GymsSuccess Gyms
    | GymsFailure Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update ->
            model ! [ getGyms ]

        GymsSuccess gyms ->
            Just { gyms = gyms.gyms, modified = gyms.modified } ! []

        GymsFailure error ->
            Nothing ! []



---------------------
--  SUBSCRIPTIONS  --
---------------------


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        id x y =
            x
    in
        Time.every (10 * Time.second) (id Update)



------------
--  VIEW  --
------------


view : Model -> Html Msg
view model =
    case model of
        Nothing ->
            text "Loading..."

        Just { gyms, modified } ->
            div [ id "content", class "container-fluid" ] <|
                List.map gymRow gyms
