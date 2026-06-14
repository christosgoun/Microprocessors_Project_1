@ File: compute_checksum.s
@ Description: Bonus checksum calculation using XOR and a salt value (0xAA).
@ AAPCS Compliant: Pointer in R0, Result in R0.

    .text               @ Code Section
    .align 2            @ Align to 4-byte boundary
    .global compute_checksum
    .syntax unified

compute_checksum:
    @ --- PROLOGUE ---
    @ Save preserved reg	isters (R4, R5) and the Link Register (LR)
    PUSH {r4, r5, lr}

    @ --- INITIALIZATION ---
    MOV r1, r0          @ R1 = Base address of the string (copied from R0)
    MOV r2, #0          @ R2 = Index / Offset counter
    MOV r3, #0          @ R3 = Checksum accumulator (starts at 0)
    MOV r5, #0xAA       @ R5 = The Salt constant (Hexadecimal AA)

checksum_loop:
    @ Load the current character
    LDRB r4, [r1, r2]   @ Load one byte (char) into R4
    CMP r4, #0          @ Check if it is the null terminator '\0'
    BEQ end_checksum    @ If end of string, break out of the loop

    @ --- CHECKSUM MATH ---
    @ 1. XOR the character with the Salt
    EOR r4, r4, r5      @ R4 = Current_Char ^ 0xAA

    @ 2. XOR the result with the running Checksum
    EOR r3, r3, r4      @ R3 = Current_Checksum ^ Result

    @ Move to the next character
    ADD r2, r2, #1      @ Increment the offset
    B checksum_loop     @ Repeat

end_checksum:
    @ --- EPILOGUE ---
    @ The C program expects the return value in R0
    MOV r0, r3          

    @ Restore registers and jump back to main()
    POP {r4, r5, pc}

    .end