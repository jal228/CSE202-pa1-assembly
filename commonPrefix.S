.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax

commonPrefix:
  xorq    %rax, %rax            #n = 0
.Lcp_loop:
  movzbl  (%rdi,%rax), %ecx     #ecx = a[n]
  testl   %ecx, %ecx
  je      .Lcp_done
  movzbl  (%rsi,%rax), %edx     #edx = b[n]
  cmpl    %edx, %ecx
  jne     .Lcp_done
  incq    %rax                  #n++
  jmp     .Lcp_loop
.Lcp_done:
  retq   


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
