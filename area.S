.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    subq    $8, %rsp
    movl    %edi, %eax
    addl    %esi, %eax
    addl    %edx, %eax     #eax = a + b + c
    movl    %eax, %ecx
    shrl    $31, %ecx      #ecx = 1 if the sum is negative
    addl    %ecx, %eax
    sarl    $1, %eax       #p = (a + b + c) / 2

    movl    %eax, %ecx     #ecx = p
    movl    %ecx, %r8d
    subl    %edi, %r8d     #r8d = p - a
    imull   %r8d, %eax     #eax = p * (p-a)
    movl    %ecx, %r8d
    subl    %esi, %r8d     #r8d = p - b
    imull   %r8d, %eax     #eax *= (p-b)
    movl    %ecx, %r8d
    subl    %edx, %r8d     #r8d = p - c
    imull   %r8d, %eax     #eax *= (p-c)

    movl    %eax, %edi     #argument for r_sqrt
    call    r_sqrt         #eax = r_sqrt(p)
    addq    $8, %rsp
    retq

# r_sqrt: x in %edi; result in %eax
# %ebx holds x across the recursive call (callee-saved, so push/pop it)
r_sqrt:
    cmpl    $0, %edi                # if (x < 0) return -1
    jge     .Lsq_nonneg
    movl    $-1, %eax
    retq
.Lsq_nonneg:
    cmpl    $2, %edi                # if (x < 2) return x
    jge     .Lsq_recurse
    movl    %edi, %eax
    retq
.Lsq_recurse:
    pushq   %rbx                    # save %rbx (also aligns the stack)
    movl    %edi, %ebx              # ebx = x
    sarl    $2, %edi                # argument = x >> 2
    call    r_sqrt                  # eax = r_sqrt(x >> 2)
    sall    $1, %eax                # small_cand = r_sqrt(x >> 2) << 1
    leal    1(%eax), %ecx           # large_cand = small_cand + 1
    movl    %ecx, %edx
    imull   %ecx, %edx              # edx = large_cand * large_cand
    cmpl    %ebx, %edx              # if (large_cand^2 > x) return small_cand
    jg      .Lsq_done
    movl    %ecx, %eax              # else return large_cand
.Lsq_done:
    popq    %rbx     #restore %rbx
    retq

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
