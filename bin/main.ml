open! Emulator.Emulate
open! Emulator.Extractcode
open! Emulator.Parse
open! Emulator.Prettyprint

let _ = print_endline "======== result of extraction ==================";;
let _ = print_list print_string (extract "example.asm");;
let _ = print_newline ();;
let _ = print_newline ();;

let _ = print_endline "======== result of parsing =====================";;
let parsed = parse_file "example.asm";;
let _ = print_hashtable parsed;;
let _ = print_newline ();;
let _ = print_newline ();;

let _ = print_endline "======== result of emulation ===================";;
let _ = print_newline ();;
try 
  Emulator.Emulate.emulate "example.asm"
with
  | Fail s -> failwith s
  | Non_terminating -> failwith "function not terminated with HALT"
  | Segmentation_Fault -> failwith "Segmentation fault...";;
