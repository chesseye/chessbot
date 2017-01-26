open Types_bot

let wcs_user = ref None
let set_wcs_user s =
  wcs_user := Some s

let wcs_password = ref None
let set_wcs_passwd s =
  wcs_password := Some s

let wcs_workspace_square_id = ref None
let set_wcs_workspace_square_id s =
  wcs_workspace_square_id := Some s

let wcs_workspace_castling_id = ref None
let set_wcs_workspace_castling_id s =
  wcs_workspace_castling_id := Some s

let wcs_workspace_turn_id = ref None
let set_wcs_workspace_turn_id s =
  wcs_workspace_turn_id := Some s

let wcs_workspace_intent_dispatch_id = ref None
let set_wcs_workspace_intent_dispatch_id s =
  wcs_workspace_intent_dispatch_id := Some s

let wcs_workspace_piece_id = ref None
let set_wcs_workspace_piece_id s =
  wcs_workspace_piece_id := Some s

let wcs_workspace_undo_id = ref None
let set_wcs_workspace_undo_id s =
  wcs_workspace_undo_id := Some s

let options =
  [ ("-wcs-user", Arg.String set_wcs_user,
     "username Set the Watson Conversation Service user name");
    ("-wcs-passwd", Arg.String set_wcs_passwd,
     "password Set the Watson Conversation Service password");
    ("-wcs-workspace-square", Arg.String set_wcs_workspace_square_id,
     "workspace Set the Watson Conversation Service workspace id for square questions");
    ("-wcs-workspace-castling", Arg.String set_wcs_workspace_castling_id,
     "workspace Set the Watson Conversation Service workspace id for castling questions");
    ("-wcs-workspace-turn", Arg.String set_wcs_workspace_turn_id,
     "workspace Set the Watson Conversation Service workspace id for turn questions");
    ("-wcs-workspace-intent_dispatch", Arg.String set_wcs_workspace_intent_dispatch_id,
     "workspace Set the Watson Conversation Service workspace id for intent dispatch questions");
    ("-wcs-workspace-piece", Arg.String set_wcs_workspace_piece_id,
     "workspace Set the Watson Conversation Service workspace id for piece questions");
    ("-wcs-workspace-undo", Arg.String set_wcs_workspace_undo_id,
     "workspace Set the Watson Conversation Service workspace id for undo questions");
  ]

(* Must be called after Arg.parse. *)
let get () =
  begin match (!wcs_user, !wcs_password,
               !wcs_workspace_square_id,
               !wcs_workspace_castling_id,
               !wcs_workspace_turn_id,
               !wcs_workspace_intent_dispatch_id,
               !wcs_workspace_undo_id,
               !wcs_workspace_piece_id) with
  | Some wcs_user, Some wcs_password,
    Some wcs_workspace_square_id,
    Some wcs_workspace_castling_id,
    Some wcs_workspace_turn_id,
    Some wcs_workspace_intent_dispatch_id,
    Some wcs_workspace_undo_id,
    Some wcs_workspace_piece_id ->
      {  wcs_user = wcs_user;
         wcs_password = wcs_password;
         wcs_workspace_square_id = wcs_workspace_square_id;
         wcs_workspace_castling_id = wcs_workspace_castling_id;
         wcs_workspace_turn_id = wcs_workspace_turn_id;
         wcs_workspace_intent_dispatch_id = wcs_workspace_intent_dispatch_id;
         wcs_workspace_piece_id = wcs_workspace_piece_id;
         wcs_workspace_undo_id = wcs_workspace_undo_id; }
  | _ ->
      Arg.usage options "Need all workspace identifiers.";
      exit 1
  end
