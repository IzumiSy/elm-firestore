module Firestore.Types.Reference exposing
    ( Reference, new
    , encode, decode
    )

{-| Reference data type for Firestore

@docs Reference, new

@docs encode, decode

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
type Reference
    = Reference String


{-| -}
new : String -> Reference
new =
    Reference


{-| -}
decode : Decode.Decoder Reference
decode =
    Decode.field "referenceValue" <| Decode.map Reference Decode.string


{-| -}
encode : Reference -> Field.Field
encode (Reference value) =
    Field.field <|
        Encode.object
            [ ( "referenceValue", Encode.string value ) ]
