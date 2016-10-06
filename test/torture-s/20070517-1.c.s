	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070517-1.c"
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
	i32.const	$push0=, 10
	i32.gt_u	$push1=, $pop11, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.shl 	$push3=, $pop2, $0
	i32.const	$push4=, 1568
	i32.and 	$push5=, $pop3, $pop4
	i32.eqz 	$push13=, $pop5
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.then.i
	i32.const	$push6=, -9
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, 2
	i32.ge_u	$push9=, $pop7, $pop8
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 10
	i32.store	12($pop5), $pop0
	i32.load	$push1=, 12($0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	get_kind, .Lfunc_end1-get_kind


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
