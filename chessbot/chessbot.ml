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
    let resp = Rest.message wcs_config req_msg in
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

let position_of_mask wcs_config (m : mask) =
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
  { ar = board;
    turn = White;
    cas_w = (false, false);
    cas_b = (false, false);
    en_passant = None; }


let main () =
  let conf = Config.init () in
  Format.printf "Welcome to chess bot@.";
  let mask =
    let m = Array.make_matrix 8 8 None in
    m.(2).(4) <- Some Black;
    m.(3).(5) <- Some White;
    m
  in
  let pos = position_of_mask conf mask in
  ()


let () = main ()
