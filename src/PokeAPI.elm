module PokeAPI exposing (fetchPokemon)

import Task exposing (..)
import Json.Decode exposing (string, at, Decoder)
import Http exposing (get, Error(..))


apiUrl : String
apiUrl =
    "http://pokeapi.co/api/v2/pokemon/"


respondeDecoder : Decoder String
respondeDecoder =
    at [ "form", "name" ] string


fetchPokemon : Int -> Task Error String
fetchPokemon n =
    get respondeDecoder <| apiUrl ++ toString n
