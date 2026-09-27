.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movb    %dil, %al  #al = a
  salb    $3, %al    #al = a * 8   (8-bit, wraps like a char)
  subb    %dil, %al  #al = a*8 - a = 7*a  -> mult

  movb    $0, (%rsi)  #assume *overflow = 0
  cmpb    $0, %dil
  jg      .Lm_apos
  jl      .Lm_aneg
  jmp     .Lm_div     #a == 0: no overflow
.Lm_apos:
  cmpb    $0, %al
  jge     .Lm_div     #mult >= 0: fine
  movb    $1, (%rsi)  #a > 0 but mult < 0: overflow
  jmp     .Lm_div
.Lm_aneg:
  cmpb    $0, %al
  jle     .Lm_div     #mult <= 0: fine
  movb    $1, (%rsi)  #a < 0 but mult > 0: overflow

.Lm_div:
  testb   %al, %al
  jns     .Lm_shift
  addb    $7, %al
.Lm_shift:
  sarb    $3, %al     #al = mult / 8
  movsbl  %al, %eax   #sign-extend result into %eax
  ret


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
