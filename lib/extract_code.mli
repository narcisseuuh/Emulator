val read_input : string -> string list 
(*
in : a file name.
out : each lines it contains.
 *)

val treat_line : string -> string
(*
in : a string containing an instruction or label.
out : a filtered input to delete comments, or such things that are useless to parsing.
 *)

val treat_lines : string list -> string list 
(*
mapping treat_line to each lines of a list of lines in a file.
 *)

val extract_code : string -> string list 
(*
in : a file name.
out : a list of lines treated to be then parsed.
 *)

val show_lines : string list -> ()
(*
in : a list of lines extracted from a file.
out : a pretty print of each line to debug.
 *)
