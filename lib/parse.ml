open! Extractcode
open! Prettyprint
open! Types

exception ParseError of string;;

let remove_comma pat =
  (* helper function which will remove comma from a string *)
  let splitted = String.split_on_char ',' pat in 
  List.fold_left (^) "" splitted;;

let split_line_spaces line =
  (* helper function extracting tokens from a line, it will split the string on spaces to extract each token and then treat all of them to remove commas, or removing empty strings. *)
  let splitted = String.split_on_char ' ' line in 
  let commas_removed = List.map remove_comma splitted in 
  List.filter (fun x -> x <> "") commas_removed;;

let extract_int value =
  (* helper function extracting the integer denoted by value[1:] *)
  let len = String.length value in 
  let sub = String.sub value 1 (len - 1) in
  int_of_string sub;;

let to_value value =
  (* convert a string denoting a value into a value. *)
  if String.equal value "PC" then 
    PC
  else if value.[0] = '#' then 
    IMM (extract_int value)
  else if value.[0] = 'R' then
    let v = extract_int value in 
    if v >= 0 && v <= 5 then
      REG v
    else
      raise (ParseError "unbound value")
  else
    raise (ParseError "unbound value");;

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
        raise (ParseError "unknown binary operator")
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
        raise (ParseError "unknown unary operator")
    | [] ->
      if String.equal tok "RET" then
        RET
      else if String.equal tok "SYSCALL" then 
        SYSCALL 
      else if String.equal tok "HALT" then 
        HALT
      else 
        LABEL tok
    | _ ->
        raise (ParseError "too many operators provided.")
  in
  let tokens = split_line_spaces line in 
  match tokens with
  | [] -> NOP
  | (tok::rest) -> choose_token tok rest;;


let rec create_hashtable lines current_label token_list h =
  match lines with 
  | (LABEL new_label::next_tokens) ->
    if not (String.equal current_label "") then begin
      let current_tokens = List.rev token_list in 
      Hashtbl.add h current_label current_tokens;
      create_hashtable next_tokens new_label [] h 
    end
    else
      create_hashtable next_tokens new_label [] h
  | (curr::next_lines) -> create_hashtable next_lines current_label (curr::token_list) h
  | [] ->
      if not (String.equal current_label "") then begin
        let current_tokens = List.rev token_list in 
        Hashtbl.add h current_label current_tokens;
        h 
      end
      else
        h;;

let parse_lines lines h =
  let new_hashtable = create_hashtable lines "" [] h in
  new_hashtable;;

let parse_file file = 
  let h = Hashtbl.create 5 in 
  let lines = List.map parse_line (Extractcode.extract file) in 
  parse_lines lines h;;
