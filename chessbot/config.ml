open Types

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

let args =
  Arg.align
    [ ("-wcs-user", Arg.String set_wcs_user,
       "username Set the Watson Conversation Service user name");
      ("-wcs-passwd", Arg.String set_wcs_passwd,
       "password Set the Watson Conversation Service password");
      ("-wcs-workspace-square", Arg.String set_wcs_workspace_square_id,
       "workspace Set the Watson Conversation Service workspace id for square questions");
      ("-wcs-workspace-castling", Arg.String set_wcs_workspace_castling_id,
       "workspace Set the Watson Conversation Service workspace id for castling questions");
    ]

let usage = Sys.argv.(0)^" options"

let anon_args f = ()

let init () =
  Arg.parse args anon_args usage;
  begin match (!wcs_user, !wcs_password,
               !wcs_workspace_square_id, !wcs_workspace_castling_id) with
  | Some wcs_user, Some wcs_password,
    Some wcs_workspace_square_id, Some wcs_workspace_castling_id ->
      {  wcs_user = wcs_user;
         wcs_password = wcs_password;
         wcs_workspace_square_id = wcs_workspace_square_id;
         wcs_workspace_castling_id = wcs_workspace_castling_id; }
  | _ ->
      Format.eprintf "Need all options@.";
      exit 1
  end
