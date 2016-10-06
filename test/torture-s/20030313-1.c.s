	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030313-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 12
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push2=, 0($0)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	i32.load	$push5=, 4($0)
	i32.const	$push6=, 11
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %if.end5
	i32.load	$push8=, 8($0)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %lor.lhs.false8
	i32.load	$push11=, 12($0)
	i32.const	$push12=, 12
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#5:                                 # %if.end12
	i32.load	$push14=, 16($0)
	i32.const	$push15=, 3
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#6:                                 # %lor.lhs.false15
	i32.load	$push17=, 20($0)
	i32.const	$push18=, 13
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#7:                                 # %if.end19
	i32.load	$push20=, 24($0)
	i32.const	$push21=, 4
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#8:                                 # %lor.lhs.false22
	i32.load	$push23=, 28($0)
	i32.const	$push24=, 14
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#9:                                 # %if.end26
	i32.load	$push26=, 32($0)
	i32.const	$push27=, 5
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#10:                                # %lor.lhs.false29
	i32.load	$push29=, 36($0)
	i32.const	$push30=, 15
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#11:                                # %if.end33
	i32.load	$push32=, 40($0)
	i32.const	$push33=, 6
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#12:                                # %lor.lhs.false36
	i32.load	$push35=, 44($0)
	i32.const	$push36=, 16
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#13:                                # %if.end40
	return
.LBB0_14:                               # %if.then39
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 160
	i32.sub 	$push21=, $pop13, $pop14
	tee_local	$push20=, $0=, $pop21
	i32.store	__stack_pointer($pop15), $pop20
	i64.const	$push0=, 47244640257
	i64.store	0($0), $pop0
	i64.const	$push1=, 51539607554
	i64.store	8($0), $pop1
	i32.const	$push2=, 3
	i32.store	16($0), $pop2
	i32.const	$push3=, 4
	i32.store	24($0), $pop3
	i32.const	$push4=, 0
	i32.load	$push5=, x($pop4)
	i32.store	20($0), $pop5
	i32.const	$push19=, 0
	i32.load	$push6=, x+4($pop19)
	i32.store	28($0), $pop6
	i32.const	$push7=, 5
	i32.store	32($0), $pop7
	i32.const	$push18=, 0
	i32.load	$push8=, x+8($pop18)
	i32.store	36($0), $pop8
	i32.const	$push9=, 6
	i32.store	40($0), $pop9
	i32.const	$push17=, 0
	i32.load	$push10=, x+12($pop17)
	i32.store	44($0), $pop10
	i32.const	$push11=, 12
	call    	foo@FUNCTION, $0, $pop11
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.int32	16                      # 0x10
	.size	x, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
