; Developed for Intel syntax NASM on x86_64 Linux
; Generates a key in 'keyfile' using basic pseudo-random number generation
; Reads data from file 'message' and offsets every byte by the value of key
; Stores the result in file 'encrypted'
global _start

section .text
	
_start:
    ;open infile for reading
    mov rax,2
    mov rdi,infile
    mov rsi,0
    mov rdx,0
    syscall
    ;ifd will hold infile descriptor
    mov [ifd],rax
    
    ;open the keyfile for replacement or creation
    mov rax,2
    mov rdi,keyfile
    mov rsi,0q1101
    mov rdx,0q666
    syscall
    ;kfd will hold the keyfile descriptor
    mov [kfd],rax

    ;generate the key
    ;this is a fairly basic program with no expectation of security,
    ;so whatever looks pseudo-random is good enough
    ;let's use the basic mod((time())
    ;this uses the lowest byte (seconds mod 256) for the key
    mov rax,201
    mov rdi,time
    syscall

    ;store the key
    mov r8,[time]
    mov [key],r8b
    
    ;write key to keyfile
    mov rax,1
    mov rdi,[kfd]
    mov rsi,time
    mov rdx,1
    syscall

    ;close keyfile
    mov rdi,[kfd]
    mov rax,3
    syscall

    ;open the outfile for replacement or creation
    mov rax,2
    mov rdi,outfile
    mov rsi,0q1101
    mov rdx,0q666
    syscall
    ;ofd will now hold the outfile descriptor
    mov [ofd],rax

IOLoop:

    ;read from the infile
    mov rax,0
    mov rdi,[ifd]
    mov rsi,buffer
    mov rdx,128
    syscall
    
    ;save to check for eof
    mov [eofcheck],al

    ;now loop over buffer to apply key
    mov r8,0
    BufferLoop:
        mov r9b,[buffer+r8]
        add r9b,[key]
        mov [buffer+r8],r9b
        inc r8
        cmp r8,128
        jne BufferLoop

    ;write to the outfile
    mov rax,1
    mov rdi,[ofd]
    mov rsi,buffer
    mov rdx,128
    syscall

    xor r12,r12
    mov r12b,[eofcheck]
    cmp r12,128
    jne IOLoopExit
    jmp IOLoop

IOLoopExit:

    ;close outfile
    mov rdi,[ofd]
    mov rax,3
    syscall

    ;close infile
    mov rdi,[ifd]
    mov rax,3
    syscall

    ;exit
    mov rax,60
    mov rdi,0
    syscall

section .data
    ;store basic variables: filenames, key, and time variable
    infile: db 'message',0
    keyfile: db 'keyfile',0
    outfile: db 'encrypted',0
    time: dq 0x0
    key: db 0
    ; IO buffer
    buffer: times 128 db 0
    eofcheck: db 0
    ;file descriptors
    ifd: dq 0
    ofd: dq 0
    kfd: dq 0
