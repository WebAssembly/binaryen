	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39233.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, 7
	i32.ge_s	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push0=, 6
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 5
	call    	foo@FUNCTION, $pop1
	i32.const	$push2=, 4
	call    	foo@FUNCTION, $pop2
	i32.const	$push3=, 3
	call    	foo@FUNCTION, $pop3
	i32.const	$push4=, 2
	call    	foo@FUNCTION, $pop4
	i32.const	$push5=, 1
	call    	foo@FUNCTION, $pop5
	i32.const	$push6=, 0
	call    	foo@FUNCTION, $pop6
	i32.const	$push7=, 0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
