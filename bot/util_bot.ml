open Types
open Types_bot

let string_of_square (i,j) =
  Format.sprintf "(%d, %d)" i j

let string_of_color c =
  begin match c with
  | White -> "white"
  | Black -> "black"
  end

let context_of_json (json: json) =
  begin try
    Some (Context_types_j.context_of_string (Yojson.Basic.to_string json))
  with _ ->
    None
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
