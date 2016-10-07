	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20061101-1.c"
	.section	.text.tar,"ax",@progbits
	.hidden	tar
	.globl	tar
	.type	tar,@function
tar:                                    # @tar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 36863
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, -1
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	tar, .Lfunc_end0-tar

	.section	.text.bug,"ax",@progbits
	.hidden	bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$2=, $0, $pop0
	i32.const	$0=, 0
	i32.const	$3=, 1
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push6=, 1
	i32.and 	$push1=, $3, $pop6
	i32.eqz 	$push11=, $pop1
	br_if   	1, $pop11       # 1: down to label1
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$3=, 0
	i32.const	$push10=, 1
	i32.add 	$push3=, $0, $pop10
	i32.lt_s	$push2=, $0, $2
	i32.select	$push9=, $pop3, $2, $pop2
	tee_local	$push8=, $0=, $pop9
	i32.mul 	$push4=, $pop8, $1
	i32.const	$push7=, 36863
	i32.eq  	$push5=, $pop4, $pop7
	br_if   	0, $pop5        # 0: up to label2
# BB#3:                                 # %if.then.i
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %while.end
	end_block                       # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bug.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
