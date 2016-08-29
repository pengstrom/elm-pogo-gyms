module View exposing (gymRow)

import Html exposing (..)
import Html.Attributes exposing (..)
import GymApi exposing (..)


table : Gym -> Html msg
table gym =
    Html.table [ class "table gym" ]
        [ thead []
            [ tr []
                [ th [] [ text "Trainer" ]
                , th [] [ text "Trainer Level" ]
                , th [] [ text "Pokemon" ]
                , th [] [ text "CP" ]
                , th [] [ text "Nickname" ]
                ]
            ]
        , tbody [] (tablerows gym.members)
        ]


gymTable : Gym -> Html msg
gymTable gym =
    div [ class "table-gym" ]
        [ div [ class <| "gym-header " ++ toString gym.team ]
            [ h3 [] [ text gym.name ] ]
        , table gym
        ]


tablerows : Members -> List (Html msg)
tablerows members =
    List.map tablerow members


fromNick : Maybe String -> String
fromNick mnick =
    case mnick of
        Just nick ->
            nick

        Nothing ->
            ""


tablerow : Member -> Html msg
tablerow member =
    tr []
        [ td [] [ text <| member.trainerName ]
        , td [] [ text <| toString member.level ]
        , td [] [ text <| toPokemon member.nr ]
        , td [] [ text <| toString member.cp ]
        , td [] [ text <| fromNick member.nick ]
        ]


colSm4 : Html msg -> Html msg
colSm4 node =
    div [ class "col-sm-4" ] [ node ]


gymRow : Gym -> Html msg
gymRow gym =
    div [ class "row" ]
        [ div [ class "col-md-5" ]
            [ h2 [] [ text <| gym.name ++ " ", small [] [ text <| toString gym.team ] ]
            , p [ class "lead" ]
                [ text <| "Level " ++ toString gym.level ++ " "
                , prestigeRatio gym
                ]
            , p [] [ fromFreeSpots gym.freeSpots ]
            ]
        , div [ class "col-md-7" ] [ table gym ]
        ]


prestigeRatio : Gym -> Html msg
prestigeRatio gym =
    let
        p =
            toString gym.prestige
    in
        case gym.nextLevel of
            Just n ->
                let
                    s =
                        toString n
                in
                    strong [] [ text <| p ++ "/" ++ s ]

            Nothing ->
                strong [] [ text p ]


fromFreeSpots : Int -> Html msg
fromFreeSpots n =
    let
        free =
            toString n
    in
        case n of
            0 ->
                text "There are no free slots."

            1 ->
                strong [] [ text "There is 1 slot free!" ]

            _ ->
                strong [] [ text <| "There are " ++ free ++ " sots free!" ]
