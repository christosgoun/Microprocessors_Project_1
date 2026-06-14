@ File: compute_lucas.s
@ Description: Recursive calculation of the Lucas Sequence
@ Input: R0 = n (Clearance Level)
@ Output: R0 = L(n)

    .text
    .align 2
    .global compute_lucas
    .syntax unified

compute_lucas:
    @ --- CHECK BASE CASES ---
    CMP r0, #0          @ If n == 0
    BEQ base_case_0
    
    CMP r0, #1          @ If n == 1
    BEQ base_case_1

    @ --- RECURSIVE CASE (n > 1) ---
    @ Prologue: Save preserved registers and the Link Register (LR)
    PUSH {r4, r5, lr}

    MOV r4, r0          @ Save current 'n' into R4 so it survives the function call

    @ Step 1: Calculate L(n-1)
    SUB r0, r4, #1      @ R0 = n - 1
    BL compute_lucas    @ Call compute_lucas(n-1). Result is returned in R0
    MOV r5, r0          @ Save the result of L(n-1) into R5

    @ Step 2: Calculate L(n-2)
    SUB r0, r4, #2      @ R0 = n - 2
    BL compute_lucas    @ Call compute_lucas(n-2). Result is returned in R0

    @ Step 3: Add the two results together
    @ Current R0 holds L(n-2). R5 holds L(n-1).
    ADD r0, r5, r0      @ R0 = L(n-1) + L(n-2)

    @ Epilogue: Restore registers and return
    POP {r4, r5, pc}

    @ --- BASE CASE RETURN BLOCKS ---
base_case_0:
    MOV r0, #2          @ L(0) = 2
    BX lr               @ Branch exchange back to caller (no POP needed as we didn't PUSH)

base_case_1:
    MOV r0, #1          @ L(1) = 1
    BX lr               @ Branch exchange back to caller

    .end