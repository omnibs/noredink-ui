module ModuleExample
    exposing
        ( Category(..)
        , ModuleExample
        , ModuleMessages
        , categoryForDisplay
        , categoryFromString
        , styles
        , view
        )

import Css exposing (..)
import Css.Namespace
import Html exposing (Html, img)
import Html.Attributes
import Html.CssHelpers
import Nri.Colors exposing (..)


type alias ModuleExample msg =
    { filename : String
    , content : List (Html msg)
    , category : Category
    }


{-| -}
type alias ModuleMessages moduleMsg parentMsg =
    { noOp : parentMsg
    , showItWorked : String -> parentMsg
    , wrapper : moduleMsg -> parentMsg
    }


type Category
    = Layout
    | Inputs
    | Buttons
    | Icons
    | Behaviors
    | Messaging
    | Modals
    | Writing
    | NotesToDeveloper
    | Colors
    | Text
    | DynamicSymbols
    | Pages
    | QuestionTypes


{-| Used for route changes
-}
categoryFromString : String -> Result String Category
categoryFromString string =
    case string of
        "Layout" ->
            Ok Layout

        "Inputs" ->
            Ok Inputs

        "Behaviors" ->
            Ok Behaviors

        "Buttons" ->
            Ok Buttons

        "Icons" ->
            Ok Icons

        "Messaging" ->
            Ok Messaging

        "Modals" ->
            Ok Modals

        "Writing" ->
            Ok Writing

        "NotesToDeveloper" ->
            Ok NotesToDeveloper

        "Colors" ->
            Ok Colors

        "Text" ->
            Ok Text

        "DynamicSymbols" ->
            Ok DynamicSymbols

        "Pages" ->
            Ok Pages

        "QuestionTypes" ->
            Ok QuestionTypes

        _ ->
            Err "Invalid String"


categoryForDisplay : Category -> String
categoryForDisplay category =
    case category of
        Layout ->
            "Layout"

        Inputs ->
            "Inputs"

        Behaviors ->
            "Behaviors"

        Buttons ->
            "Buttons"

        Icons ->
            "Icons"

        Messaging ->
            "Messaging"

        Modals ->
            "Modals"

        Writing ->
            "Writing"

        NotesToDeveloper ->
            "NotesToDeveloper"

        Colors ->
            "Colors"

        Text ->
            "Text"

        DynamicSymbols ->
            "Dynamic Symbols"

        Pages ->
            "Pages"

        QuestionTypes ->
            "Question types / Quiz UI"


view : Bool -> ModuleExample msg -> Html msg
view showFocusLink { filename, content } =
    Html.div [ class [ Module ] ]
        [ Html.div [ class [ ModuleHeader ] ]
            [ Html.h2
                [ class [ ModuleName ] ]
                [ Html.text filename
                , Html.text " "
                , if showFocusLink then
                    Html.a
                        [ Html.Attributes.href <| "#doodad/" ++ filename ]
                        [ Html.text "(see only this)" ]
                  else
                    Html.text ""
                ]
            ]
        , Html.div [ class [ ModuleBody ] ] content
        ]


type Classes
    = Module
    | ModuleHeader
    | ModuleName
    | ModuleImporting
    | ModuleBody


viewStyles : List Css.Snippet
viewStyles =
    [ Css.class ModuleHeader
        [ display block
        , backgroundColor glacier
        , padding (px 20)
        , marginTop (px 20)
        ]
    , Css.class ModuleImporting
        [ display block
        , padding (px 20)
        , margin2 (px 20) zero
        ]
    , Css.class ModuleBody
        [ padding2 (px 20) zero ]
    , Css.class ModuleName
        [ color gray20
        , fontFamilies [ qt "Source Code Pro", "Consolas", "Courier", "monospace" ]
        , fontSize (px 20)
        ]
    ]


styles : Css.Stylesheet
styles =
    List.concat
        [ viewStyles
        ]
        |> (Css.stylesheet << Css.Namespace.namespace "Page-StyleGuide-ModuleExample-")


{ id, class, classList } =
    Html.CssHelpers.withNamespace "Page-StyleGuide-ModuleExample-"
