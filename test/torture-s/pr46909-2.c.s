	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46909-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 13
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$1=, 1
	br_if   	1, $0           # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$1=, -1
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push2=, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -10
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.call	$push6=, foo@FUNCTION, $0
	i32.const	$push13=, 1
	i32.eqz 	$push2=, $0
	i32.const	$push12=, 1
	i32.shl 	$push3=, $pop2, $pop12
	i32.sub 	$push4=, $pop13, $pop3
	i32.const	$push11=, 13
	i32.eq  	$push0=, $0, $pop11
	i32.const	$push10=, 1
	i32.shl 	$push1=, $pop0, $pop10
	i32.sub 	$push5=, $pop4, $pop1
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	1, $pop7        # 1: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 1
	i32.add 	$push16=, $0, $pop17
	tee_local	$push15=, $0=, $pop16
	i32.const	$push14=, 29
	i32.le_s	$push8=, $pop15, $pop14
	br_if   	0, $pop8        # 0: up to label3
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
