module NriModules exposing (ModuleStates, Msg, init, nriThemedModules, styles, subscriptions, update)

import Assets exposing (assets)
import DEPRECATED.Css.File exposing (Stylesheet, compile, stylesheet)
import Examples.Button
import Examples.Checkbox
import Examples.Colors
import Examples.DisclosureIndicator
import Examples.Dropdown
import Examples.Fonts
import Examples.Icon
import Examples.Page
import Examples.SegmentedControl
import Examples.Select
import Examples.Table
import Examples.Text
import Examples.Text.Writing
import Examples.TextArea as TextAreaExample
import Examples.TextInput as TextInputExample
import Html exposing (Html, img)
import Html.Attributes exposing (..)
import ModuleExample exposing (Category(..), ModuleExample)
import Navigation
import Nri.Ui.Button.V2 as Button
import Nri.Ui.Dropdown.V1
import Nri.Ui.Icon.V2
import Nri.Ui.SegmentedControl.V5
import Nri.Ui.Text.V2 as Text
import Nri.Ui.TextArea.V2 as TextArea
import String.Extra


type alias ModuleStates =
    { buttonExampleState : Examples.Button.State
    , checkboxExampleState : Examples.Checkbox.State
    , dropdownState : Examples.Dropdown.State Examples.Dropdown.Value
    , segmentedControlState : Examples.SegmentedControl.State
    , selectState : Examples.Select.State Examples.Select.Value
    , tableExampleState : Examples.Table.State
    , textAreaExampleState : TextAreaExample.State
    , textInputExampleState : TextInputExample.State
    , disclosureIndicatorExampleState : Examples.DisclosureIndicator.State
    }


init : ModuleStates
init =
    { buttonExampleState = Examples.Button.init assets
    , checkboxExampleState = Examples.Checkbox.init
    , dropdownState = Examples.Dropdown.init
    , segmentedControlState = Examples.SegmentedControl.init
    , selectState = Examples.Select.init
    , tableExampleState = Examples.Table.init
    , textAreaExampleState = TextAreaExample.init
    , textInputExampleState = TextInputExample.init
    , disclosureIndicatorExampleState = Examples.DisclosureIndicator.init
    }


type Msg
    = ButtonExampleMsg Examples.Button.Msg
    | CheckboxExampleMsg Examples.Checkbox.Msg
    | DropdownMsg Examples.Dropdown.Msg
    | SegmentedControlMsg Examples.SegmentedControl.Msg
    | SelectMsg Examples.Select.Msg
    | ShowItWorked String String
    | TableExampleMsg Examples.Table.Msg
    | TextAreaExampleMsg TextAreaExample.Msg
    | TextInputExampleMsg TextInputExample.Msg
    | DisclosureIndicatorExampleMsg Examples.DisclosureIndicator.Msg
    | NoOp


