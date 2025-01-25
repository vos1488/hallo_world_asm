; filepath: /Users/vos9/Desktop/asm/hello.asm
; Улучшенная программа для macOS (x86_64)
; Кодировка: UTF-8

; Макросы для цветного вывода
%define RED     27,"[31m"
%define GREEN   27,"[32m"
%define RESET   27,"[0m"

global _main
default rel

section .data align=8
    msg1 db RED, "Привет", RESET, 0xa
    msg1_len equ $ - msg1
    
    msg2 db GREEN, "мир!", RESET, 0xa
    msg2_len equ $ - msg2
    
    error_msg db "Ошибка вывода!", 0xa
    error_len equ $ - error_msg

section .text align=16
_main:
    push    rbp
    mov     rbp, rsp
    
    ; Вывод первой части
    mov     rax, 0x2000004     ; write
    mov     rdi, 1             ; stdout
    lea     rsi, [msg1]
    mov     rdx, msg1_len
    syscall
    
    ; Проверка ошибок
    test    rax, rax
    js      error_exit
    
    ; Небольшая пауза
    push    rax                ; сохраняем результат
    mov     rax, 0x2000093     ; usleep
    mov     rdi, 500000        ; 0.5 секунды
    syscall
    pop     rax                ; восстанавливаем результат
    
    ; Вывод второй части
    mov     rax, 0x2000004
    mov     rdi, 1
    lea     rsi, [msg2]
    mov     rdx, msg2_len
    syscall
    
    ; Успешный выход
    mov     rax, 0
    jmp     exit

error_exit:
    ; Вывод сообщения об ошибке
    mov     rax, 0x2000004
    mov     rdi, 2             ; stderr
    lea     rsi, [error_msg]
    mov     rdx, error_len
    syscall
    mov     rax, 1            ; код ошибки

exit:
    mov     rsp, rbp
    pop     rbp
    ret