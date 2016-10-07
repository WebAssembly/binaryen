	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35456.c"
	.section	.text.not_fabs,"ax",@progbits
	.hidden	not_fabs
	.globl	not_fabs
	.type	not_fabs,@function
not_fabs:                               # @not_fabs
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.neg 	$push2=, $0
	f64.const	$push0=, 0x0p0
	f64.ge  	$push1=, $0, $pop0
	f64.select	$push3=, $0, $pop2, $pop1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	not_fabs, .Lfunc_end0-not_fabs

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, -0x0p0
	f64.call	$push1=, not_fabs@FUNCTION, $pop0
	i64.reinterpret/f64	$push2=, $pop1
	i64.const	$push3=, 0
	i64.ge_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