update : Msg -> ModuleStates -> ( ModuleStates, Cmd Msg )
update msg moduleStates =
    case msg of
        ButtonExampleMsg msg ->
            let
                ( buttonExampleState, cmd ) =
                    Examples.Button.update msg moduleStates.buttonExampleState
            in
            ( { moduleStates | buttonExampleState = buttonExampleState }
            , Cmd.map ButtonExampleMsg cmd
            )

        CheckboxExampleMsg msg ->
            let
                ( checkboxExampleState, cmd ) =
                    Examples.Checkbox.update msg moduleStates.checkboxExampleState
            in
            ( { moduleStates | checkboxExampleState = checkboxExampleState }, Cmd.map CheckboxExampleMsg cmd )

        DropdownMsg msg ->
            let
                ( dropdownState, cmd ) =
                    Examples.Dropdown.update msg moduleStates.dropdownState
            in
            ( { moduleStates | dropdownState = dropdownState }
            , Cmd.map DropdownMsg cmd
            )

        SegmentedControlMsg msg ->
            let
                ( segmentedControlState, cmd ) =
                    Examples.SegmentedControl.update msg moduleStates.segmentedControlState
            in
            ( { moduleStates | segmentedControlState = segmentedControlState }
            , Cmd.map SegmentedControlMsg cmd
            )

        SelectMsg msg ->
            let
                ( selectState, cmd ) =
                    Examples.Select.update msg moduleStates.selectState
            in
            ( { moduleStates | selectState = selectState }
            , Cmd.map SelectMsg cmd
            )

        ShowItWorked group message ->
            let
                _ =
                    Debug.log group message
            in
            ( moduleStates, Cmd.none )

        TableExampleMsg msg ->
            let
                ( tableExampleState, cmd ) =
                    Examples.Table.update msg moduleStates.tableExampleState
            in
            ( { moduleStates | tableExampleState = tableExampleState }
            , Cmd.map TableExampleMsg cmd
            )

        TextAreaExampleMsg msg ->
            let
                ( textAreaExampleState, cmd ) =
                    TextAreaExample.update msg moduleStates.textAreaExampleState
            in
            ( { moduleStates | textAreaExampleState = textAreaExampleState }
            , Cmd.map TextAreaExampleMsg cmd
            )

        TextInputExampleMsg msg ->
            let
                ( textInputExampleState, cmd ) =
                    TextInputExample.update msg moduleStates.textInputExampleState
            in
            ( { moduleStates | textInputExampleState = textInputExampleState }
            , Cmd.map TextInputExampleMsg cmd
            )

        DisclosureIndicatorExampleMsg msg ->
            let
                ( disclosureIndicatorExampleState, cmd ) =
                    Examples.DisclosureIndicator.update msg moduleStates.disclosureIndicatorExampleState
            in
            ( { moduleStates | disclosureIndicatorExampleState = disclosureIndicatorExampleState }
            , Cmd.map DisclosureIndicatorExampleMsg cmd
            )

        NoOp ->
            ( moduleStates, Cmd.none )


subscriptions : ModuleStates -> Sub Msg
subscriptions moduleStates =
    Sub.batch
        []


{-| A container with a visually-apparent size for demonstrating how style guide components
fill their parents.
-}
container : Int -> List (Html msg) -> Html msg
container width children =
    Html.div
        [ Html.Attributes.class "demo-container"
        , style [ ( "width", toString width ++ "px" ) ]
        ]
        children


nriThemedModules : ModuleStates -> List (ModuleExample Msg)
nriThemedModules model =
    [ Examples.Button.example assets (exampleMessages ButtonExampleMsg) model.buttonExampleState
    , Examples.Checkbox.example CheckboxExampleMsg model.checkboxExampleState
    , Examples.Dropdown.example DropdownMsg model.dropdownState
    , Examples.Icon.example
    , Examples.Page.example NoOp
    , Examples.SegmentedControl.example SegmentedControlMsg model.segmentedControlState
    , Examples.Select.example SelectMsg model.selectState
    , Examples.Text.example
    , Examples.Text.Writing.example
    , Examples.Fonts.example
    , Examples.Table.example TableExampleMsg model.tableExampleState
    , TextAreaExample.example TextAreaExampleMsg model.textAreaExampleState
    , TextInputExample.example TextInputExampleMsg model.textInputExampleState
    , Examples.DisclosureIndicator.example DisclosureIndicatorExampleMsg model.disclosureIndicatorExampleState
    , Examples.Colors.example
    ]


exampleMessages : (msg -> Msg) -> String -> ModuleExample.ModuleMessages msg Msg
exampleMessages exampleMessageWrapper exampleName =
    { noOp = NoOp
    , showItWorked = ShowItWorked exampleName
    , wrapper = exampleMessageWrapper
    }


route : Navigation.Location -> Maybe String
route location =
    location.hash
        |> String.dropLeft 1
        |> String.Extra.nonEmpty


styles : List Stylesheet
styles =
    List.concat
        [ -- NOTE: these will go away as the modules' styles are integrated with Nri.Css.Site.elm
          [ ModuleExample.styles
          ]
        , (Examples.Page.styles |> .css) ()
        , (Examples.SegmentedControl.styles |> .css) ()
        , (Button.styles |> .css) assets
        , (Nri.Ui.Dropdown.V1.styles |> .css) ()
        , (Nri.Ui.Icon.V2.styles |> .css) ()
        , (Nri.Ui.SegmentedControl.V5.styles |> .css) ()
        , (TextArea.styles |> .css) assets
        ]
