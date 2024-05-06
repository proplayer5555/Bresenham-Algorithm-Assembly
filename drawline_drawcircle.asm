DEDOMENA    SEGMENT
    POINTS DW 1024 DUP(0)    
    NPOINTS DW 0
DEDOMENA    ENDS

KODIKAS     SEGMENT
ARXH:
    MOV AX,DEDOMENA     ; load data segment address
    MOV DS,AX           ; set data segment register with data address

    ; change to graphics mode
    MOV AH, 0           ; function number to set video mode
    MOV AL, 13h         ; graphical mode 320x200
    INT 10H             ; call int 10h to change to graphics mode 

    MOV AX, 0A000H      ; load segment address for video memory (screen)
    MOV ES, AX          ; save screen address in extra segment register

    MOV AX, 100         ; position x1
    MOV BX, 100         ; position y1
    MOV CX, 200         ; position x2
    MOV DX, 200         ; position y2
    PUSH DX             ; save y2 as stack argument
    PUSH CX             ; save x2 as stack argument
    PUSH BX             ; save y1 as stack argument
    PUSH AX             ; save x1 as stack argument
    CALL DRAWLINE       ; draw the line
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 20          ; position x1
    MOV BX, 80          ; position y1
    MOV CX, 250         ; position x2
    MOV DX, 1           ; position y2
    PUSH DX             ; save y2 as stack argument
    PUSH CX             ; save x2 as stack argument
    PUSH BX             ; save y1 as stack argument
    PUSH AX             ; save x1 as stack argument
    CALL DRAWLINE       ; draw the line
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 10          ; position x1
    MOV BX, 170         ; position y1
    MOV CX, 310         ; position x2
    MOV DX, 170         ; position y2
    PUSH DX             ; save y2 as stack argument
    PUSH CX             ; save x2 as stack argument
    PUSH BX             ; save y1 as stack argument
    PUSH AX             ; save x1 as stack argument
    CALL DRAWLINE       ; draw the line
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 80          ; position x1
    MOV BX, 10          ; position y1
    MOV CX, 80          ; position x2
    MOV DX, 190         ; position y2
    PUSH DX             ; save y2 as stack argument
    PUSH CX             ; save x2 as stack argument
    PUSH BX             ; save y1 as stack argument
    PUSH AX             ; save x1 as stack argument
    CALL DRAWLINE       ; draw the line
    ADD SP, 8           ; remove arguments from stack


    MOV AX, 120         ; center position x
    MOV BX, 110         ; center position y
    MOV CX, 80          ; radius r
    MOV DX, 360         ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 200         ; center position x
    MOV BX, 100         ; center position y
    MOV CX, 30          ; radius r
    MOV DX, 360         ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 250         ; center position x
    MOV BX, 50          ; center position y
    MOV CX, 40          ; radius r
    MOV DX, 60          ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 250         ; center position x
    MOV BX, 80          ; center position y
    MOV CX, 20          ; radius r
    MOV DX, 120         ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 190         ; center position x
    MOV BX, 180         ; center position y
    MOV CX, 60          ; radius r
    MOV DX, 180          ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 250         ; center position x
    MOV BX, 140         ; center position y
    MOV CX, 10          ; radius r
    MOV DX, 240         ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    MOV AX, 125         ; center position x
    MOV BX, 145         ; center position y
    MOV CX, 40          ; radius r
    MOV DX, 300         ; angle a
    PUSH DX             ; save a as stack argument
    PUSH CX             ; save r as stack argument
    PUSH BX             ; save y as stack argument
    PUSH AX             ; save x as stack argument
    CALL DRAWCIRCLE     ; draw the circle
    ADD SP, 8           ; remove arguments from stack

    ; wait until user presses key
    MOV AH, 0           ; function number to read a character
    INT 16H             ; call int 21h to read a character

    ; change to text mode
    MOV AH, 0           ; function number to set video mode
    MOV AL, 3h          ; text mode 80x25
    INT 10H             ; call int 10h to change to graphics mode 

    ; Terminate program
    MOV AH,4CH          ; function number to exit program
    INT 21H             ; call int 21h to exit program

