module Firestore exposing (Firestore, configure)

import Firestore.ProjectId exposing (ProjectId)


type Firestore
    = Firestore ProjectId


configure : ProjectId -> Firestore
configure =
    Firestore
