	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100805-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.and 	$0=, $0, $pop0
	block   	
	i32.eqz 	$push5=, $1
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %for.body.preheader
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push4=, 1
	i32.rotl	$0=, $0, $pop4
	i32.const	$push3=, -1
	i32.add 	$push2=, $1, $pop3
	tee_local	$push1=, $1=, $pop2
	br_if   	0, $pop1        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

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
