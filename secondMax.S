.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
#first is kept in %eax, second in %r8d (32 bits)
secondMax:
  movswl  %di, %edi 
  movswl  %si, %esi
  movswl  %dx, %edx
  movswl  %cx, %ecx

  # if (v1 >= v2) { first = v1; second = v2; } else { first = v2; second = v1; }
  movl    %edi, %eax   #first  = v1
  movl    %esi, %r8d   #second = v2
  cmpl    %esi, %edi   #compare v1 with v2
  jge     .Lsm_v3      #v1 >= v2: keep as is
  movl    %esi, %eax   #first  = v2
  movl    %edi, %r8d   #second = v1

.Lsm_v3:
  # if (v3 > first) { second = first; first = v3; } else if (v3 > second) second = v3;
  cmpl    %eax, %edx
  jle     .Lsm_v3_second
  movl    %eax, %r8d     #second = first
  movl    %edx, %eax     #first  = v3
  jmp     .Lsm_v4
.Lsm_v3_second:
  cmpl    %r8d, %edx
  jle     .Lsm_v4
  movl    %edx, %r8d  #second = v3

.Lsm_v4:
  # same logic for v4
  cmpl    %eax, %ecx
  jle     .Lsm_v4_second
  movl    %eax, %r8d  #second = first
  movl    %ecx, %eax  #first  = v4
  jmp     .Lsm_done
.Lsm_v4_second:
  cmpl    %r8d, %ecx
  jle     .Lsm_done
  movl    %ecx, %r8d #second = v4

.Lsm_done:
  movl    %r8d, %eax #return second (low 16 bits in %ax)
  retq

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
