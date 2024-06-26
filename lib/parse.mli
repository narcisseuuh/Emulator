open! Types

exception ParseError of string

val parse_line : string -> token
(*
in : a string representing a line of assembly code.
out : the token corresponding to the line we extracted.
 *)

val parse_lines : token list -> (string, token list) Hashtbl.t -> (string, token list) Hashtbl.t
(*
in : a list of lines (already treated as tokens) and an hashtable.
out : an hashtable storing the token list of each label we extracted from our file.
 *)

val parse_file : string -> (string, token list) Hashtbl.t
(*
in : a file name.
out : an hashtable storing the token list of each label we extracted from our file.
 *)
