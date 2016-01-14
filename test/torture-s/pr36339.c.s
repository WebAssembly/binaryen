	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36339.c"
	.section	.text.try_a,"ax",@progbits
	.hidden	try_a
	.globl	try_a
	.type	try_a,@function
try_a:                                  # @try_a
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$discard=, 8($4), $0
	i32.const	$push0=, 0
	i32.store	$discard=, 12($4), $pop0
	i32.const	$push1=, 1
	i32.const	$4=, 8
	i32.add 	$4=, $4, $4
	i32.or  	$push2=, $4, $pop1
	i32.call	$push3=, check_a@FUNCTION, $pop2
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	try_a, .Lfunc_end0-try_a

	.section	.text.check_a,"ax",@progbits
	.hidden	check_a
	.globl	check_a
	.type	check_a,@function
check_a:                                # @check_a
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	block
	block
	i32.add 	$push0=, $0, $1
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 42
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.const	$2=, 0
	i32.load	$push4=, 3($0)
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, 1        # 1: down to label0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	copy_local	$2=, $1
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	check_a, .Lfunc_end1-check_a

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 42
	i32.call	$push1=, try_a@FUNCTION, $pop0
	i32.const	$push2=, -1
	i32.le_s	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
