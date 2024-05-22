; _Z51UP_ram_sim_28DATA_WIDTH_3d1_2cDEPT_WIDTH_3d184_29_0phh
subq $8, %rsp
movb %sil, 0x40(%rdi)
call P_ram_sim_28DATA_WIDTHH_3d1_2cDEPT_WIDTH_3d184_29_0(unsigned char*)
addq $8, %rsp
ret
nop %cs:0(%rax, %rax)
nop 0(%rax)

;P_ram_sim_28DATA_WIDTHH_3d1_2cDEPT_WIDTH_3d184_29_0
pushq %rbx
pushq %r12
subq $8, %rsp
movq %rdi, %rbx
movzbl 0x40(%rbx), %r12d
movzbl 0x41(%rbx), %eax
cmpq %rax, %r12
jne .+0xa   0x1d4e1a80
addq $8, %rsp ;[a78]
popq %r12
popq %rbx
ret
andq $3, %rax ;[a80]
movq %r12, %rcx
andq $3, %rcx
leal (%rcx, %rax, 4), %eax
addq 0x1b5e9283(%rip), %rax
movzbl (%rax), %eax
cmpq $1, %rax
je .+8  ;0x1d4e1aa4
movb %r12b, 0x41(%rbx)  ;[a9e]
jmp .-0x2a 0x1d4e1a78
movzbl 0x78a(%rbx), %eax ;[aa4]
cmpq $0, %rax
je .-0x11 ;0x1d4e1a9e
movb $0, 0x78a(%rbx)
leaq 0x730(%rbx), %rax
movq %rax, %rdi
call ScheduleNEBTbrgnlNoDelay
jmp .-0x29 ;0x1d4e1a9e
nop 0(%rax)
