/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global a_value,b_value
.type a_value,%gnu_unique_object
.type b_value,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
a_value:          .word     0  
b_value:           .word     0  

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* Unpacking A and B into new registers. A will be in r1 and B in r2 */
    MOV r1, r0 @ for A
    ASR r1, r1, 16 @ simple process to ensure the sign is correct
    
    /* B is trickier but here is the idea */
    MOV r2, r0 
    LDR r5, =0x0000FFFF @ we will use this for a bitmask
    AND r2, r2, r5 @ this ensures that we only look at the lower 16 bits of the original
    
    LDR r6, =0x00008000 @ we prepare to see if the 16th bit is a 1, which would mean that B is negative
    AND r5, r2, r6 @ this either gives us 0 or a positive number (positive when 16th bit is 1)
    
    CMP r5, 0 @ if the 16th bit is a one (positive/greater than 0), we need to do sign extension
    BGT sign_extension
    
    b storing_values
    
sign_extension:
    /* sets the most significant 16 bits to 1 */
    LDR r5, =0xFFFF0000
    ORR r2, r2, r5
    
storing_values:
    /* Storing these values into a_value and b_value */
    LDR r3, =a_value
    STR r1, [r3]
    
    LDR r4, =b_value
    STR r2, [r4]
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




