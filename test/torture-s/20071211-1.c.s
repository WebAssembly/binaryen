	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071211-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$1=, sv($0)
	i64.const	$2=, -1099511627776
	i64.or  	$1=, $1, $2
	i64.store	$discard=, sv($0), $1
	#APP
	#NO_APP
	i64.load	$1=, sv($0)
	i64.const	$2=, 40
	block
	i64.shr_u	$push0=, $1, $2
	i64.const	$push1=, 1
	i64.add 	$3=, $pop0, $pop1
	i64.shl 	$push2=, $3, $2
	i64.const	$push3=, 1099511627775
	i64.and 	$push4=, $1, $pop3
	i64.or  	$push5=, $pop2, $pop4
	i64.store	$discard=, sv($0), $pop5
	i64.const	$push6=, 16777215
	i64.and 	$push7=, $3, $pop6
	i64.const	$push8=, 0
	i64.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	sv                      # @sv
	.type	sv,@object
	.section	.bss.sv,"aw",@nobits
	.globl	sv
	.align	3
sv:
	.skip	8
	.size	sv, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
