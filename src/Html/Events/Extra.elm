module Html.Events.Extra

import Html
import Json.Decode as Json exposing (..)

on : String -> Json.Decoder a -> (a -> Signal.Message) -> Attribute
on eventName decoder toMessage =
  Native.Test.on eventName defaultOptions decoder toMessage
