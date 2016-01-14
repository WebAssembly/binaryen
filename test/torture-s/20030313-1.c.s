	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030313-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 12
	block
	i32.ne  	$push0=, $1, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.load	$push1=, 0($0)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	i32.load	$push4=, 4($0)
	i32.const	$push5=, 11
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label1
# BB#3:                                 # %if.end5
	block
	i32.load	$push7=, 8($0)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label2
# BB#4:                                 # %lor.lhs.false8
	i32.load	$push10=, 12($0)
	i32.ne  	$push11=, $pop10, $2
	br_if   	$pop11, 0       # 0: down to label2
# BB#5:                                 # %if.end12
	block
	i32.load	$push12=, 16($0)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label3
# BB#6:                                 # %lor.lhs.false15
	i32.load	$push15=, 20($0)
	i32.const	$push16=, 13
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, 0       # 0: down to label3
# BB#7:                                 # %if.end19
	block
	i32.load	$push18=, 24($0)
	i32.const	$push19=, 4
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, 0       # 0: down to label4
# BB#8:                                 # %lor.lhs.false22
	i32.load	$push21=, 28($0)
	i32.const	$push22=, 14
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, 0       # 0: down to label4
# BB#9:                                 # %if.end26
	block
	i32.load	$push24=, 32($0)
	i32.const	$push25=, 5
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, 0       # 0: down to label5
# BB#10:                                # %lor.lhs.false29
	i32.load	$push27=, 36($0)
	i32.const	$push28=, 15
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, 0       # 0: down to label5
# BB#11:                                # %if.end33
	block
	i32.load	$push30=, 40($0)
	i32.const	$push31=, 6
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	$pop32, 0       # 0: down to label6
# BB#12:                                # %lor.lhs.false36
	i32.load	$push33=, 44($0)
	i32.const	$push34=, 16
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	$pop35, 0       # 0: down to label6
# BB#13:                                # %if.end40
	return
.LBB0_14:                               # %if.then39
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then32
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then25
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then18
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then11
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then4
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 160
	i32.sub 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push1=, 8
	i32.const	$5=, 0
	i32.add 	$5=, $7, $5
	i32.or  	$push2=, $5, $pop1
	i64.const	$push3=, 51539607554
	i64.store	$discard=, 0($pop2), $pop3
	i32.const	$0=, 0
	i32.load	$1=, x($0)
	i32.const	$push4=, 3
	i32.store	$discard=, 16($7), $pop4
	i32.load	$2=, x+4($0)
	i32.store	$discard=, 20($7), $1
	i32.const	$push5=, 4
	i32.store	$discard=, 24($7), $pop5
	i32.store	$discard=, 28($7), $2
	i32.load	$1=, x+8($0)
	i32.const	$push6=, 5
	i32.store	$discard=, 32($7), $pop6
	i32.load	$2=, x+12($0)
	i32.store	$discard=, 36($7), $1
	i32.const	$push7=, 6
	i32.store	$discard=, 40($7), $pop7
	i32.store	$discard=, 44($7), $2
	i64.const	$push0=, 47244640257
	i64.store	$discard=, 0($7), $pop0
	i32.const	$push8=, 12
	i32.const	$6=, 0
	i32.add 	$6=, $7, $6
	call    	foo@FUNCTION, $6, $pop8
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	2
x:
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.int32	16                      # 0x10
	.size	x, 16


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
