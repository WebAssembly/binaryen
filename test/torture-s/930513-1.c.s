	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930513-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 8
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$push0=, 4617315517961601024
	i64.store	$discard=, 0($7), $pop0
	i32.const	$push2=, buf
	i32.const	$push1=, .L.str
	i32.call_indirect	$discard=, $0, $pop2, $pop1
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 8
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$7=, 16
	i32.add 	$7=, $7, $7
	i32.const	$7=, __stack_pointer
	i32.store	$7=, 0($7), $7
	return  	$0
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 8
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$push1=, 4617315517961601024
	i64.store	$discard=, 0($7), $pop1
	i32.const	$push3=, buf
	i32.const	$push2=, .L.str
	i32.call	$discard=, sprintf, $pop3, $pop2
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 8
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$0=, 0
	block   	.LBB1_3
	i32.load8_u	$push4=, buf($0)
	i32.const	$push5=, 53
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB1_3
# BB#1:                                 # %entry
	i32.load8_u	$push0=, buf+1($0)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop0, $pop7
	br_if   	$pop8, .LBB1_3
# BB#2:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB1_3:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
buf:
	.skip	2
	.size	buf, 2

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%.0f"
	.size	.L.str, 5


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
