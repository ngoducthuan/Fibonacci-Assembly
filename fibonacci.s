section .bss
    userInput resb 1

section .data
    message   db  "Fibonnacci Sequence: ", 0x0a
    len       equ $ - message
    outFormat db  "%d", 0x0a, 0x00
    inputFormat db "%d", 0x00

section .text
    global _start
    extern printf, scanf

_start:
    call printMessage
    call inputUser
    call initFib
    call loopFib
    call exitProgram
inputUser:
    sub     rsp, 8          ;align stack to 16 byte
    mov     rdi, inputFormat;set 1st parameter(inputFormat)
    mov     rsi, userInput  ;set 2st parameter
    call    scanf
    add     rsp, 8
    ret 

printFib:
    push    rax
    push    rbx
    mov     rdi, outFormat  ;set 1st argument (Print Format)
    mov     rsi, rbx        ;set 2nd argument (Fib Number)
    call    printf
    pop     rbx
    pop     rax
    ret

printMessage:
    ;Print message
    mov     rax, 1       ;rax syscall number 1(write)
    mov     rdi, 1       ;fd 1 for stdout
    mov     rsi, message ;pointer to message
    mov     rdx, len      ;leng of message
    syscall              ;call write syscall 
    ret

initFib:
    xor     rax, rax
    xor     rbx, rbx
    inc     rbx
    ret 

loopFib:
    call    printFib
    add     rax, rbx
    xchg    rax, rbx
    cmp     rbx, [userInput]
    js      loopFib
    ret

exitProgram:
    mov     rax, 60
    mov     rdi, 0
    syscall
    ret
