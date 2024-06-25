let () =
  try Emulator.Emulate.emulate "example.asm"
  with
    | Fail s -> failwith s
    | Non_terminating -> failwith "function not terminated with HALT";; 
