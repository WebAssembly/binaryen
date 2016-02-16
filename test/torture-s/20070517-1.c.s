	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070517-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.call	$push12=, get_kind@FUNCTION
	tee_local	$push11=, $0=, $pop12
	i32.const	$push2=, 10
	i32.gt_u	$push3=, $pop11, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop4, $0
	i32.const	$push6=, 1568
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop7, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#2:                                 # %if.then.i
	i32.const	$push1=, -9
	i32.add 	$push0=, $0, $pop1
	i32.const	$push8=, 2
	i32.ge_u	$push9=, $pop0, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_3:                                # %example.exit
	end_block                       # label1:
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_4:                                # %if.else.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.get_kind,"ax",@progbits
	.type	get_kind,@function
get_kind:                               # @get_kind
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 10
	i32.store	$discard=, 12($3), $pop0
	i32.load	$push1=, 12($3)
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	get_kind, .Lfunc_end1-get_kind


	.ident	"clang version 3.9.0 "
