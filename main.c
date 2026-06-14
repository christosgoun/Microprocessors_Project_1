#include <stdio.h>


extern int compute_access_hash(char *pin);      // Function 1: Hash Calculation
extern int compute_clearance_level(int hash);   // Function 2: Clearance Level
extern int compute_lucas(int n);                // Function 3: Lucas Sequence (Recursive)
extern int compute_checksum(char *pin);         // Bonus: XOR Checksum with 0xAA Salt

int main(void) {
    // Input Data Definition
    char my_pin[] = "A9b3";
    
    // Variables to store the results
    int final_hash = 0;
    int clearance = 0;
    int lucas_code = 0;
    int checksum = 0;


    printf("Input PIN: %s\n", my_pin);

    // STEP 1: Calculate the Hash (Passing the string address to R0)
    final_hash = compute_access_hash(my_pin);
    printf("Function 1: Calculated Access Hash = %d\n", final_hash);

    // STEP 2: Calculate Clearance Level (Passing the hash value to R0)
    // This counts the bits (Hamming Weight) and takes Modulo 6
    clearance = compute_clearance_level(final_hash);
    printf("Function 2: Clearance Level = %d\n", clearance);

    // STEP 3: Generate Final Unlock Code (Lucas Sequence)
    // Passing the clearance level to R0
    lucas_code = compute_lucas(clearance);
    printf("Function 3: Lucas Sequence = %d\n", lucas_code);

    // BONUS: Calculate Checksum with XOR
    // Passing the string address to R0
    checksum = compute_checksum(my_pin);
    printf("Bonus Function: XOR Checksum = 0x%02X\n", (unsigned char)checksum);


    /* Infinite loop required for bare-metal/embedded environments */
    while(1) {
        // CPU remains idle
    }
}