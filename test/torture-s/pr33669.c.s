	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33669.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i32
	.result 	i64
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i64.const	$5=, -1
	block   	
	i32.load	$push17=, 0($0)
	tee_local	$push16=, $3=, $pop17
	i32.add 	$push0=, $2, $3
	i64.extend_u/i32	$push1=, $3
	i64.rem_s	$push15=, $1, $pop1
	tee_local	$push14=, $4=, $pop15
	i32.wrap/i64	$push2=, $pop14
	i32.add 	$push3=, $pop0, $pop2
	i32.const	$push4=, -1
	i32.add 	$push13=, $pop3, $pop4
	tee_local	$push12=, $2=, $pop13
	i32.rem_u	$push5=, $2, $3
	i32.sub 	$push6=, $pop12, $pop5
	i32.lt_u	$push7=, $pop16, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i64.sub 	$5=, $1, $4
	i32.load	$push8=, 4($0)
	i32.le_u	$push9=, $pop8, $3
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.then13
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.store	0($pop11), $3
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	copy_local	$push18=, $5
                                        # fallthrough-return: $pop18
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
