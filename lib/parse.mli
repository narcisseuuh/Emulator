open Extract_code

type value =
  | REG of int 
  | IMM of int
  | PC
  | SP 

type token =
  | MOV of value * value 
  | ADD of value * value 
  | SUB of value * value
  | AND of value * value 
  | OR of value * value 
  | NOT of value 
  | JMP of string (* Jumps and calls are denoted by strings as they contain labels *)
  | JNZ of string
  | CALL of string
  | POP of value 
  | PUSH of value
  | LABEL of string
  | RET
  | SYSCALL
  | HALT

exception ParseError

val parse_line : string -> token
(*
in : a string representing a line of assembly code.
out : the token corresponding to the line we extracted.
 *)

val parse_lines : string -> (string, token list) Hashtbl.t
(*
in : a file name.
out : an hashtable storing the token list of each label we extracted from our file.
 *)
