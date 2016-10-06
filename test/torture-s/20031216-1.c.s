	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031216-1.c"
	.section	.text.DisplayNumber,"ax",@progbits
	.hidden	DisplayNumber
	.globl	DisplayNumber
	.type	DisplayNumber,@function
DisplayNumber:                          # @DisplayNumber
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 154
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	DisplayNumber, .Lfunc_end0-DisplayNumber

	.section	.text.ReadNumber,"ax",@progbits
	.hidden	ReadNumber
	.globl	ReadNumber
	.type	ReadNumber,@function
ReadNumber:                             # @ReadNumber
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10092544
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	ReadNumber, .Lfunc_end1-ReadNumber

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
