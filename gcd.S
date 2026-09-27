.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    movl    %edi, %eax  #eax = a
    testl   %esi, %esi  #if (b == 0) return a
    je      .Lgcd_done
    subq    $8, %rsp
    cltd
    idivl   %esi          #edx = a % b
    movl    %esi, %edi    #1st arg = b
    movl    %edx, %esi    #2nd arg = a % b
    call    gcd           #eax = gcd(b, a % b)
    addq    $8, %rsp
.Lgcd_done:
    retq


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
