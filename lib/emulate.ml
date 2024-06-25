(*
Reminder :

type machine = {
  registers : int array,
  pc : int,
  sp : int,
  stack : int Dynarray.t,
  ir : token,
  label : string, (* to know in which token we currently are *)
  finished : bool (* have we hit the halt instruction *)
}
 *)  

let exec_instruction m = failwith "todo";;

let exec_program h = failwith "todo";;

let emulate file =
  let h = Parse.parse_lines file in 
  exec_program h;;
