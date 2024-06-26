# Idea 

I recently read articles and watched videos about the von neumann architecture and the creation of instruction sets. It made me want to create my own instruction set and emulate it. It was also the occasion to dev again in OCaml after some time without doing so.
As a reminder, in Von Neumann architecture :
- within the CPU there are circuits/components that provide a set of operations. We usually expect operations that perform arithmetic and logic, move value into and out of the registers, and have a control flow (what we will execute after our current block is known).
- we have access within the CPU to general purpose registers to provide us a place to store value and results of operations we are performing.
- among these registers, we will have 2 which have a special purpose : the Instruction Register and the Program Counter. The IR will store the opcode that we want to execute, while the PC will point to the next operation we will execute.
- lastly, I would like to have a stack (and therefore a Stack Pointer) to implement software functions.

## Choice of the operations, associated opcodes and addressing modes 

| Operation | Opcode | Addressing modes                    | purpose                            |
| :-------- | :----: | :---------------------------------- | :--------------------------------- |
| MOV       | 000001 | register, imm or register, register | moves values in register           |
| ADD       | 000010 | register, register or register, imm | add values and store in register   |
| SUB       | 000011 | register, register or register, imm | sub values and do the same         |
| AND       | 000101 | register, imm or register, register | bitwise and                        |
| OR        | 000110 | register, imm or register, register | bitwise or                         |
| NOT       | 000111 | register                            | bitwise not                        |
| JMP       | 001000 | label                               | set PC to value                    |
| JNZ       | 001001 | label                               | JMP if R0 doesn't contain 0        |
| CALL      | 010010 | label                               | push a saved pc and jmp on label   |
| RET       | 010011 | nothing                             | equivalent of POP PC               |
| POP       | 010100 | register                            | store value from stack on register |
| PUSH      | 010101 | register or imm                     | place value from register on stack |
| SYSCALL   | 010110 | nothing                             | will exec a syscall                |
| HALT      | 111111 | nothing                             | terminates the execution           |

Each instruction will be denoted by 12 bits : 6 for the opcode, 3 for the first operand and 3 for the second (therefore we have 2^3 - 1 = 7 registers : R0, ..., R4, R5, PC plus the 111 that denotes an immediate value which we will seek for in the next 12 bits we parse).

Example :
`MOV R0, #2` will become `000001000111 000000000010`
                          (`operand-register0-imm` and then `imm-value`)

## System calls 

| syscall | R0 | R1             |
| :-----: | :-:| :------------: |
| read    | 0  | return value   |
| write   | 1  | written int    |

## Comments 

I allow writing comments in the file which will be ignored when I will assemble. they are denoted by `;`, for example :
```assembly
MOV R0, 0 ; preparing for syscall read
```

## Behaviour of the Stack 

I decided stack will just be chunks of length 32 bits (integers basically), and no allocation on the stack. Therefore, to interact with the stack you can only use `PUSH` and `POP`.

## Parsing real code 

I have written a short program that you can check in `example.asm`. It uses basic operations and some labels. To denote an immediate value I use the `#` sign. for example `#3` will denote 3.
My common registers are noted R0, R1, etc. I also denote the program counter as PC, and stack pointer as SP.

When we will emulate our execution after parsing the entry passed by the file `example.asm`, our emulator will focus on executing from the label `entry`.
In `example.bin` is the traduction of our entry in `example.asm` into the bytecode we previously specified. A function in `bin/assemble.ml` contains the code that will transform our assembly readable program into the bytecode we previously specified.

# Relevant files

## Reading files 

Check `lib/extractcode.ml` and `extractcode.mli`.

## Parsing files 

Check `lib/parse.ml` and `lib/parse.mli`.

## The emulator itself

Check `lib/emulate.ml` and `lib/emulate.mli`.

# Usage

If you want to use it for yourself, you just have to edit the `example.asm` file. Then :

Build :
```bash
dune build 
```

Execute :
```bash 
dune exec emulator
```
