let read_input file =
  let lines = ref [] in 
  let ic = open_in file in 
  try 
    while true do 
      lines := input_line ic : !lines 
    done; !lines 
  with End_of_file ->
    close_in ic;
    List.rev !lines;; 

let treat_line line = 
  let find_semicolumn line =
    (* returns an option int : None if no semicolumn, Some i if s.[i] == ';' *)
    let len = String.length line in 
    for i = 0 to len do 
      if s.[i] = ';' then 
        Some i 
    None
  in 
  let sc = find_semicolumn line in 
  match sc with 
  | None -> line 
  | Some i -> String.sub line 0 i;; 

let treat_lines lines = List.map treat_line lines;;

let extract_code file =
  let lines = read_input file in 
  treat_lines lines;;

let show_lines lines = List.iter print_endline lines;;
