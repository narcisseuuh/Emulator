open! Parse

type machine = {
  registers : int array;
  pc : int;
  sp : int;
  stack : int array;
  ir : token;
  label : string; (* to know in which token we currently are *)
  finished : bool (* have we hit the halt instruction *)
}

exception Fail of string

exception Non_terminating (* if the program is not finished by a halt instruction *)

exception Segmentation_Fault

let exec_instruction m = failwith "todo";;

let exec_program h = failwith "todo";;

let emulate file =
  let h = Parse.parse_lines file in 
  exec_program h;;
