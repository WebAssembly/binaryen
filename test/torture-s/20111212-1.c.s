	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111212-1.c"
	.section	.text.frob_entry,"ax",@progbits
	.hidden	frob_entry
	.globl	frob_entry
	.type	frob_entry,@function
frob_entry:                             # @frob_entry
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0):p2align=0
	i32.const	$push1=, 63
	i32.gt_u	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push3=, -1
	i32.store	0($0):p2align=0, $pop3
.LBB0_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	frob_entry, .Lfunc_end0-frob_entry

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push14=, $pop5, $pop6
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop7), $pop13
	i64.const	$push0=, 0
	i64.store	8($0), $pop0
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop12, $pop1
	call    	frob_entry@FUNCTION, $pop2
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
