module Firestore.Params exposing
    ( List, list
    , Patch, patch
    )

{-| A type to define operation parameters


# List operation

@docs List, list


# Patch operation

@docs Patch, patch

-}

import Firestore.Encode as FSEncode


type List
    = List


list : List
list =
    List


type Patch
    = Patch
        { updates : List ( String, FSEncode.Field )
        , deletes : List String
        }


patch : Patch
patch =
    Patch
        { updates = []
        , delets = []
        }
