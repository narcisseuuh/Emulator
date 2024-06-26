entry
  MOV R0, #0
  SYSCALL ; syscall read()
  PUSH R1 

  MOV R0, #0
  SYSCALL ; syscall read()
  
  POP R0 ; getting our first syscall's value in R0

  CALL calculate ; calculating read_0 - read_1

  CALL showresult ; showing result to user

  HALT ; ending the program

calculate
  SUB R0, R1
  RET

showresult
  MOV R1, R0
  MOV R0, #1
  SYSCALL ; syscall write(result (=R1))
  RET
