open! Parse

type machine = {
  registers : int array;
  mutable pc : int;
  stack : int Stack.t;
  mutable ir : token;
  mutable label : string; (* to know in which token we currently are *)
  mutable finished : bool; (* have we hit the halt instruction *)
  mutable prev_labels : string list; (* keeping in mind saved labels potentially *)
};;

exception Fail of string;;

exception Non_terminating;; (* if the program is not finished by a halt instruction *)

exception Segmentation_Fault;;

let exec_binop m v1 v2 operator =
  match (v1, v2) with 
  | (REG x, IMM y) -> m.registers.(x) <- operator m.registers.(x) y
  | (REG x, REG y) -> m.registers.(x) <- operator m.registers.(x) m.registers.(y)
  | (PC, IMM y) -> m.pc <- operator m.pc y
  | (PC, REG y) -> m.pc <- operator m.pc m.registers.(y)
  | _ -> raise (Fail "binary operator applied on wrong arguments");;

let exec_jmp m label =
  m.pc <- 0;
  m.label <- label;;

let exec_call m label = 
  Stack.push m.pc m.stack; 
  let prev_labels = (m.label :: m.prev_labels) in
  m.prev_labels <- prev_labels;
  m.label <- label;;

let exec_ret m = 
  let new_pc = Stack.pop m.stack in
  match m.prev_labels with
  | [] -> raise (Fail "execution of ret at wrong timing")
  | new_label :: labels -> begin
    m.pc <- new_pc;
    m.label <- new_label;
    m.prev_labels <- labels
  end;;

let exec_syscall m =
  if m.registers.(0) = 1 then 
    print_int (m.registers.(1))
  else if m.registers.(0) = 0 then
    let n = read_int () in 
    m.registers.(0) <- n
  else 
    raise (Fail "this syscall does not exist...");;

let exec_instruction m =
  match m.ir with 
  | MOV (v1, v2) -> exec_binop m v1 v2 (fun _ -> fun y -> y)
  | ADD (v1, v2) -> exec_binop m v1 v2 (+)
  | SUB (v1, v2) -> exec_binop m v1 v2 (-)
  | AND (v1, v2) -> exec_binop m v1 v2 (land)
  | OR (v1, v2) -> exec_binop m v1 v2 (lor)  
  | NOT (REG x) -> m.registers.(x) <- lnot m.registers.(x)
  | NOT _ -> raise (Fail "bitwise not applied on wrong argument")
  | JMP label -> exec_jmp m label
  | JNZ label -> if m.registers.(0) = 0 then exec_jmp m label 
  | CALL label -> exec_call m label 
  | POP (REG x) ->
      let n = Stack.pop (m.stack) in 
      m.registers.(x) <- n
  | POP PC -> 
      let n = Stack.pop (m.stack) in 
      m.pc <- n 
  | POP _ -> raise (Fail "pop applied on wrong argument")
  | PUSH (REG x) | PUSH (IMM x) -> Stack.push x m.stack 
  | PUSH PC -> Stack.push m.pc m.stack 
  | LABEL _ -> raise (Fail "cannot execute label")
  | RET -> exec_ret m 
  | SYSCALL -> exec_syscall m 
  | HALT -> m.finished <- true

let rec move left right amount =
  (* moving in a double linked list according to the signed integer 'amount'. *)
  if amount = 0 then 
    (left, right)
  else if amount < 0 then 
    match left with
    | [] -> raise (Fail "wrong program counter during execution.")
    | h::t -> move t (h::right) (amount + 1)
  else
    match right with 
    | [] -> raise (Fail "wrong program counter during execution.")
    | h::t -> move (h::left) t (amount - 1);;

let rec exec_instructions m to_exec prev_exec h =
  (* helper function to execute a list of instructions 
  the already_executed parameter permits the instructions like :
    SUB SP, 10 
  as we will just pop previously executed instructions to get to that point again.
   *)
  if not (m.finished) then begin
    let prev_pc = m.pc in 
    exec_instruction m;
    let (new_to_exec, new_prev_exec) = move to_exec prev_exec (m.pc - prev_pc) in 
    m.ir <- List.hd to_exec;
    exec_instructions m new_to_exec new_prev_exec h
  end;;


let exec_program h = 
  try 
  let entry_instructions = Hashtbl.find h "entry" in
  let m = {
    registers = [|0 ; 0 ; 0 ; 0 ; 0 ; 0|];
    pc = 0 ;
    stack = Stack.create ();
    ir = List.hd entry_instructions ;
    label = "entry" ;
    finished = false ;
    prev_labels = [] ;
  } in 
  exec_instructions m entry_instructions [] h
  with 
  | Not_found -> raise (Fail "entry label not found");;

let emulate file =
  let h = Parse.parse_lines file in 
  exec_program h;;
