let read_input file =
  let lines = ref [] in 
  let ic = open_in file in 
  try 
    while true do
      let old_lines = !lines in
      lines := (input_line ic :: old_lines)
    done; !lines 
  with End_of_file ->
    close_in ic;
    List.rev !lines;; 

let treat_line line = 
  let find_semicolumn line =
    (* returns an option int : None if no semicolumn, Some i if s.[i] == ';' *)
    let rec aux line i len =
      if i >= len then 
        None
      else begin 
      if line.[i] = ';' then
        Some i 
      else
        aux line (i + 1) len
      end
    in let len = String.length line in 
    aux line 0 len
  in 
  let sc = find_semicolumn line in 
  match sc with 
  | None -> line 
  | Some i -> String.sub line 0 i;; 

let treat_lines lines = List.filter (fun x -> x <> "") (List.map treat_line lines);;

let show_lines lines = List.iter print_endline lines;;

let extract file =
  let lines = read_input file in 
  treat_lines lines;;
