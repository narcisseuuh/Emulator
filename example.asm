entry
  SUB SP, #64 ; allocating 20 bytes on the stack to read entries

  MOV R0, #0
  MOV R1, SP
  MOV R2, #32
  SYSCALL ; syscall read(sp, 32)

  MOV R0, #0
  MOV R1, SP
  SUB R1, #32
  MOV R2, #32
  SYSCALL ; syscall read(sp - 32, 32)

  POP R0

  POP R1

  CALL calculate

  CALL show_result

  HALT

calculate
  SUB R0, R1
  RET

show_result
  MOV R1, R0
  MOV R0, #1
  MOV R2, #32
  SYSCALL ; syscall write(result, 32)
  RET
