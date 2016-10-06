	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921013-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push9=, $3
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	f32.load	$push1=, 0($1)
	f32.load	$push0=, 0($2)
	f32.eq  	$push2=, $pop1, $pop0
	i32.store	0($0), $pop2
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, 4
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 4
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, -1
	i32.add 	$push4=, $3, $pop5
	tee_local	$push3=, $3=, $pop4
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
	copy_local	$push10=, $0
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.3
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
