open Wcs_message_t
open Context_types_t
open Util_bot
open Types
open Types_bot

let get_value wcs_config
    (workspace_id: string)
    (ctx_init: Yojson.Basic.json)
    (value_of_context: message_response -> 'a option) : 'a =
  let rec loop_ ctx input =
    let req_msg =
      { req_input = { cin_text = input };
        req_alternate_intents = false;
        req_context = Some ctx;
        req_entities = None;
        req_intents = None;
        req_output = None; }
    in
    let resp =
      Rest.message wcs_config workspace_id req_msg
    in
    (* Format.printf "Chessbot: %s@." *)
    (*   (Wcs_message_j.string_of_c_output resp.rsp_output); *)
    List.iter
      (fun txt -> Format.printf "Chessbot: %s@." txt)
      resp.rsp_output.cout_text;
    begin match value_of_context resp with
    | Some v -> v
    | None ->
        let txt = input_line stdin in
        loop_ resp.rsp_context txt
    end
  in
  loop_ ctx_init ""


let get_figure wcs_config (color: color) ((i, j): int * int) : piece_type =
  let ctx =
    `Assoc [ ("square", `String (string_of_square (i, j)));
             ("color", `String (string_of_color color)); ]
  in
  let figure_of_resp resp =
    begin match context_of_json resp.rsp_context with
    | Some { ctx_figure = Some figure } ->
       Some (figure_of_string figure)
    | _ -> None
    end
  in
  get_value wcs_config wcs_config.wcs_workspace_square_id ctx figure_of_resp


let get_casling_rights wcs_config (color: color) : (bool * bool) =
  let ctx =
    `Assoc [ ("color", `String (string_of_color color)); ]
  in
  let castling_of_resp resp =
    begin match context_of_json resp.rsp_context with
    | Some { ctx_castling_rights = Some [b1; b2] } ->
        Some (b1, b2)
    | _ -> None
    end
  in
  get_value wcs_config wcs_config.wcs_workspace_castling_id
    ctx castling_of_resp

let get_turn wcs_config : color =
  let ctx = `Null in
  let turn_of_resp resp =
    begin match context_of_json resp.rsp_context with
    | Some { ctx_color = Some c } ->
        Some (color_of_string c)
    | _ -> None
    end
  in
  get_value wcs_config wcs_config.wcs_workspace_turn_id ctx turn_of_resp


let position_of_mask wcs_config (m : mask) =
  let board =
    let board = Array.make_matrix 8 8 Empty in
    for i = 0 to 7 do
      for j = 0 to 7 do
        begin match m.(i).(j) with
        | Some c ->
            let f = get_figure wcs_config c (i, j) in
            board.(i).(j) <- Piece (f, c)
        | None -> ()
        end
      done
    done;
    board
  in
  let cas_w =
    begin match get_king board White with
    | Some ij when ij = (4, 0) -> get_casling_rights wcs_config White
    | _ -> (false, false)
    end
  in
  let cas_b =
    begin match get_king board Black with
    | Some ij when ij = (4, 7) -> get_casling_rights wcs_config Black
    | _ -> (false, false)
    end
  in
  let turn =
    get_turn wcs_config
  in
  { ar = board;
    turn = turn;
    cas_w = cas_w;
    cas_b = cas_b;
    en_passant = None;
    prev = None;
    irr_change = 0;
    king_w =
      begin match get_king board White with
      | None -> (0,0)
      | Some p -> p
      end;
    king_b =
      begin match get_king board Black with
      | None -> (7,7)
      | Some p -> p
      end;
    number = 42;
    eval = 0; }

