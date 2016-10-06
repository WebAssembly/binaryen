	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37125.c"
	.section	.text.func_44,"ax",@progbits
	.hidden	func_44
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -9
	i32.mul 	$push7=, $0, $pop0
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 9
	i32.add 	$push3=, $0, $pop2
	i32.const	$push5=, -9
	i32.lt_u	$push1=, $0, $pop5
	i32.select	$push4=, $pop6, $pop3, $pop1
	i32.eqz 	$push8=, $pop4
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	func_44, .Lfunc_end0-func_44

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
