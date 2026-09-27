.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  xorl    %ecx, %ecx   #lo = 0
  movl    %esi, %r8d
  decl    %r8d         #hi = (int)n - 1
.Lbs_loop:
  cmpl    %r8d, %ecx        #while (lo <= hi)
  jg      .Lbs_notfound
  movl    %r8d, %eax
  subl    %ecx, %eax           #eax = hi - lo  
  sarl    $1, %eax             #eax = (hi - lo) / 2
  addl    %ecx, %eax           #mid = lo + (hi - lo) / 2
  movslq  %eax, %r9
  movl    (%rdi,%r9,4), %r10d  #r10d = arr[mid]
  cmpl    %edx, %r10d
  je      .Lbs_found       #arr[mid] == target
  jl      .Lbs_right       #arr[mid] < target
  leal    -1(%eax), %r8d   #else hi = mid - 1
  jmp     .Lbs_loop
.Lbs_right:
  leal    1(%eax), %ecx    #lo = mid + 1
  jmp     .Lbs_loop
.Lbs_found:
  ret
.Lbs_notfound:
  movl    $-1, %eax   #return -1
  ret


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
