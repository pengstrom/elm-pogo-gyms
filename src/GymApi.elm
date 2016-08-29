module GymApi exposing (fetchGyms, Gyms, Gym, Member, Members, Team(..), toPokemon)

import Task exposing (..)
import Json.Decode as J exposing (..)
import Http exposing (..)
import List exposing (..)
import Date exposing (Date, fromTime, fromString)
import Time exposing (millisecond)
import Capitalize
import String


apiUrl : String
apiUrl =
    "https://gym.rationell.nu/gyms"


fetchGyms : Task Http.Error Gyms
fetchGyms =
    Http.get decodeGyms apiUrl


decodeGyms : Decoder Gyms
decodeGyms =
    object2 gyms'
        ("gyms" := list gym)
        ("modified" := J.string)


gyms' : List Gym -> String -> Gyms
gyms' g m =
    case (fromString m) of
        Ok date ->
            Gyms g date

        Err _ ->
            Gyms g <| fromTime <| 0 * millisecond


gym : Decoder Gym
gym =
    object5 gym'
        ("name" := J.string)
        ("team" := J.string)
        ("stringId" := J.string)
        ("prestige" := int)
        ("members" := list member)


gym' : String -> String -> String -> Int -> Members -> Gym
gym' name team id prestige members =
    let
        level =
            toLevel prestige

        nextLevel =
            toNextLevel prestige

        free =
            toFree level members

        team' =
            toTeam team

        imageUrl =
            ""
    in
        { name = name
        , id = id
        , prestige = prestige
        , level = level
        , nextLevel = nextLevel
        , freeSpots = free
        , team = team'
        , imageUrl = imageUrl
        , members = members
        }


toLevel : Int -> Int
toLevel prestige =
    (+) 1 <| length <| filter (\x -> prestige >= x) prestiges


toNextLevel : Int -> Maybe Int
toNextLevel prestige =
    head <| filter (\x -> prestige < x) prestiges


prestiges : List Int
prestiges =
    [ 2000
    , 4000
    , 8000
    , 12000
    , 16000
    , 20000
    , 30000
    , 40000
    , 50000
    ]


toTeam : String -> Team
toTeam s =
    case s of
        "Mystic" ->
            Mystic

        "Valor" ->
            Valor

        "Instinct" ->
            Instinct

        _ ->
            Neutral


toFree : Int -> Members -> Int
toFree l m =
    l - (length m)


member : Decoder Member
member =
    let
        member' n l cp nick nr =
            { trainerName = n
            , level = l
            , cp = cp
            , nick = nick
            , nr = nr
            }
    in
        object5 member'
            ("playerName" := J.string)
            ("playerLevel" := int)
            ("pokemonCP" := int)
            ("pokemonNick" := maybe J.string)
            ("pokemonNr" := int)


type alias Gyms =
    { gyms : List Gym
    , modified : Date
    }


type alias Gym =
    { name : String
    , id : String
    , prestige : Int
    , level : Int
    , nextLevel : Maybe Int
    , freeSpots : Int
    , team : Team
    , imageUrl : String
    , members : Members
    }


type alias Members =
    List Member


type alias Member =
    { trainerName : String
    , level : Int
    , cp : Int
    , nick : Maybe String
    , nr : Int
    }


type Team
    = Neutral
    | Mystic
    | Valor
    | Instinct


toPokemon : Int -> String
toPokemon n =
    Capitalize.toCapital <| String.toLower <| pokemonMap n


