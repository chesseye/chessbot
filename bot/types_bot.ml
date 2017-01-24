type json = Yojson.Basic.json

type wcs_config = {
    wcs_user: string;
    wcs_password: string;
    wcs_workspace_square_id: string;
    wcs_workspace_castling_id: string;
    wcs_workspace_turn_id: string;
  }

let write_json = Yojson.Basic.write_json
let read_json = Yojson.Basic.read_json
