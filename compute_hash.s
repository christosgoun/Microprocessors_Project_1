	@ Following AAPCS (ARM Architecture Procedure Call Standard)

    .data           @ Data Section
    .align 2        @ Align to 4-byte boundary

@ Look-up Table (LUT) for Digits 0-9
@ Mappings: 0->2, 1->3, 2->5, 3->7, 4->11, 5->13, 6->17, 7->19, 8->23, 9->29
digits_lut:
    .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29

@ Memory location to store the final result for debugging
hash_storage:
    .word 0

    .text           @ Code Section
    .align 2
    .global compute_access_hash
    .syntax unified

compute_access_hash:
    @ --- PROLOGUE ---
    @ Save preserved registers (R4-R6) and Link Register (LR) to the Stack
    @ This is required by the AAPCS calling convention
    PUSH {r4, r5, r6, lr} 

    @ Initialization
    MOV r1, r0          @ Move the string address from R0 to R1
    MOV r2, #0          @ R2 = Counter for length and current offset
    MOV r3, #0          @ R3 = This will hold our accumulating Hash value

    @ --- STEP 1: Calculate String Length ---
    @ We need the length of the PIN to set the initial hash value
find_length:
    LDRB r4, [r1, r2]   @ Load one byte (character) from [Base R1 + Offset R2]
    CMP r4, #0          @ Check for the Null Terminator '\0'
    BEQ init_hash_val   @ If end of string is reached, proceed to next step
    ADD r2, r2, #1      @ Increment length counter
    B find_length       @ Repeat loop

init_hash_val:
    MOV r3, r2          @ Initial Hash Value = String Length
    MOV r2, #0          @ Reset offset to 0 to read the string from the beginning again

    @ --- STEP 2: Main Character Processing Loop ---
main_loop:
    LDRB r4, [r1, r2]   @ Load current character
    CMP r4, #0          @ Check if we reached the end of the string
    BEQ end_function    @ If yes, exit the loop

    @ --- CASE 1: Uppercase Letters (A-Z: ASCII 0x41-0x5A) ---
    CMP r4, #'A'
    BLT check_lower     @ If less than 'A', it might be a digit
    CMP r4, #'Z'
    BGT check_lower     @ If greater than 'Z', it might be a lowercase letter
    
    @ If Uppercase: Hash = Hash + (ASCII * 2)
    @ Using Barrel Shifter: R4 * 2 (LSL #1) then add to R3 and the value is storred at R3
    ADD r3, r3, r4, LSL #1  
    B next_char

check_lower:
    @ --- CASE 2: Lowercase Letters (a-z: ASCII 0x61-0x7A) ---
    CMP r4, #'a'
    BLT check_digit     @ If less than 'a', it might be a digit
    CMP r4, #'z'
    BGT check_digit     @ If greater than 'z', it might be a digit
    
    @ If Lowercase: Convert to Uppercase and add to Hash
    @ Conversion: Clear the 5th bit (0x61 'a' becomes 0x41 'A')
    AND r4, r4, #0xDF   @ Bitwise AND with mask 11011111 (0xDF)
    ADD r3, r3, r4      @ Add the converted ASCII value to Hash
    B next_char

check_digit:
    @ --- CASE 3: Digits (0-9: ASCII 0x30-0x39) ---
    CMP r4, #'0'	
    BLT next_char       @ If not a digit, ignore the character
    CMP r4, #'9'
    BGT next_char       @ If not a digit, ignore the character
    
    @ If Digit: Use the Look-up Table (LUT)
    SUB r4, r4, #'0'    @ Convert ASCII '0'-'9' to numerical value 0-9
    LDR r5, =digits_lut @ Load the base address of the LUT
    LDR r6, [r5, r4, LSL #2] @ Load value: Base + (Index * 4 bytes)
    ADD r3, r3, r6      @ Add LUT value to the Hash

next_char:
    ADD r2, r2, #1      @ Move to the next character (Increment offset)
    B main_loop         @ Repeat the main loop

end_function:
    @ --- STEP 3: Finalization ---
    @ Store the result in memory (useful for Memory View in Debugger)
    LDR r4, =hash_storage
    STR r3, [r4]        @ Store Word
    
    @ Return the final Hash value in R0 (AAPCS rule)
    MOV r0, r3          

    @ --- EPILOGUE ---
    @ Restore saved registers and return to the address stored in LR
    @ By popping into PC, the CPU jumps back to main()
    POP {r4, r5, r6, pc} 

    .end                @ End of Assembly file
		