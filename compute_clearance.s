@ File: compute_clearance.s
@ Description: Calculates Clearance Level = (Hamming Weight of Hash) MOD 6


    .text           @ Code Section
    .align 2
    .global compute_clearance_level
    .syntax unified

compute_clearance_level:
    @ --- PROLOGUE ---
    @ Save preserved registers (R4, R5) and Link Register (LR)
    PUSH {r4, r5, lr}

    @ R0 contains the 'hash' value passed from main()
    MOV r1, r0          @ Move hash to R1 so we can process it
    MOV r2, #0          @ R2 will be our Hamming Weight counter (number of 1s)

    @ --- STEP 1: Calculate Hamming Weight ---
count_bits_loop:
    CMP r1, #0          @ Check if there are any 1s left in the number
    BEQ calculate_mod   @ If R1 is 0, we finished counting bits

    @ Logical Shift Right with 'S' suffix to update the Carry Flag
    @ The bit that falls off the right end goes into the Carry Flag (C)
    LSRS r1, r1, #1     
    
    @ Add with Carry: If Carry is 1, it adds 1 to R2. If Carry is 0, it adds 0.
    @ Note: ARM Compiler might prefer "ADDCS r2, r2, #1" (Add if Carry Set)
	IT CS
    ADDCS r2, r2, #1  

    B count_bits_loop   @ Repeat until R1 becomes 0

calculate_mod:
    @ --- STEP 2: Calculate Modulo 6 ---
    @ At this point, R2 contains the Hamming Weight (Numerator)
    @ We need to calculate: R2 MOD 6
    @ Formula: Modulo = Numerator - ( (Numerator / 6) * 6 )
    
    MOV r3, #6          @ R3 = Denominator (6)
    
    @ Unsigned Divide: R4 = R2 / 6
    UDIV r4, r2, r3     
    
    @ Multiply back: R5 = R4 * 6
    MUL r5, r4, r3      
    
    @ Subtract to get remainder: R0 = R2 - R5
    @ We put the result directly into R0 because AAPCS requires the return value in R0
    SUB r0, r2, r5      

    @ --- EPILOGUE ---
    @ Restore saved registers and return to main
    POP {r4, r5, pc}

    .end