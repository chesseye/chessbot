type json = Yojson.Basic.json

type wcs_config = {
    wcs_user: string;
    wcs_password: string;
    wcs_workspace_square_id: string;
    wcs_workspace_castling_id: string;
    wcs_workspace_turn_id: string;
  }

type color = Black | White

type piece_type = King | Queen | Rook | Bishop | Knight | Pawn

type piece = piece_type * color

type field = Piece of piece | Empty

type can_castle = bool * bool

type board = field array array

type position = {
    ar: board;
    turn: color;
    cas_w : can_castle; cas_b : can_castle;
    en_passant : int option;
  }

type mask = color option array array

