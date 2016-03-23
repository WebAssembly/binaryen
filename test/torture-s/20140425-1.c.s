	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140425-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $1
	i32.const	$push14=, 12
	i32.add 	$push15=, $1, $pop14
	call    	set@FUNCTION, $pop15
	i32.const	$push0=, 2
	i32.load	$push6=, 12($1)
	tee_local	$push5=, $0=, $pop6
	i32.shl 	$push1=, $pop0, $pop5
	i32.store	$discard=, 12($1), $pop1
	block
	i32.const	$push2=, 30
	i32.le_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.set,"ax",@progbits
	.type	set,@function
set:                                    # @set
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set


	.ident	"clang version 3.9.0 "
