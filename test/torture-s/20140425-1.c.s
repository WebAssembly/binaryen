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
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	i32.store	$push18=, 0($pop8), $pop14
	tee_local	$push17=, $1=, $pop18
	i32.const	$push12=, 12
	i32.add 	$push13=, $pop17, $pop12
	call    	set@FUNCTION, $pop13
	i32.const	$push0=, 2
	i32.load	$push16=, 12($1)
	tee_local	$push15=, $0=, $pop16
	i32.shl 	$push1=, $pop0, $pop15
	i32.store	$discard=, 12($1), $pop1
	block
	i32.const	$push2=, 30
	i32.le_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	$discard=, 0($pop11), $pop10
	i32.const	$push4=, 0
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
