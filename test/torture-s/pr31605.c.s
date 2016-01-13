	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31605.c"
	.section	.text.put_field,"ax",@progbits
	.hidden	put_field
	.globl	put_field
	.type	put_field,@function
put_field:                              # @put_field
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, -8
	block
	i32.add 	$push0=, $1, $0
	i32.or  	$push1=, $pop0, $2
	i32.ne  	$push2=, $pop1, $2
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.Lfunc_end0:
	.size	put_field, .Lfunc_end0-put_field

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
