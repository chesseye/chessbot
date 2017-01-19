open Wcs_message_t
open Context_types_t
open Util
open Types

let get_figure wcs_config (color: color) ((i, j): int * int) : piece_type =
  let rec loop ctx input =
    let req_msg =
      { req_input = { cin_text = input };
        req_alternate_intents = false;
        req_context = Some ctx;
        req_entities = None;
        req_intents = None;
        req_output = None; }
    in
    let resp =
      Rest.message wcs_config wcs_config.wcs_workspace_square_id req_msg
    in
    Format.printf "Chessbot: %s@."
      (Wcs_message_j.string_of_c_output resp.rsp_output);
    begin match context_of_json resp.rsp_context with
    | Some { ctx_figure = Some figure } ->
        figure_of_string figure
    | _ ->
        let txt = input_line stdin in
        loop resp.rsp_context txt
    end
  in
  let ctx =
    `Assoc [ ("square", `String (string_of_square (i, j)));
             ("color", `String (string_of_color color)); ]
  in
  loop ctx ""


let get_casling_rights wcs_config (color: color) : (bool * bool) =
  let rec loop ctx input =
    let req_msg =
      { req_input = { cin_text = input };
        req_alternate_intents = false;
        req_context = Some ctx;
        req_entities = None;
        req_intents = None;
        req_output = None; }
    in
    let resp =
      Rest.message wcs_config wcs_config.wcs_workspace_castling_id req_msg
    in
    Format.printf "Chessbot: %s@."
      (Wcs_message_j.string_of_c_output resp.rsp_output);
    begin match context_of_json resp.rsp_context with
    | Some { ctx_castling_rights = Some [b1; b2] } ->
        (b1, b2)
    | _ ->
        let txt = input_line stdin in
        loop resp.rsp_context txt
    end
  in
  let ctx =
    `Assoc [ ("color", `String (string_of_color color)); ]
  in
  loop ctx ""



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
  { ar = board;
    turn = White;
    cas_w = cas_w;
    cas_b = cas_b;
    en_passant = None; }


let main () =
  let conf = Config.init () in
  Format.printf "Welcome to chess bot@.";
  let mask =
    let m = Array.make_matrix 8 8 None in
    m.(4).(0) <- Some White;
    m.(4).(7) <- Some Black;
    m
  in
  let pos = position_of_mask conf mask in
  ()


let () = main ()
