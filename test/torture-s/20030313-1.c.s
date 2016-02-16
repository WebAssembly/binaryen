	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030313-1.c"
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
	block
	block
	block
	block
	block
	block
	i32.load	$push2=, 0($0)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label6
# BB#2:                                 # %lor.lhs.false
	i32.load	$push5=, 4($0)
	i32.const	$push6=, 11
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label6
# BB#3:                                 # %if.end5
	i32.load	$push8=, 8($0)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label5
# BB#4:                                 # %lor.lhs.false8
	i32.load	$push11=, 12($0)
	i32.const	$push12=, 12
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label5
# BB#5:                                 # %if.end12
	i32.load	$push14=, 16($0)
	i32.const	$push15=, 3
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	2, $pop16       # 2: down to label4
# BB#6:                                 # %lor.lhs.false15
	i32.load	$push17=, 20($0)
	i32.const	$push18=, 13
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	2, $pop19       # 2: down to label4
# BB#7:                                 # %if.end19
	i32.load	$push20=, 24($0)
	i32.const	$push21=, 4
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	3, $pop22       # 3: down to label3
# BB#8:                                 # %lor.lhs.false22
	i32.load	$push23=, 28($0)
	i32.const	$push24=, 14
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	3, $pop25       # 3: down to label3
# BB#9:                                 # %if.end26
	i32.load	$push26=, 32($0)
	i32.const	$push27=, 5
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	4, $pop28       # 4: down to label2
# BB#10:                                # %lor.lhs.false29
	i32.load	$push29=, 36($0)
	i32.const	$push30=, 15
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	4, $pop31       # 4: down to label2
# BB#11:                                # %if.end33
	i32.load	$push32=, 40($0)
	i32.const	$push33=, 6
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	5, $pop34       # 5: down to label1
# BB#12:                                # %lor.lhs.false36
	i32.load	$push35=, 44($0)
	i32.const	$push36=, 16
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	5, $pop37       # 5: down to label1
# BB#13:                                # %if.end40
	return
.LBB0_14:                               # %if.then4
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then11
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then18
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then25
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then32
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then39
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then
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
# BB#0:                                 # %lor.lhs.false15.i
	block
	block
	block
	block
	i32.const	$push13=, 0
	i32.load	$push2=, x($pop13)
	i32.const	$push3=, 13
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label10
# BB#1:                                 # %lor.lhs.false22.i
	i32.const	$push14=, 0
	i32.load	$push5=, x+4($pop14)
	i32.const	$push6=, 14
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label9
# BB#2:                                 # %lor.lhs.false29.i
	i32.const	$push15=, 0
	i32.load	$push0=, x+8($pop15)
	i32.const	$push8=, 15
	i32.ne  	$push9=, $pop0, $pop8
	br_if   	2, $pop9        # 2: down to label8
# BB#3:                                 # %lor.lhs.false36.i
	i32.const	$push16=, 0
	i32.load	$push1=, x+12($pop16)
	i32.const	$push10=, 16
	i32.ne  	$push11=, $pop1, $pop10
	br_if   	3, $pop11       # 3: down to label7
# BB#4:                                 # %foo.exit
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_5:                                # %if.then18.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then25.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then32.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then39.i
	end_block                       # label7:
	call    	abort@FUNCTION
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


	.ident	"clang version 3.9.0 "
