	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071018-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.call	$push1=, __builtin_malloc@FUNCTION, $pop0
	i32.store	0($0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 16
	i32.call	$push3=, __builtin_malloc@FUNCTION, $pop2
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push5=, -20
	i32.add 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i32.const	$push6=, 0
	i32.store	0($pop8), $pop6
	call    	bar@FUNCTION, $0
	i32.load	$push7=, 0($0)
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.eqz 	$push3=, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	__builtin_malloc, i32
	.functype	abort, void
