#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Hint: Convert 1st operand to long int
  mov %r13, %rdi
  call atol 
  mov %rax, %r13
 
  # Hint: Convert 2nd operand to long int
  mov %r14, %rdi
  call atol
  mov %rax, %r14

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like mov 0(%r12), ???
  mov 0(%r12), %cl
  
  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }
      
  cmp $'+', %cl
  je addition

  cmp $'-', %cl
  je subtraction

  cmp $'*', %cl
  je multiplication

  cmp $'/', %cl
  je division

  jne bad_operation

  addition:
     add %r13, %r14
     mov %r14, %rsi
     jmp result

  subtraction:
     sub %r14, %r13
     mov %r13, %rsi
     jmp result

  multiplication:
     imul %r13, %r14
     mov %r14, %rsi  # actual value for printf stored in rsi
     jmp result

  division:
    cmp $0, %r14
    je division_by_zero
    movq %r13, %rax  # move dividend into rax
    cqto     # extend rax to rdx
    idivq %r14 # idiv is 128/64 bit division, need to extend dividend
    mov %rax, %rsi
    jmp result

  division_by_zero:
    mov $div_message, %rdi
    mov $0, %al
    call printf
    jmp end

  bad_operation:
     mov $bad_message, %rdi # "data type" in rdi
     mov $0, %al
     call printf
     jmp end

  result:
     mov $long_format, %rdi
     mov $0, %al
     call printf
     jmp end

  # Function epilogue
  end:
     leave
     ret


# Start of the data section
.data

long_format: 
  .asciz "%ld\n"
bad_message:
  .asciz "Unknown operation\n"
div_message:
 .asciz "Unable to do division by zero\n"
