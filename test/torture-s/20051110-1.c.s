	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051110-1.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.eqz 	$push14=, $pop6
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, bytes
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push13=, 128
	i32.or  	$push4=, $0, $pop13
	i32.const	$push12=, 127
	i32.and 	$push3=, $0, $pop12
	i32.const	$push11=, 7
	i32.shr_u	$push10=, $0, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.select	$push5=, $pop4, $pop3, $pop9
	i32.store8	0($2), $pop5
	i32.const	$push8=, 1
	i32.add 	$2=, $2, $pop8
	copy_local	$0=, $1
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	add_unwind_adjustsp, .Lfunc_end0-add_unwind_adjustsp

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1928
	i32.store16	bytes($pop1):p2align=0, $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	bytes                   # @bytes
	.type	bytes,@object
	.section	.bss.bytes,"aw",@nobits
	.globl	bytes
bytes:
	.skip	5
	.size	bytes, 5


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
