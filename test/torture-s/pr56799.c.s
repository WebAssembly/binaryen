	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56799.c"
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
	i32.sub 	$push15=, $pop10, $pop11
	i32.store	$push17=, __stack_pointer($pop12), $pop15
	tee_local	$push16=, $0=, $pop17
	i64.const	$push2=, 4295032832
	i64.store	$drop=, 8($pop16), $pop2
	block
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.call	$push4=, foo@FUNCTION, $pop14
	i32.const	$push3=, 2
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push18=, 0
	i32.load	$push0=, lo($pop18)
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push19=, 0
	i32.load	$push1=, hi($pop19)
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
	i32.const	$2=, 0
	block
	i32.load	$push11=, 0($0)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 65535
	i32.and 	$push0=, $pop10, $pop9
	i32.eqz 	$push16=, $pop0
	br_if   	0, $pop16       # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.const	$push1=, 1
	i32.store	$drop=, lo($pop2), $pop1
	i32.load	$2=, 4($0)
.LBB1_2:                                # %if.end
	end_block                       # label1:
	block
	i32.const	$push12=, 65535
	i32.le_u	$push3=, $1, $pop12
	br_if   	0, $pop3        # 0: down to label2
# BB#3:                                 # %if.then7
	i32.const	$push5=, 0
	i32.const	$push4=, 1
	i32.store	$drop=, hi($pop5), $pop4
	i32.load	$push15=, 4($0)
	tee_local	$push14=, $0=, $pop15
	i32.add 	$push13=, $0, $2
	i32.add 	$push7=, $pop14, $pop13
	return  	$pop7
.LBB1_4:                                # %if.end.if.end10_crit_edge
	end_block                       # label2:
	i32.load	$push8=, 4($0)
	i32.add 	$push6=, $pop8, $2
                                        # fallthrough-return: $pop6
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


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
