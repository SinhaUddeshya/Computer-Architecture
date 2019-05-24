------------------------------------------------------------------------
--  LoadxiRun: machine language program for the Sigma16 architecture
------------------------------------------------------------------------

{-  Machine language program which uses the loadxi opcode and calculates
the sum of the elements of an array X, which contains n elements -}

module Main where
import M1run

main :: IO()
main = run_Sigma16_program arrayTotal 1000
     ------------------------------------------------------------------------

arrayTotal:: [String]
arrayTotal =
     --Machine Language     Addr            Assembly Language     Comment
     -- -- ~~~~~~~~~~~~~~~~  ~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [
                         -- 0000   ; Initialise constants and incrementing values like 1
                         -- 0000
        "f100", "0001",  -- 0000             lea    R1,1[R0]    ; R1 = 1
        "f201", "0014",  -- 0002             load   R2,n[R0]    ; R2 = n
        "f300", "0001",  -- 0004             lea    R3,1[R0]    ; R3 = i = 1
        "f401", "0016",  -- 0006             load   R4,x[R0]    ; R4 = sum = x[0]
                         -- 0008
                         -- 0008   ; top of loop
                         -- 0008
                         -- 0008   loop
        "4532",          -- 0008             cmplt   R5,R3,R2       ; R5 = i < n
        "f504", "0011",  -- 0009             jumpf   R5,done[R0]    ; if i>=n then goto done
                         -- 000b
                         -- 000b   ; sum
        "f637", "0016",  -- 000b             loadxi  R6,x[R3]       ; R6 = x[i]
        "0446",          -- 000d             add     R4,R4,R6       ; sum = sum + x[i]
        "0000",          -- 000e             add     R0,R0,R0       ; i = i + 1 Does nothing!
        "f003", "0008",  -- 0001f            jump    loop[R0]    ; if n>1 jump to start of loop
                         -- 0011
                         -- 0011
                         -- 0011   ; exit from loop
                         -- 0011
        "f402", "0015",  -- 0011   done      store   R4,sum[R0]  ; store the sum of array in R4
        "d000",          -- 0013             trap    R0,R0,R0
                         -- 0014
                         -- 0014   ;Data Area
        "0007",          -- 0014   n         data    7 - total size of array 
        "0000",          -- 0015   sum       data    0
        "fffd",          -- 0016   x         data   -3
        "0008",          -- 0017             data    8
        "0004",          -- 0018             data    4
        "0015",          -- 0019             data   21
        "fffa",          -- 001a             data   -6
        "0004",          -- 001b             data    4
        "0005"           -- 001c             data    5
    ]

 -------------------------------------------------------------------------------
