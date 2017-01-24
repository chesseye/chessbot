type json = Yojson.Basic.json
let write_json = Yojson.Basic.write_json
let read_json = Yojson.Basic.read_json

type wcs_config = {
    wcs_user : string;
    wcs_password : string;
    wcs_workspace_square_id : string;
    wcs_workspace_castling_id : string;
    wcs_workspace_turn_id : string;
    wcs_workspace_intent_dispatch_id : string;
  }

type intent_dispatch =
  | Intent_setup_position
  | Intent_undo
  | Intent_resign