; Function to draw a point, receives the following arguments in the stack:
; Coordinates of point x, y
; If the point is outside of the screen, it doesn't draw it
DRAWPOINT PROC
    PUSH BP             ; save frame pointer
    MOV BP, SP          ; point to new stack frame
    PUSH AX             ; save AX register in the stack
    PUSH BX             ; save BX register in the stack
    PUSH DX             ; save DX register in the stack
    PUSH DI             ; save DI register in the stack
    MOV AX, [BP + 4]    ; load x
    CMP AX, 0           ; check that x is > 0
    JL  P1              ; if x< 0, return
    CMP AX, 320         ; check that x is < 320
    JGE  P1             ; if x>=320, return
    MOV AX, [BP + 6]    ; load y
    CMP AX, 0           ; check that y is > 0
    JL  P1              ; if y< 0, return
    CMP AX, 200         ; check that y is < 200
    JGE  P1             ; if y>=200, return
    MOV AX, [BP + 6]    ; load second argument (y)
    MOV BX, 320         ; load screen width
    MUL BX              ; multiply y*width 
    ADD AX, [BP + 4]    ; add y*width + x
    MOV DI, AX          ; load calculated address in di
    MOV AL, 15          ; load white color
    MOV ES:[DI], AL     ; draw pixel in x,y
P1:
    POP DI              ; restore DI value from stack
    POP DX              ; restore DX value from stack
    POP BX              ; restore BX value from stack
    POP AX              ; restore AX value from stack
    POP BP              ; restore frame pointer
    RET                 ; return to caller
DRAWPOINT ENDP

; Function to draw an octant using the global point array, receives:
; number of points to draw, 
; x position of center, y position of center, 
; coordinate to use for x (1=x, -1= -x. 2 = y, -2 = -y)
; coordinate to use for y (1=x, -1= -x. 2 = y, -2 = -y)
; direction 0 = forwards, 1 = backwards
DRAWOCTANT PROC
    PUSH BP             ; save frame pointer
    MOV BP, SP          ; point to new stack frame
    PUSH AX             ; save AX register in the stack
    PUSH BX             ; save AX register in the stack
    PUSH CX             ; save CX register in the stack
    PUSH SI             ; save SI register in the stack

    MOV CX, [BP + 4]    ; load number of points

    LEA SI, POINTS      ; point to start of point array

    MOV AX, [BP + 12]   ; load direction
    CMP AX, 0           ; check if plotting in normal order
    JE  PLTLOOP         ; if normal, start plotting points

    MOV BX, [NPOINTS]   ; load total number of points in octant
    DEC BX              ; decrement to get position of last point
    SHL BX, 2           ; multiply by 4 to get position in bytes
    ADD SI, BX          ; add to start of array to get address

PLTLOOP:
    MOV AX, [BP + 8]    ; load center y
    MOV BL, [BP + 11]   ; load second coordinate to use 
    CMP BL, 2           ; check if x or y should be used
    JE USEY1            ; if 2 use y
    CMP BL, -2          ; check if x or y should be used
    JE USEY1            ; if -2 use y
    CMP BL, 0           ; check if x or -x should be used
    JL USEMX1           ; if < 0, use -x
    ADD AX, [SI]        ; center y + x
    JMP SAVE1           ; save x
USEMX1:    
    SUB AX, [SI]        ; center y - x
    JMP SAVE1           ; save x
USEY1:    
    CMP BL, 0           ; check if y or -y should be used
    JL USEMY1           ; if < 0, use -y
    ADD AX, [SI + 2]    ; center y + y
    JMP SAVE1           ; save x
USEMY1:    
    SUB AX, [SI + 2]    ; center y - y
SAVE1:
    PUSH AX             ; pass y as second argument to function

    MOV AX, [BP + 6]    ; load center x
    MOV BL, [BP + 10]   ; load first coordinate to use 
    CMP BL, 2           ; check if x or y should be used
    JE USEY2            ; if 2 use y
    CMP BL, -2          ; check if x or y should be used
    JE USEY2            ; if -2 use y
    CMP BL, 0           ; check if x or -x should be used
    JL USEMX2           ; if < 0, use -x
    ADD AX, [SI]        ; center x + x
    JMP SAVE2           ; save x
