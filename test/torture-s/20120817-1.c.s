	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120817-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, foo($pop0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i64.extend_s/i32	$push4=, $pop3
	i64.const	$push5=, 24
	i64.mul 	$push6=, $pop4, $pop5
	i64.const	$push7=, 40
	i64.add 	$push8=, $pop6, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.call	$push1=, f@FUNCTION
	i64.const	$push0=, 16
	i64.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	2
foo:
	.int32	0                       # 0x0
	.size	foo, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
