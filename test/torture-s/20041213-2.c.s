	.text
	.file	"20041213-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 0
	i32.const	$3=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	block   	
	block   	
	copy_local	$push4=, $3
	tee_local	$push3=, $1=, $pop4
	i32.ge_s	$push0=, $2, $pop3
	br_if   	0, $pop0        # 0: down to label4
# BB#3:                                 # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push5=, 1
	i32.shl 	$push2=, $1, $pop5
	i32.sub 	$3=, $pop2, $2
	br      	1               # 1: down to label3
.LBB0_4:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$3=, $1
	i32.ne  	$push1=, $2, $1
	br_if   	3, $pop1        # 3: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	copy_local	$2=, $1
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label2
.LBB0_6:                                # %for.end7
	end_loop
	end_block                       # label1:
	return
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
