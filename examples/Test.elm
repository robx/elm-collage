module Main exposing (..)

import Collage exposing (..)
import Collage.Events exposing (onClick)
import Collage.Layout exposing (..)
import Collage.Render exposing (svg)
import Collage.Text exposing (fromString)
import Color exposing (..)
import Html exposing (Html)


-- Model -----------------------------------------------------------------------


type alias Model =
    { active : Bool }


init : Model
init =
    { active = False }



-- Update ----------------------------------------------------------------------


type Msg
    = Switch


update : Msg -> Model -> Model
update msg model =
    case msg of
        Switch ->
            { model | active = not model.active }



-- View ------------------------------------------------------------------------
-- Styles --


border : LineStyle
border =
    solid verythin <| uniform black


debug : Collage msg -> Collage msg
debug collage =
    collage
        |> showOrigin
        |> showEnvelope



-- Text --


txt : Collage Msg
txt =
    rendered <| fromString "Hello collage!"



-- Shapes --


circ : Model -> Collage Msg
circ model =
    circle 50
        |> styled
            ( uniform <|
                if model.active then
                    lightPurple
                else
                    lightBlue
            , border
            )
        |> onClick Switch


rect : Collage msg
rect =
    square 50
        |> styled ( uniform lightOrange, border )


tria : Collage msg
tria =
    triangle 50
        |> styled ( uniform lightGreen, border )



-- Alignments --


alignments : Collage msg
alignments =
    horizontal <|
        List.map (showOrigin << align top) [ rect, tria, rect, rect ]



-- Main ------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    vertical
        [ rect
        , horizontal
            [ stack [ showEnvelope txt, circ model ]
            , vertical
                [ tria
                , tria |> rotate pi
                ]
                |> center
            ]
        ]
        |> debug
        |> svg


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = init, view = view, update = update }
