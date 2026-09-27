.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)

isPrime:
  cmpl    $2, %edi    #if (n < 2) return 0
  jl      .Lp_no
  testl   $1, %edi    #if (n % 2 == 0) return n == 2
  jnz     .Lp_odd
  xorl    %eax, %eax
  cmpl    $2, %edi
  sete    %al
  ret
.Lp_odd:
  movl    $3, %ecx    #i = 3
.Lp_loop:
  movl    %ecx, %eax
  imull   %ecx, %eax  #eax = i * i
  cmpl    %edi, %eax  #while (i*i <= n)
  jg      .Lp_yes
  movl    %edi, %eax
  cltd    
  idivl   %ecx          #edx = n % i
  testl   %edx, %edx
  jz      .Lp_no
  addl    $2, %ecx      #i += 2
  jmp     .Lp_loop
.Lp_yes:
  movl    $1, %eax
  ret
.Lp_no:
  xorl    %eax, %eax
  ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
