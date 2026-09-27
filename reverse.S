.global reverse
# list in %rdi (array of char*), n in %esi

reverse:
  movl    %esi, %esi #zero-extend n to 64 bits (unsigned)
  movq    %rsi, %r9
  shrq    $1, %r9    #r9 = n/2 (unsigned divide by 2)
  xorq    %r8, %r8   #i = 0
.Lrev_loop:
  cmpq    %r9, %r8    #while (i < n/2)
  jae     .Lrev_done
  movq    %rsi, %r10
  subq    %r8, %r10
  decq    %r10                  #j = n - i - 1
  movq    (%rdi,%r8,8), %rax    #temp = list[i]
  movq    (%rdi,%r10,8), %rcx   #rcx = list[j]
  movq    %rcx, (%rdi,%r8,8)    #list[i] = list[j]
  movq    %rax, (%rdi,%r10,8)   #list[j] = temp
  incq    %r8                   #i++
  jmp     .Lrev_loop
.Lrev_done:
  retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
