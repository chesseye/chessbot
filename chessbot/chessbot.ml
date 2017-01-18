open Wcs_message_t
open Context_types_t
open Util
open Types

let wcs wcs_config (inputv: string) =
  let req_msg =
    { req_input = { cin_text = inputv };
      req_alternate_intents = false;
      req_context = None;
      req_entities = None;
      req_intents = None;
      req_output = None; }
  in
  let resp =
    Rest.message wcs_config req_msg
  in
  resp

let get_result (json: Yojson.Basic.json) =
  let ctx =
    begin try
      Context_types_j.context_of_string (Yojson.Basic.to_string json)
    with _ ->
      raise Not_found
    end
 in
  let color =
    begin match ctx.ctx_result.ctx_piece_color with
    | "white" -> White
    | "black" -> Black
    | color ->
        Format.eprintf "Unknown color: %s" color;
        White
    end
  in
  let figure =
    begin match ctx.ctx_result.ctx_piece_color with
    | "bishop" -> Bishop
    | "king" -> King
    | "pawn" -> Pawn
    | "queen" -> Queen
    | "knight" -> Knight
    | "rook" -> Rook
    | figure ->
        Format.eprintf "Unknown figure: %s" figure;
        Pawn
    end
  in
  (figure, color)

let get_piece wcs_config ((i, j): int * int) : piece =
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
    begin
      try
      get_result resp.rsp_context
    with
    | Not_found ->
        let txt = input_line stdin in
        loop resp.rsp_context txt
    end
  in
  let ctx =
    `Assoc (["square", `String (string_of_square (i, j))])
  in
  loop ctx ""

let position_of_mask wcs_config (m : mask) =
  let board = Array.make_matrix 8 8 Empty in
  for i = 0 to 7 do
    for j = 0 to 7 do
      begin match m.(i).(j) with
      | Some c ->
          let p = get_piece wcs_config (i, j) in
          board.(i).(j) <- Piece p
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
