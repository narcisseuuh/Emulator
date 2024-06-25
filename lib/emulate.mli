open! Parse

type machine = {
  registers : int array;
  mutable pc : int;
  stack : int Stack.t;
  mutable ir : token;
  mutable label : string; (* to know in which token we currently are *)
  mutable finished : bool; (* have we hit the halt instruction *)
  mutable prev_labels : string list; (* keeping in mind saved labels potentially *)
}


exception Fail of string

exception Non_terminating (* if the program is not finished by a halt instruction *)

exception Segmentation_Fault

val exec_instruction : machine -> unit
(*
executing the instruction stored in the IR to go to the next state of our machine.
 *)

val exec_program : (string, token list) Hashtbl.t -> unit 
(*
in : a list of tokens representing a program.
out : a machine at its final state.
 *)

val emulate : string -> unit
(*
in : a file name.
out : the execution of the program (Non_terminating exception will be raised if it does not finish by a halt) extracted from the input file.
 *)
