	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pending-4.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 8
	i32.const	$2=, 0
	i32.const	$3=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.const	$push8=, 1
	i32.ne  	$push0=, $4, $pop8
	br_if   	0, $pop0        # 0: down to label1
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, -1
	i32.add 	$4=, $4, $pop6
	br      	1               # 1: up to label0
.LBB1_3:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label1:
	block   	
	i32.eqz 	$push11=, $4
	br_if   	0, $pop11       # 0: down to label2
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, -1
	i32.add 	$4=, $4, $pop9
	br      	1               # 1: up to label0
.LBB1_5:                                # %for.end
	end_block                       # label2:
	end_loop
	block   	
	i32.const	$push1=, 1
	i32.ne  	$push2=, $2, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#6:                                 # %for.end
	i32.const	$push3=, 7
	i32.ne  	$push4=, $3, $pop3
	br_if   	0, $pop4        # 0: down to label3
# BB#7:                                 # %if.end7
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_8:                                # %if.then6
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
