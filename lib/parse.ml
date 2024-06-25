(*
Reminder : 
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
  | JMP of string
  | JNZ of string
  | CALL of string
  | POP of value 
  | PUSH of value
  | LABEL of string
  | RET
  | SYSCALL
  | HALT
 *)

let get_alphanum_tokens line =
  (* helper function extracting tokens from a line *)
  String.split_on_char ' ' line;;

let extract_int value =
  (* helper function extracting the integer denoted by value[1:] *)
  let len = length.value in 
  let sub = String.sub s 1 len in 
  int_of_string sub;;

let reg_or_imm value =
  if String.equal value "PC" then 
    PC 
  else if String.equal value "SP" then 
    SP 
  else
    if value.[0] = '#' then 
      IMM (extract_int value)
    else if value.[0] = 'R' then 
      REG (extract_int value)
    else
      raise ParseError;;

let parse_line line =
  let choose_token tok rest =
    if String.equal tok "MOV" then 
      let [first; second] = rest in 
      MOV (to_value first) (to_value second)
    else if String.equal tok "ADD" then
      let [first; second] = rest in 
      ADD (to_value first) (to_value second)
    else if String.equal tok "SUB" then
      let [first; second] = rest in 
      SUB (to_value first) (to_value second)
    else if String.equal tok "AND" then
      let [first; second] = rest in 
      AND (to_value first) (to_value second)
    else if String.equal tok "OR" then
      let [first; second] = rest in 
      OR (to_value first) (to_value second)
    else if String.equal tok "NOT" then 
      let [first] = rest in 
      NOT (to_value first)
    else if String.equal tok "JMP" then 
      let [first] = rest in 
      JMP first
    else if String.equal tok "JNZ" then 
      let [first] = rest in 
      JNZ first
    else if String.equal tok "CALL" then 
      let [first] = rest in 
      CALL first
    else if String.equal tok "POP" then 
      let [first] = rest in 
      POP (to_value first)
      else if String.equal tok "PUSH" then 
      let [first] = rest in 
      PUSH (to_value first)
    else if String.equal tok "RET" then
      RET
    else if String.equal tok "SYSCALL" then 
      SYSCALL 
    else if String.equal tok "HALT" then 
      HALT
    else
      let [first] = rest in 
      LABEL (to_value first)
  let tokens = get_alphanum_tokens line in 
  match tokens with
  | [] -> raise ParseError 
  | tok:rest -> choose_token tok rest;;

let parse_lines lines =

