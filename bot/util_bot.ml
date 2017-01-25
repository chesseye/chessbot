open Types
open Types_bot

let json_of_string (s: string) : json =
  Yojson.Basic.from_string s

let string_of_square (i,j) =
  let letter =
    begin match i with
    | 0 -> 'a'
    | 1 -> 'b'
    | 2 -> 'c'
    | 3 -> 'd'
    | 4 -> 'e'
    | 5 -> 'f'
    | 6 -> 'g'
    | 7 -> 'h'
    | _ -> assert false
    end
  in
  Format.sprintf "%c%d" letter (j+1)

let string_of_color c =
  begin match c with
  | White -> "white"
  | Black -> "black"
  end

let string_of_figure figure =
  begin match figure with
  | Bishop -> "bishop"
  | King -> "king"
  | Pawn -> "pawn"
  | Queen -> "queen"
  | Knight -> "knight"
  | Rook -> "rook"
  end

let context_of_json (json: json) =
  (* Format.eprintf "DEBUG: %s@." (Yojson.Basic.to_string json); *)
  begin try
    Some (Context_types_j.context_of_string (Yojson.Basic.to_string json))
  with _ ->
    None
  end

let context_add_string (ctx: json) key value =
  begin match ctx with
  | `Assoc l ->
      let l = List.remove_assoc key l in
      `Assoc ((key, `String value) :: l)
  | _ -> assert false
  end

let color_of_string color =
  begin match color with
  | "white" -> White
  | "black" -> Black
  | color ->
      Format.eprintf "Unknown color: %s" color;
      White
  end

let figure_of_string figure =
  begin match figure with
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

let intent_dispatch_of_string s =
  begin match s with
  | "setup_position" -> Intent_setup_position
  | "undo" -> Intent_undo
  | "resign" -> Intent_resign
  | _ -> assert false
  end

let get_king (board: board) (c: color) : (int * int) option =
  let k = ref None in
  for i = 0 to 7 do
    for j = 0 to 7 do
      begin match board.(i).(j) with
      | Piece (King, c') when c = c' -> k := Some (i, j)
      | _ -> ()
      end
    done
  done;
  !k


let piece_chars =
  [ (King, 'K');
    (Queen, 'Q');
    (Rook, 'R');
    (Bishop, 'B');
    (Knight, 'N');
    (Pawn, 'P') ]

let char_of_color c =
  match c with
  | White -> 'W'
  | Black -> 'B'

let char_of_piece_type pt = List.assoc pt piece_chars

let print_board ar =
  let separator = "\n   +----+----+----+----+----+----+----+----+\n" in
  Format.print_string separator;
  for j = 7 downto 0 do
    Format.printf " %d |" (j + 1);
    for i = 0 to 7 do
      begin match ar.(i).(j) with
      | Piece(pt, c) -> Format.printf " %c%c |" (if c = White then ' ' else '*') (char_of_piece_type pt)
      | Empty -> Format.print_string "    |"
      end
    done;
    Format.print_string separator;
  done;
  Format.print_string "\n      a    b    c    d    e    f    g    h\n"

let print_mask m =
  let separator = "\n   +----+----+----+----+----+----+----+----+\n" in
  print_string separator;
  for j = 7 downto 0 do
    Printf.printf " %d |" (j + 1);
    for i = 0 to 7 do
      match m.(i).(j) with
      | Some c -> Printf.printf "  %c |" (char_of_color c)
      | None -> print_string "    |"
    done;
    print_string separator;
  done;
  print_string "\n      a    b    c    d    e    f    g    h\n"
