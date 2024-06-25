open Emulator.Parse

val transform_instruction : token -> string 
(*
in : a token representing an instruction.
out : a string representing the bits encoding this instruction according to the specification written in the README.
 *)

val transform_instructions : token list -> string
(*
in : a list of tokens representing a program.
out : the mapping of transform_instruction to each instruction and a flattening of these strings.
 *)

val assemble : string -> string -> ()
(*
in : two strings : one for the input file and another for the output file.
out : assembling the instructions from file1 and writting the result to file2.
 *)