pokemonMap : Int -> String
pokemonMap n =
    case n of
        0 ->
            "MISSINGNO"

        1 ->
            "BULBASAUR"

        2 ->
            "IVYSAUR"

        3 ->
            "VENUSAUR"

        4 ->
            "CHARMANDER"

        5 ->
            "CHARMELEON"

        6 ->
            "CHARIZARD"

        7 ->
            "SQUIRTLE"

        8 ->
            "WARTORTLE"

        9 ->
            "BLASTOISE"

        10 ->
            "CATERPIE"

        11 ->
            "METAPOD"

        12 ->
            "BUTTERFREE"

        13 ->
            "WEEDLE"

        14 ->
            "KAKUNA"

        15 ->
            "BEEDRILL"

        16 ->
            "PIDGEY"

        17 ->
            "PIDGEOTTO"

        18 ->
            "PIDGEOT"

        19 ->
            "RATTATA"

        20 ->
            "RATICATE"

        21 ->
            "SPEAROW"

        22 ->
            "FEAROW"

        23 ->
            "EKANS"

        24 ->
            "ARBOK"

        25 ->
            "PIKACHU"

        26 ->
            "RAICHU"

        27 ->
            "SANDSHREW"

        28 ->
            "SANDSLASH"

        29 ->
            "NIDORAN_FEMALE"

        30 ->
            "NIDORINA"

        31 ->
            "NIDOQUEEN"

        32 ->
            "NIDORAN_MALE"

        33 ->
            "NIDORINO"

        34 ->
            "NIDOKING"

        35 ->
            "CLEFAIRY"

        36 ->
            "CLEFABLE"

        37 ->
            "VULPIX"

        38 ->
            "NINETALES"

        39 ->
            "JIGGLYPUFF"

        40 ->
            "WIGGLYTUFF"

        41 ->
            "ZUBAT"

        42 ->
            "GOLBAT"

        43 ->
            "ODDISH"

        44 ->
            "GLOOM"

        45 ->
            "VILEPLUME"

        46 ->
            "PARAS"

        47 ->
            "PARASECT"

        48 ->
            "VENONAT"

        49 ->
            "VENOMOTH"

        50 ->
            "DIGLETT"

        51 ->
            "DUGTRIO"

        52 ->
            "MEOWTH"

        53 ->
            "PERSIAN"

        54 ->
            "PSYDUCK"

        55 ->
            "GOLDUCK"

        56 ->
            "MANKEY"

        57 ->
            "PRIMEAPE"

        58 ->
            "GROWLITHE"

        59 ->
            "ARCANINE"

        60 ->
            "POLIWAG"

        61 ->
            "POLIWHIRL"

        62 ->
            "POLIWRATH"

        63 ->
            "ABRA"

        64 ->
            "KADABRA"

        65 ->
            "ALAKAZAM"

        66 ->
            "MACHOP"

        67 ->
            "MACHOKE"

        68 ->
            "MACHAMP"

        69 ->
            "BELLSPROUT"

        70 ->
            "WEEPINBELL"

        71 ->
            "VICTREEBEL"

        72 ->
            "TENTACOOL"

        73 ->
            "TENTACRUEL"

        74 ->
            "GEODUDE"

        75 ->
            "GRAVELER"

        76 ->
            "GOLEM"

        77 ->
            "PONYTA"

        78 ->
            "RAPIDASH"

        79 ->
            "SLOWPOKE"

        80 ->
            "SLOWBRO"

        81 ->
            "MAGNEMITE"

        82 ->
            "MAGNETON"

        83 ->
            "FARFETCHD"

        84 ->
            "DODUO"

        85 ->
            "DODRIO"

        86 ->
            "SEEL"

        87 ->
            "DEWGONG"

        88 ->
            "GRIMER"

        89 ->
            "MUK"

        90 ->
            "SHELLDER"

        91 ->
            "CLOYSTER"

        92 ->
            "GASTLY"

        93 ->
            "HAUNTER"

        94 ->
            "GENGAR"

        95 ->
            "ONIX"

        96 ->
            "DROWZEE"

        97 ->
            "HYPNO"

        98 ->
            "KRABBY"

        99 ->
            "KINGLER"

        100 ->
            "VOLTORB"

        101 ->
            "ELECTRODE"

        102 ->
            "EXEGGCUTE"

        103 ->
            "EXEGGUTOR"

        104 ->
            "CUBONE"

        105 ->
            "MAROWAK"

        106 ->
            "HITMONLEE"

        107 ->
            "HITMONCHAN"

        108 ->
            "LICKITUNG"

        109 ->
            "KOFFING"

        110 ->
            "WEEZING"

        111 ->
            "RHYHORN"

        112 ->
            "RHYDON"

        113 ->
            "CHANSEY"

        114 ->
            "TANGELA"

        115 ->
            "KANGASKHAN"

        116 ->
            "HORSEA"

        117 ->
            "SEADRA"

        118 ->
            "GOLDEEN"

        119 ->
            "SEAKING"

        120 ->
            "STARYU"

        121 ->
            "STARMIE"

        122 ->
            "MR_MIME"

        123 ->
            "SCYTHER"

        124 ->
            "JYNX"

        125 ->
            "ELECTABUZZ"

        126 ->
            "MAGMAR"

        127 ->
            "PINSIR"

        128 ->
            "TAUROS"

        129 ->
            "MAGIKARP"

        130 ->
            "GYARADOS"

        131 ->
            "LAPRAS"

        132 ->
            "DITTO"

        133 ->
            "EEVEE"

        134 ->
            "VAPOREON"

        135 ->
            "JOLTEON"

        136 ->
            "FLAREON"

        137 ->
            "PORYGON"

        138 ->
            "OMANYTE"

        139 ->
            "OMASTAR"

        140 ->
            "KABUTO"

        141 ->
            "KABUTOPS"

        142 ->
            "AERODACTYL"

        143 ->
            "SNORLAX"

        144 ->
            "ARTICUNO"

        145 ->
            "ZAPDOS"

        146 ->
            "MOLTRES"

        147 ->
            "DRATINI"

        148 ->
            "DRAGONAIR"

        149 ->
            "DRAGONITE"

        150 ->
            "MEWTWO"

        151 ->
            "MEW"

        _ ->
            "Missingno"
