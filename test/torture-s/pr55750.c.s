	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55750.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, arr
	i32.add 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.load8_u	$push3=, 0($0)
	i32.const	$push5=, 2
	i32.add 	$push4=, $pop3, $pop5
	i32.store8	0($pop6), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push1=, 254
	i32.store8	arr+4($pop13), $pop1
	i32.const	$push12=, 0
	i32.const	$push2=, 127
	i32.store8	arr($pop12), $pop2
	i32.const	$push11=, 0
	call    	foo@FUNCTION, $pop11
	i32.const	$push3=, 1
	call    	foo@FUNCTION, $pop3
	block   	
	i32.const	$push10=, 0
	i32.load8_u	$push4=, arr($pop10)
	i32.const	$push5=, 129
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push14=, 0
	i32.load8_u	$push0=, arr+4($pop14)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop0, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.p2align	2
arr:
	.skip	8
	.size	arr, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
