open! Types

(*
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
*)


let print_value value = 
  match value with 
  | PC -> Printf.printf "PC "
  | IMM x -> Printf.printf "IMM %d " x
  | REG x -> Printf.printf "REG %d " x;;

let print_token tok =
  match tok with 
  | MOV (v1, v2) -> begin 
    print_string "MOV_TOK ("; print_value v1 ; print_value v2; print_string ")"  
  end
  | ADD (v1, v2) -> begin 
    print_string "ADD_TOK ("; print_value v1 ; print_value v2; print_string ")" 
  end 
  | SUB (v1, v2) -> begin 
    print_string "SUB_TOK ("; print_value v1 ; print_value v2; print_string ")"   
  end 
  | AND (v1, v2) -> begin 
    print_string "AND_TOK ("; print_value v1 ; print_value v2; print_string ")"  
  end  
  | OR (v1, v2) -> begin 
    print_string "OR_TOK ("; print_value v1 ; print_value v2; print_string ")"  
  end
  | NOT v -> begin 
    print_string "NOT_TOK ("; print_value v ; print_string ")"  
  end
  | JMP label -> begin 
    print_string "JMP_TOK ("; print_string label ; print_string ")"  
  end 
  | JNZ label -> begin 
    print_string "JNZ_TOK ("; print_string label ; print_endline ")"  
  end 
  | CALL label -> begin 
    print_string "CALL_TOK ("; print_string label ; print_string ")"  
  end
  | POP v -> begin 
    print_string "POP_TOK ("; print_value v ; print_string ")"  
  end
  | PUSH v -> begin 
    print_string "PUSH_TOK ("; print_value v ; print_string ")"  
  end
  | LABEL name -> begin 
    print_string "LABEL_TOK ("; print_string name ; print_string ")"  
  end 
  | RET -> print_string "RET_TOK"
  | SYSCALL -> print_string "SYSCALL_TOK"
  | HALT -> print_string "HALT_TOK"
  | NOP -> print_string "NOP_TOK";;

let print_list f lst =
  let rec print_elements = function
    | [] -> ()
    | h::t -> print_string "\""; f h; print_string "\""; print_string ";"; print_elements t
  in
  print_string "[";
  print_elements lst;
  print_string "]";;

let print_hashtable =
  Hashtbl.iter (fun label tokens ->
    print_string label; print_endline ":"; print_list print_token tokens; print_newline ())
