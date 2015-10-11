module Html.Events.Extra 
  (
   DragOption, DragImageOption,

   onDrag, onDrop, onMouseUp, onMouseDown
  ) where

{-| Additional event handlers for html.

# test
@docs DragOption
@docs DragImageOption
@docs onDrag
@docs onDrop
@docs onMouseUp
@docs onMouseDown

-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import Native.Extra

on : String -> Json.Decoder a -> (a -> Signal.Message) -> Attribute
on eventName decoder toMessage =
  Native.Extra.on eventName defaultOptions decoder toMessage


onWithOption : String -> Options -> Json.Decoder a -> (a -> Signal.Message) -> Attribute
onWithOption eventName options decoder toMessage =
  Native.Extra.on eventName options decoder toMessage

type alias Options =
    { stopPropagation : Bool
    , preventDefault : Bool
    , drag : Bool
    , dragOption : DragOption
    }

{-|
test
-}
type alias DragOption =
  { image : DragImageOption
  }

{-|
test
-}
type alias DragImageOption = 
  { src : String
  , x : Int
  , y : Int
  }

defaultOptions : Options
defaultOptions =
    { stopPropagation = False
    , preventDefault = False
    , drag = False
    , dragOption = {image = { src = "", x = 0 ,y =0}}
    }

messageOn : String -> Signal.Address a -> a -> Attribute
messageOn name addr msg=
  on name value (\_ -> Signal.message addr msg)

{-|
test
-}
onDrag : Signal.Address a -> a -> DragOption -> Attribute
onDrag addr msg option =
  let options =  
    { stopPropagation = False
    , preventDefault = False
    , drag = True
    , dragOption = option
    }
  in onWithOption "dragstart" options value (\_ -> Signal.message addr msg)

{-|
test
-}
onDrop : Signal.Address a -> a -> Attribute
onDrop =
  messageOn "drop"

buttonCode : Json.Decoder Int
buttonCode =
  ("button" := int)

onButton : String -> Signal.Address a -> (Int -> a) -> Attribute
onButton name addr handler =
  on name buttonCode (\code -> Signal.message addr (handler code))

{-|
test
-}
onMouseDown : Signal.Address a -> (Int -> a) -> Attribute
onMouseDown =
  onButton "mousedown"

{-|
test
-}
onMouseUp : Signal.Address a -> (Int -> a) -> Attribute
onMouseUp =
  onButton "mouseup"