USEMX2:    
    SUB AX, [SI]        ; center x - x
    JMP SAVE2           ; save x
USEY2:    
    CMP BL, 0           ; check if y or -y should be used
    JL USEMY2           ; if < 0, use -y
    ADD AX, [SI + 2]    ; center x + y
    JMP SAVE2           ; save x
USEMY2:
    SUB AX, [SI + 2]    ; center x - y
SAVE2:
    PUSH AX             ; pass x as first argument to function
    
    CALL DRAWPOINT      ; draw the point using x and y
    ADD SP, 4           ; remove arguments from stack
    
    MOV AX, [BP + 12]   ; load direction
    CMP AX, 0           ; check if plotting in normal order
    JNE BKWD            ; if not, go backwards
    ADD SI, 4           ; advance to next point
    JMP NEXT            ; jump to loop
BKWD:
    SUB SI, 4           ; advance to next point
NEXT:
    LOOP PLTLOOP        ; repeat for all points

    POP SI              ; restore SI value from stack
    POP CX              ; restore CX value from stack
    POP BX              ; restore AX value from stack
    POP AX              ; restore AX value from stack
    POP BP              ; restore frame pointer
    RET                 ; return to caller
DRAWOCTANT ENDP

; Function to draw a circle, receives the following arguments in the stack:
; Center coordinates x, y, radius z, and degrees d (0-360)
DRAWCIRCLE PROC
    PUSH BP             ; save frame pointer
    MOV BP, SP          ; point to new stack frame
    PUSH AX             ; save AX register in the stack
    PUSH BX             ; save BX register in the stack
    PUSH CX             ; save CX register in the stack
    PUSH DX             ; save DX register in the stack
    PUSH SI             ; save SI register in the stack
    PUSH DI             ; save DI register in the stack

    ; x=0;
    MOV BX, 0           ; set x = 0

    ; y=r;
    MOV CX, [BP + 8]    ; copy radius to y

    ; save initial point
    LEA SI, POINTS      ; point to start of point array
    MOV [SI], BX        ; save x
    MOV [SI + 2], CX    ; save y
    ADD SI, 4           ; advance to next position

    ; d =3- 2 r;
    MOV AX, [BP + 8]    ; load radius 
    SHL AX, 1           ; multiply radius*2
    MOV DI, 3           ; d = 3
    SUB DI, AX          ; d = 3 - 2*r

    ; while ( x< y )
C1:
    CMP BX, CX          ; compare x and y
    JL  WHILE1          ; if x < y, go to while 
    JMP C4              ; else, end function
WHILE1:
    ; x++;
    INC BX              ; increment x

    ; if ( d <0 )
    CMP DI, 0           ; compare d with 0
    JGE C2              ; if d>=0, skip to C2
    
    ; d =d+4x+6;
    MOV AX, BX          ; copy x to AX
    SHL AX, 2           ; multiply by 4 by shifting twice to the left
    ADD DI, AX          ; add d + 4*x
    ADD DI, 6           ; add d + 4*x + 6

    JMP C3              ; jump to end of if in C3
    ; else
C2:
    ; y--;
    DEC CX              ; decrement y

    ; d =d+4(x- y)+10;
    MOV AX, BX          ; copy x to AX
    SUB AX, CX          ; subract x - y
    SHL AX, 2           ; multiply by 4 by shifting twice to the left
    ADD DI, AX          ; add d + 4*(x-y)
    ADD DI, 10          ; add d + 4*(x-y) + 10

C3:
    ; save point
    MOV [SI], BX        ; save x
    MOV [SI + 2], CX    ; save y
    ADD SI, 4           ; advance to next position

    JMP C1              ; repeat loop
