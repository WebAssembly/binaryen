	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040309-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push8=, 16
	i32.shr_s	$push2=, $pop1, $pop8
	i32.const	$push3=, -1
	i32.gt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %cond.true
	i32.const	$push5=, 32768
	i32.add 	$push6=, $0, $pop5
	i32.const	$push7=, 65535
	i32.and 	$1=, $pop6, $pop7
.LBB0_2:                                # %cond.end
	end_block                       # label0:
	copy_local	$push9=, $1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end16
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
