	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56799.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push16=, $pop10, $pop11
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

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($0)
	block   	
	block   	
	i32.load	$push10=, 0($0)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push0=, 65535
	i32.and 	$push1=, $pop9, $pop0
	i32.eqz 	$push11=, $pop1
	br_if   	0, $pop11       # 0: down to label2
# BB#1:                                 # %if.then
	i32.const	$push3=, 0
	i32.const	$push2=, 1
	i32.store	lo($pop3), $pop2
	copy_local	$0=, $2
	br      	1               # 1: down to label1
.LBB1_2:
	end_block                       # label2:
	i32.const	$0=, 0
.LBB1_3:                                # %if.end
	end_block                       # label1:
	block   	
	i32.const	$push4=, 65536
	i32.lt_u	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#4:                                 # %if.then7
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store	hi($pop7), $pop6
	i32.add 	$0=, $0, $2
.LBB1_5:                                # %if.end10
	end_block                       # label3:
	i32.add 	$push8=, $0, $2
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
	.functype	abort, void
