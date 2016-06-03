	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36339.c"
	.section	.text.try_a,"ax",@progbits
	.hidden	try_a
	.globl	try_a
	.type	try_a,@function
try_a:                                  # @try_a
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push14=, __stack_pointer($pop6), $pop12
	tee_local	$push13=, $1=, $pop14
	i32.const	$push0=, 0
	i32.store	$drop=, 12($pop13), $pop0
	i32.store	$drop=, 8($1), $0
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop11, $pop1
	i32.call	$0=, check_a@FUNCTION, $pop2
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $1, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
	copy_local	$push15=, $0
                                        # fallthrough-return: $pop15
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
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 42
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.const	$1=, 0
	i32.load	$push5=, 3($0)
	i32.eqz 	$push6=, $pop5
	br_if   	1, $pop6        # 1: down to label0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	i32.const	$1=, -1
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	copy_local	$push7=, $1
                                        # fallthrough-return: $pop7
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
	br_if   	0, $pop3        # 0: down to label2
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
	.functype	abort, void
