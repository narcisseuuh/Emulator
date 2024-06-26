type value =
  | REG of int 
  | IMM of int
  | PC;;

type token =
  | MOV of value * value 
  | ADD of value * value 
  | SUB of value * value
  | AND of value * value 
  | OR of value * value 
  | NOT of value 
  | JMP of string
  | JNZ of string
  | CALL of string
  | POP of value 
  | PUSH of value
  | LABEL of string
  | RET
  | SYSCALL
  | HALT
  | NOP;;

type machine = {
  registers : int array;
  mutable pc : int;
  stack : int Stack.t;
  mutable ir : token;
  mutable label : string; (* to know in which token we currently are *)
  mutable finished : bool; (* have we hit the halt instruction *)
  mutable prev_labels : string list; (* keeping in mind saved labels potentially *)
};;


