	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040625-1.c"
	.section	.text.maybe_next,"ax",@progbits
	.hidden	maybe_next
	.globl	maybe_next
	.type	maybe_next,@function
maybe_next:                             # @maybe_next
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.eqz 	$push0=, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load	$0=, 0($0):p2align=0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	maybe_next, .Lfunc_end0-maybe_next

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push10=, $pop5, $pop6
	i32.store	$push14=, __stack_pointer($pop7), $pop10
	tee_local	$push13=, $0=, $pop14
	i32.store	$push12=, 8($pop13), $0
	tee_local	$push11=, $0=, $pop12
	i32.const	$push8=, 8
	i32.add 	$push9=, $0, $pop8
	i32.const	$push0=, 1
	i32.call	$push1=, maybe_next@FUNCTION, $pop9, $pop0
	i32.ne  	$push2=, $pop11, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
