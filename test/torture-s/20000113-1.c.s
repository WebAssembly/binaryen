	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000113-1.c"
	.section	.text.foobar,"ax",@progbits
	.hidden	foobar
	.globl	foobar
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 1
	i32.and 	$push11=, $0, $pop1
	tee_local	$push10=, $0=, $pop11
	i32.eqz 	$push14=, $pop10
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push0=, 3
	i32.and 	$push13=, $1, $pop0
	tee_local	$push12=, $1=, $pop13
	i32.sub 	$push2=, $pop12, $0
	i32.mul 	$push3=, $pop2, $1
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, 7
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foobar, .Lfunc_end0-foobar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 1
	i32.const	$push1=, 2
	i32.const	$push0=, 3
	i32.call	$drop=, foobar@FUNCTION, $pop2, $pop1, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
