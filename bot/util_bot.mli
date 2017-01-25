open Context_types_t
open Types
open Types_bot

val json_of_string : string -> json

val string_of_square : int * int -> string

val string_of_color : color -> string

val string_of_figure : piece_type -> string

val context_add_string : json -> string -> string -> json

val context_of_json : json -> context option

val color_of_string : string -> color

val figure_of_string : string -> piece_type

val intent_dispatch_of_string : string -> intent_dispatch

val get_king : board -> color -> (int * int) option

val char_of_color : color -> char

val char_of_piece_type : piece_type -> char

val print_board : board -> unit

val print_mask : mask -> unit
