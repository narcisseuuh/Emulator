entry
  MOV R0, #0
  SYSCALL ; syscall read(R0)
  MOV R1, R0

  MOV R0, #0
  SYSCALL ; syscall read(R0)

  CALL calculate

  CALL show_result

  HALT

calculate
  SUB R0, R1
  RET

show_result
  MOV R1, R0
  MOV R0, #1
  SYSCALL ; syscall write(result (=R1))
  RET
