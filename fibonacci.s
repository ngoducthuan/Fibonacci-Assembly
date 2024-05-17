SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT    equ 1
STDIN     equ 2

section .data
    msg         db "Enter number to find list Fibonacci: ", 0xa
    len         equ $ - msg
    msg1        db "List Fibonacci: "
    len1        equ $ - msg1
    sep         db ", "
    len_sep     equ $ - sep    

section .bss
    num_limit   resb 4
    num_next    resb 4
    num1        resb 4
    num2        resb 4
    num         resb 4
    buffer      resb 4
section .text
    global  _start
_start:
    ;Print message
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    mov     ecx, msg
    mov     edx, len
    int     0x80

    ;Input user
    mov     eax, SYS_READ
    mov     ebx, STDIN
    mov     ecx, num
    mov     edx, 4
    int     0x80

    ; Convert user input from ASCII to integer
    call    atoi
    mov     [num_limit], eax

    ; Print message 1
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    mov     ecx, msg1
    mov     edx, len1
    int     0x80

    ; Initialize first two Fibonacci numbers
    mov     dword [num1], 1
    mov     dword [num2], 1

print_fibonacci:
    ; Convert and print the first number
    mov     eax, [num1]
    call    itoa
    call    print_buffer

    ; Print separator
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    mov     ecx, sep
    mov     edx, len_sep
    int     0x80

    ; Convert and print the second number
    mov     eax, [num2]
    call    itoa
    call    print_buffer

l1:
    ;Calculate next number
    mov     eax, [num1]
    add     eax, [num2]
    mov     [num_next], eax

    ; Check if the next number is greater than or equal to the user input
    cmp     eax, [num_limit]
    jge     end_fibonacci

    ;Prepare for next interation 
    mov     eax, [num2]
    mov     [num1], eax
    mov     eax, [num_next]
    mov     [num2], eax

    ;Print , to separate number
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    mov     ecx, sep
    mov     edx, len_sep
    int     0x80

    ; Convert and print the next number
    mov     eax, [num_next]
    call    itoa
    call    print_buffer

    jmp     l1

end_fibonacci:
    mov     eax, SYS_EXIT
    int     0x80

;Convert ASCII to interger
atoi:
    mov     ebx, num         ; Point to the input buffer
    xor     eax, eax         ; Clear EAX (result)
    xor     ecx, ecx         ; Clear ECX (multiplier)

atoi_loop:
    mov     cl, [ebx]        ; Load next byte into CL
    cmp     cl, 0            ; Check for null terminator
    je      atoi_done        ; If null, end of string
    sub     cl, '0'          ; Convert ASCII to integer
    imul    eax, eax, 10     ; Multiply result by 10
    add     eax, ecx         ; Add current digit
    inc     ebx              ; Move to next character
    jmp     atoi_loop        ; Repeat

atoi_done:
    ret

; Convert integer to ASCII (itoa)
itoa:
    mov     edi, buffer + 3 ; Point EDI to the end of the buffer
    mov     ecx, 10          ; Set divisor to 10
    xor     edx, edx         ; Clear EDX

itoa_loop:
    xor     edx, edx         ; Clear EDX before division
    div     ecx              ; Divide EAX by 10
    add     dl, '0'          ; Convert remainder to ASCII
    dec     edi              ; Move back in the buffer
    mov     [edi], dl        ; Store character
    test    eax, eax         ; Check if EAX is zero
    jnz     itoa_loop        ; If not, continue

    mov     eax, edi         ; Return pointer to string
    ret

; Print null-terminated string from EAX
print_buffer:
    mov     edx, buffer + 4 ; Calculate buffer end
    sub     edx, eax         ; Calculate length of string
    mov     ecx, eax         ; Set ECX to the buffer start
    mov     eax, SYS_WRITE
    mov     ebx, STDOUT
    int     0x80
    ret
