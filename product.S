.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx

#i in %r8d
product:
    xorl    %r8d, %r8d  #i = 0
.Lprod_loop:
    cmpl    %ecx, %r8d            #while (i < size), unsigned compare
    jae     .Lprod_done
    movss   (%rdi,%r8,4), %xmm0   #xmm0 = a[i]
    mulss   (%rsi,%r8,4), %xmm0   #xmm0 = a[i] * b[i]
    movss   %xmm0, (%rdx,%r8,4)   #c[i] = xmm0
    incl    %r8d                  #i++ (also zero-extends into %r8)
    jmp     .Lprod_loop
.Lprod_done:
    ret
    

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
