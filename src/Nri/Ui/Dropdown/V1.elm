module Nri.Ui.Dropdown.V1
    exposing
        ( CssClasses
        , ViewOptionEntry
        , styles
        , view
        , viewWithoutLabel
        )

{-|

@docs CssClasses
@docs ViewOptionEntry
@docs styles
@docs view
@docs viewWithoutLabel

-}

import Accessibility.Style exposing (invisible)
import Css
import Css.Foreign
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode
import Nri.Ui.Colors.V1
import Nri.Ui.Styles.V1
import Nri.Ui.Util exposing (dashify)
import String


{-| This dropdown has atypical select tag behavior.

This dropdown, when closed, will display some default text, no matter
what is actually selected.

When the dropdown is opened, the first option will display that default text,
be selected, and disabled. The option the user has actually chosen's displayText
won't show up at all.

-}
type alias ViewOptionEntry a =
    { isSelected : Bool
    , val : a
    , displayText : String
    }


{-| -}
view : String -> List (ViewOptionEntry a) -> (a -> msg) -> Html msg
view defaultDisplayText optionEntries onSelect =
    viewWithLabelMarkup True defaultDisplayText optionEntries onSelect


{-| -}
viewWithoutLabel : String -> List (ViewOptionEntry a) -> (a -> msg) -> Html msg
viewWithoutLabel defaultDisplayText optionEntries onSelect =
    viewWithLabelMarkup False defaultDisplayText optionEntries onSelect


viewWithLabelMarkup : Bool -> String -> List (ViewOptionEntry a) -> (a -> msg) -> Html msg
viewWithLabelMarkup displayLabel defaultDisplayText optionEntries onSelect =
    let
        defaultOption =
            option
                [ selected True
                , disabled True
                ]
                [ text defaultDisplayText ]

        options =
            List.map (viewOption defaultDisplayText) optionEntries

        identifier =
            dashify (String.toLower defaultDisplayText)

        changeHandlers : List (Attribute msg)
        changeHandlers =
            case optionEntries of
                [] ->
                    -- If we have no entries, there's no point in having
                    -- a change handler; it could never fire anyway.
                    []

                { val } :: _ ->
                    let
                        -- When we get a `String` from the `onChange` event,
                        -- look up the `msg` that goes with it.
                        msgForValue : String -> msg
                        msgForValue valString =
                            case Dict.get valString msgsByVal of
                                Just msg ->
                                    msg

                                Nothing ->
                                    -- If it's somehow not in the Dict
                                    -- (which should never happen),
                                    -- fall back on a known `msg` value:
                                    -- the first one in the list.
                                    onSelect val

                        msgsByVal : Dict.Dict String msg
                        msgsByVal =
                            optionEntries
                                |> List.map (\{ val } -> ( toString val, onSelect val ))
                                |> Dict.fromList
                    in
                    [ on "change" (Json.Decode.map msgForValue targetValue) ]
    in
    span []
        [ label
            (if displayLabel then
                [ for identifier ]
             else
                [ for identifier, invisible ]
            )
            [ text defaultDisplayText ]
        , select
            ([ styles.class [ Dropdown ]
             , id identifier
             , {-
                  NOTE: form controls are also being styled on a global CSS that
                  sets a margin.

                  It would be better to remove the margin from the component and
                  decide whether we need it or not in each use case.

                  It will be really hard to track down and review all of those,
                  so we reset the margin here as a workaround.
               -}
               style [ ( "margin", "0" ) ]
             ]
                ++ changeHandlers
            )
            (defaultOption :: options)
        ]


viewOption : String -> ViewOptionEntry a -> Html msg
viewOption defaultDisplayText { isSelected, val, displayText } =
    if isSelected then
        option
            [ value <| toString val
            , selected isSelected
            , style [ ( "display", "none" ) ]
            ]
            [ text defaultDisplayText ]
    else
        option
            [ value <| toString val
            , selected isSelected
            ]
            [ text displayText ]


{-| -}
type CssClasses
    = Dropdown


{-| -}
styles : Nri.Ui.Styles.V1.Styles Never CssClasses c
styles =
    Nri.Ui.Styles.V1.styles "Nri-Ui-Dropdown-V1-"
        [ Css.Foreign.class Dropdown
            [ Css.backgroundColor Nri.Ui.Colors.V1.white
            , Css.border3 (Css.px 1) Css.solid Nri.Ui.Colors.V1.gray75
            , Css.borderRadius (Css.px 8)
            , Css.color Nri.Ui.Colors.V1.gray20
            , Css.cursor Css.pointer
            , Css.fontSize (Css.px 15)
            , Css.height (Css.px 45)
            ]
        ]