C4:
    INC BX              ; add initial point
    MOV [NPOINTS], BX       ; save number of points

    MOV AX, [BP + 10]   ; load angle
    MUL BX              ; multiply by x
    MOV CX, 45          ; load 45
    MOV DX, 0           ; clear DX before division
    DIV CX              ; divide angle*x / 45
    MOV BX, AX          ; copy number of points for the given angle in BX

    CMP BX, 0           ; if no points to plot
    JNE PLOT            ; if more than zero, continue to plot octants
    INC BX              ; otherwise use a single point
PLOT:
    MOV CX, BX          ; copy number of points in CX

    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O1              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O1:
    MOV AX, 0           ; plot points forward
    PUSH AX             ; pass direction as argument
    MOV AL, 2           ; use y as first coordinate
    MOV AH, -1          ; use -x as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot first octant
    ADD SP, 10           ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN1         ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O2              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O2:
    MOV AX, 1           ; plot points backward
    PUSH AX             ; pass direction as argument
    MOV AL, 1           ; use x as first coordinate
    MOV AH, -2          ; use -y as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot second octant
    ADD SP, 10           ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN1         ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O3              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O3:
    MOV AX, 0           ; plot point forward
    PUSH AX             ; pass direction as argument
    MOV AL, -1          ; use -x as first coordinate
    MOV AH, -2          ; use -y as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot third octant
    ADD SP, 10          ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN1         ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O4              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O4:
    MOV AX, 1           ; plot points backwards
    PUSH AX             ; pass direction as argument
    MOV AL, -2          ; use -y as first coordinate
    MOV AH, -1          ; use -x as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot fourth octant
    ADD SP, 10          ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JG  NEXTOCT         ; if there are more points, go to next octant
RETURN1:
    JMP RETURN          ; if no more points, return
NEXTOCT:
    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O5              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O5:
    MOV AX, 0           ; plot point forward
    PUSH AX             ; pass direction as argument
    MOV AL, -2          ; use -y as first coordinate
    MOV AH, 1           ; use x as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot third octant
    ADD SP, 10          ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN          ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O6              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O6:
    MOV AX, 1           ; plot points backwards
    PUSH AX             ; pass direction as argument
    MOV AL, -1          ; use -x as first coordinate
    MOV AH, 2           ; use y as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot fourth octant
    ADD SP, 10          ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN          ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O7              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O7:
    MOV AX, 0           ; plot point forward
    PUSH AX             ; pass direction as argument
    MOV AL, 1           ; use x as first coordinate
    MOV AH, 2           ; use y as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot third octant
    ADD SP, 10          ; remove arguments from stack
    SUB BX, CX          ; decrement number of remaining points
    JLE RETURN          ; if no more points, return

    MOV CX, BX          ; copy number of points in CX
    CMP [NPOINTS], BX   ; compare points in octant with points in angle
    JG  O8              ; if angle is smaller, plot all points in angle
    MOV CX, [NPOINTS]   ; else plot all points in octant
O8:
    MOV AX, 1           ; plot points backwards
    PUSH AX             ; pass direction as argument
    MOV AL, 2           ; use y as first coordinate
    MOV AH, 1           ; use x as second coordinate
    PUSH AX             ; pass coords as argument
    MOV AX, [BP + 6]    ; load center y
    PUSH AX             ; pass center y as argument to function
    MOV AX, [BP + 4]    ; load center x
    PUSH AX             ; pass center x as argument
    PUSH CX             ; plot only CX points
    CALL DRAWOCTANT     ; plot fourth octant
    ADD SP, 10          ; remove arguments from stack

RETURN:
    POP DI              ; restore DI value from stack
    POP SI              ; restore SI value from stack
    POP DX              ; restore DX value from stack
    POP CX              ; restore CX value from stack
    POP BX              ; restore BX value from stack
    POP AX              ; restore AX value from stack
    POP BP              ; restore frame pointer
    RET                 ; return to caller
DRAWCIRCLE ENDP

