open! Emulator.Emulate
open! Emulator.Extractcode
open! Emulator.Parse

(*
let print_list f lst =
  let rec print_elements = function
    | [] -> ()
    | h::t -> print_string "\""; f h; print_string "\""; print_string ";"; print_elements t
  in
  print_string "[";
  print_elements lst;
  print_string "]";;
*)

let () =
  try 
    Emulator.Emulate.emulate "example.asm"
  with
    | Fail s -> failwith s
    | Non_terminating -> failwith "function not terminated with HALT"
    | Segmentation_Fault -> failwith "Segmentation fault...";; 
