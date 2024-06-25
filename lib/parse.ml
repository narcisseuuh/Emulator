open! Extractcode

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
  | HALT;;

exception ParseError;;

let get_alphanum_tokens line =
  (* helper function extracting tokens from a line *)
  String.split_on_char ' ' line;;

let extract_int value =
  (* helper function extracting the integer denoted by value[1:] *)
  let len = String.length value in 
  let sub = String.sub value 1 len in 
  int_of_string sub;;

let to_value value =
  if String.equal value "PC" then 
    PC
  else if value.[0] = '#' then 
    IMM (extract_int value)
  else if value.[0] = 'R' then
    let v = extract_int value in 
    if v >= 0 && v <= 5 then
      REG v
    else
      raise ParseError
  else
    raise ParseError;;

let parse_line line =
  let choose_token tok rest =
    match rest with 
    | (first::second::[]) ->
      if String.equal tok "MOV" then 
        MOV ((to_value first), (to_value second))
      else if String.equal tok "ADD" then
        ADD ((to_value first), (to_value second))
      else if String.equal tok "SUB" then
        SUB ((to_value first), (to_value second))
      else if String.equal tok "AND" then
        AND ((to_value first), (to_value second))
      else if String.equal tok "OR" then
        OR ((to_value first), (to_value second))
      else 
        raise ParseError
    | (first::[]) ->
      if String.equal tok "NOT" then 
        NOT (to_value first)
      else if String.equal tok "JMP" then 
        JMP first
      else if String.equal tok "JNZ" then 
        JNZ first
      else if String.equal tok "CALL" then 
        CALL first
      else if String.equal tok "POP" then 
        POP (to_value first)
      else if String.equal tok "PUSH" then 
        PUSH (to_value first)
      else
        LABEL first
    | [] ->
      if String.equal tok "RET" then
        RET
      else if String.equal tok "SYSCALL" then 
        SYSCALL 
      else if String.equal tok "HALT" then 
        HALT
      else 
        raise ParseError
    | _ ->
        raise ParseError
  in
  let tokens = get_alphanum_tokens line in 
  match tokens with
  | [] -> raise ParseError 
  | (tok::rest) -> choose_token tok rest;;


let rec create_hashtable lines current_label token_list h =
  match lines with 
  | (LABEL new_label::next_tokens) -> begin
      let current_tokens = List.rev token_list in 
      Hashtbl.add h current_label current_tokens;
      create_hashtable next_tokens new_label [] h
    end
  | (curr::next_lines) -> create_hashtable next_lines current_label (curr::token_list) h
  | [] -> h;;

let parse_lines file =
  let h = Hashtbl.create 5 in (* initial guess on number of labels *)
  let lines = List.map parse_line (Extractcode.extract file) in  
  match lines with 
  | [] -> h 
  | (LABEL l::next_lines) -> begin 
    let final_hashtable = create_hashtable next_lines l [] h in 
    final_hashtable
  end
  | _ -> raise ParseError;; (* each program should begin with a label *)
