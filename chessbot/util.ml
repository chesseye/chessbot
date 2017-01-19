open Types

let string_of_square (i,j) =
  Format.sprintf "(%d, %d)" i j

let string_of_color c =
  begin match c with
  | White -> "white"
  | Black -> "black"
  end

let context_of_json json =
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
