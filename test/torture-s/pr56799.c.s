	.text
	.file	"pr56799.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 16
	i32.sub 	$push16=, $pop9, $pop11
	tee_local	$push15=, $0=, $pop16
	i32.store	__stack_pointer($pop12), $pop15
	i64.const	$push2=, 4295032832
	i64.store	8($0), $pop2
	block   	
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.call	$push4=, foo@FUNCTION, $pop14
	i32.const	$push3=, 2
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push17=, 0
	i32.load	$push0=, lo($pop17)
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push18=, 0
	i32.load	$push1=, hi($pop18)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop1, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %if.then
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB0_4:                                # %if.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.load	$push12=, 0($0)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 65535
	i32.and 	$push0=, $pop11, $pop10
	i32.eqz 	$push18=, $pop0
	br_if   	0, $pop18       # 0: down to label3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.const	$push1=, 1
	i32.store	lo($pop2), $pop1
	i32.load	$2=, 4($0)
	i32.const	$push13=, 65535
	i32.le_u	$push4=, $1, $pop13
	br_if   	1, $pop4        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_2:
	end_block                       # label3:
	i32.const	$2=, 0
	i32.const	$push17=, 65535
	i32.gt_u	$push3=, $1, $pop17
	br_if   	1, $pop3        # 1: down to label1
.LBB1_3:                                # %if.end.if.end10_crit_edge
	end_block                       # label2:
	i32.load	$push9=, 4($0)
	i32.add 	$push7=, $pop9, $2
	return  	$pop7
.LBB1_4:                                # %if.then7
	end_block                       # label1:
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.store	hi($pop6), $pop5
	i32.load	$push16=, 4($0)
	tee_local	$push15=, $0=, $pop16
	i32.add 	$push14=, $0, $2
	i32.add 	$push8=, $pop15, $pop14
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.hidden	hi                      # @hi
	.type	hi,@object
	.section	.bss.hi,"aw",@nobits
	.globl	hi
	.p2align	2
hi:
	.int32	0                       # 0x0
	.size	hi, 4

	.hidden	lo                      # @lo
	.type	lo,@object
	.section	.bss.lo,"aw",@nobits
	.globl	lo
	.p2align	2
lo:
	.int32	0                       # 0x0
	.size	lo, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	abort, void
