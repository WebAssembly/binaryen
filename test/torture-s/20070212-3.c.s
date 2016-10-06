	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.select	$push5=, $0, $pop1, $2
	tee_local	$push4=, $4=, $pop5
	i32.load	$2=, 0($pop4)
	i32.const	$push2=, 1
	i32.store	0($0), $pop2
	block   	
	i32.eqz 	$push6=, $3
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then3
	i32.load	$1=, 0($4)
.LBB0_2:                                # %if.end5
	end_block                       # label0:
	i32.add 	$push3=, $1, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
