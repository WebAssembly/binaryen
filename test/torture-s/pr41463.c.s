	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41463.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 24
	i32.add 	$push10=, $pop2, $pop3
	tee_local	$push9=, $1=, $pop10
	i32.const	$push4=, 0
	i32.store	0($pop9), $pop4
	i32.const	$push5=, 28
	i32.add 	$push6=, $0, $pop5
	i32.const	$push7=, global
	i32.store	0($pop6), $pop7
	i32.load	$push8=, 0($1)
                                        # fallthrough-return: $pop8
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
	block   	
	i32.const	$push0=, 76
	i32.call	$push1=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 1
	i32.call	$push3=, foo@FUNCTION, $pop1, $pop2
	i32.const	$push4=, global
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.skip	76
	.size	global, 76


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	abort, void