; Function to draw a line, receives the following arguments in the stack:
; Coordinates of initial point x1, y1 and coordinates of end point x2, y2
; Uses the Bresenham Algorithm:
;  https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
DRAWLINE PROC
    PUSH BP             ; save frame pointer
    MOV BP, SP          ; point to new stack frame
    PUSH AX             ; save AX register in the stack
    PUSH BX             ; save BX register in the stack
    PUSH CX             ; save CX register in the stack
    PUSH DX             ; save DX register in the stack
    PUSH SI             ; save SI register in the stack
    PUSH DI             ; save DI register in the stack

    ; dx = abs(x2-x1)
    ; sx = x0<x1 ? 1 : -1;
    MOV BX, 1           ; sx = 1
    MOV DX, [BP + 8]    ; load third argument (x2)
    SUB DX, [BP + 4]    ; subtract first argument (x2 - x1)
    JG  L1              ; if subtraction is positive, go to L1
    NEG DX              ; else, make positive
    MOV BX, -1          ; set sx = -1
L1:
    ; dy = -abs(y1-y0);
    ; sy = y0<y1 ? 1 : -1;    
    MOV SI, 1           ; sy = 1
    MOV DI, [BP + 10]   ; load fourth argument (y2)
    SUB DI, [BP + 6]    ; subtract second argument (y2 - y1)
    JG  L2              ; if subtraction is positive, go to L2
    NEG DI              ; else, make positive
    MOV SI, -1          ; set sy = -1
L2:
    NEG DI              ; take negative to get -abs(y1-y0)

    ; err = dx+dy;
    MOV AX, DX          ; copy dx
    ADD AX, DI          ; add dy to get dx+dy 

    ; while (true)
L3:
    ; plot(x0, y0);
    MOV CX, [BP + 6]    ; load y1
    PUSH CX             ; pass as second argument to function
    MOV CX, [BP + 4]    ; load x1
    PUSH CX             ; pass as first argument to function
    CALL DRAWPOINT      ; draw the point using x1 and y1
    ADD SP, 4           ; remove arguments from stack

    ; if (x0 == x1 && y0 == y1) break;
    MOV CX, [BP + 4]    ; load x1
    CMP CX, [BP + 8]    ; compare with x2
    JNE L4              ; if x1 != x2, skip to L4
    MOV CX, [BP + 6]    ; load y1
    CMP CX, [BP + 10]   ; compare with y2
    JE  L6              ; if y1 == y2, end function
L4:
    ; e2 = 2*err;
    MOV CX, AX          ; copy err to CX
    SHL CX, 1           ; multiply by 2 using a shift left

    ; if (e2 >= dy)
    CMP CX, DI          ; compare e2 with dy
    JL  L5              ; if e2 < dy, go to L5
    
    ; if (x0 == x1) break;
    MOV AX, [BP + 4]    ; load x1
    CMP AX, [BP + 8]    ; compare with x2
    JE L6               ; if x1 == x2, end function

    ; err += dy;
    MOV AX, CX          ; copy e2 to AX
    SHR AX, 1           ; recover err dividing by 2 with a shift right
    ADD AX, DI          ; add dy to err
    
    ; x0 += sx;
    ADD [BP + 4], BX    ; add sx to x1
L5:
    ; if (e2 <= dx)
    CMP CX, DX          ; compare e2 with dx
    JG  L3              ; if e2 > dx, go to start of loop
    
    ; if (y0 == y1) break;
    MOV AX, [BP + 6]    ; load y1
    CMP AX, [BP + 10]   ; compare with y2
    JE L6               ; if y1 == y2, end function

    ; err += dx;
    MOV AX, CX          ; copy e2 to AX
    SHR AX, 1           ; recover err dividing by 2 with a shift right
    ADD AX, DX          ; add dx to err
    
    ; y0 += sy;
    ADD [BP + 6], SI    ; add sy to y1
    JMP L3              ; repeat loop
L6:
    POP DI              ; restore DI value from stack
    POP SI              ; restore SI value from stack
    POP DX              ; restore DX value from stack
    POP CX              ; restore CX value from stack
    POP BX              ; restore BX value from stack
    POP AX              ; restore AX value from stack
    POP BP              ; restore frame pointer
    RET                 ; return to caller
DRAWLINE ENDP

KODIKAS     ENDS

SOROS     SEGMENT STACK
    DW  256 DUP(0)    
SOROS     ENDS

END         ARXH
