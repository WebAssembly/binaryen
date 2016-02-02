	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19005.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push0=, v($pop2)
	tee_local	$push20=, $4=, $pop0
	i32.const	$push19=, 255
	i32.and 	$2=, $pop20, $pop19
	block
	block
	block
	i32.const	$push18=, 0
	i32.load	$push1=, s($pop18)
	tee_local	$push17=, $3=, $pop1
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop17, $pop22
	br_if   	$pop23, 0       # 0: down to label2
# BB#1:                                 # %if.else
	block
	i32.ne  	$push6=, $2, $1
	br_if   	$pop6, 0        # 0: down to label3
# BB#2:                                 # %if.else
	i32.const	$push4=, 1
	i32.add 	$push5=, $4, $pop4
	i32.const	$push21=, 255
	i32.and 	$push3=, $pop5, $pop21
	i32.eq  	$push7=, $pop3, $0
	br_if   	$pop7, 2        # 2: down to label1
.LBB0_3:                                # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	i32.ne  	$push8=, $2, $0
	br_if   	$pop8, 1        # 1: down to label0
# BB#5:                                 # %lor.lhs.false
	i32.const	$push9=, 1
	i32.add 	$push10=, $4, $pop9
	i32.const	$push11=, 255
	i32.and 	$push12=, $pop10, $pop11
	i32.ne  	$push13=, $pop12, $1
	br_if   	$pop13, 1       # 1: down to label0
.LBB0_6:                                # %if.end21
	end_block                       # label1:
	i32.const	$push16=, 0
	i32.const	$push14=, 1
	i32.xor 	$push15=, $3, $pop14
	i32.store	$discard=, s($pop16), $pop15
	return
.LBB0_7:                                # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 255
	i32.and 	$1=, $0, $pop25
	i32.const	$push24=, 1
	i32.add 	$push2=, $0, $pop24
	i32.const	$push23=, 255
	i32.and 	$2=, $pop2, $pop23
	i32.const	$push3=, 0
	i32.load	$push0=, v($pop3)
	tee_local	$push22=, $4=, $pop0
	i32.const	$push21=, 255
	i32.and 	$3=, $pop22, $pop21
	block
	block
	block
	block
	block
	i32.const	$push20=, 0
	i32.load	$push1=, s($pop20)
	tee_local	$push19=, $0=, $pop1
	i32.const	$push32=, 0
	i32.eq  	$push33=, $pop19, $pop32
	br_if   	$pop33, 0       # 0: down to label8
# BB#1:                                 # %if.else.i
	block
	i32.ne  	$push5=, $3, $2
	br_if   	$pop5, 0        # 0: down to label9
# BB#2:                                 # %if.else.i
	i32.const	$push29=, 1
	i32.add 	$push4=, $4, $pop29
	i32.const	$push28=, 255
	i32.and 	$4=, $pop4, $pop28
	i32.ne  	$push6=, $4, $1
	br_if   	$pop6, 0        # 0: down to label9
# BB#3:                                 # %bar.exit
	i32.const	$push9=, 0
	i32.const	$push7=, 1
	i32.xor 	$push8=, $0, $pop7
	i32.store	$discard=, s($pop9), $pop8
	i32.const	$push30=, 1
	i32.eq  	$push10=, $0, $pop30
	br_if   	$pop10, 3       # 3: down to label6
	br      	2               # 2: down to label7
.LBB1_4:                                # %if.then19.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then.i
	end_block                       # label8:
	i32.ne  	$push11=, $3, $1
	br_if   	$pop11, 3       # 3: down to label4
# BB#6:                                 # %lor.lhs.false.i
	i32.const	$push26=, 1
	i32.add 	$push12=, $4, $pop26
	i32.const	$push13=, 255
	i32.and 	$4=, $pop12, $pop13
	i32.ne  	$push14=, $4, $2
	br_if   	$pop14, 3       # 3: down to label4
# BB#7:                                 # %bar.exit.thread
	i32.const	$push15=, 0
	i32.const	$push27=, 1
	i32.store	$discard=, s($pop15), $pop27
.LBB1_8:                                # %if.else.i40
	end_block                       # label7:
	i32.ne  	$push16=, $3, $1
	br_if   	$pop16, 1       # 1: down to label5
# BB#9:                                 # %if.else.i40
	i32.ne  	$push17=, $4, $2
	br_if   	$pop17, 1       # 1: down to label5
.LBB1_10:                               # %bar.exit43
	end_block                       # label6:
	i32.const	$push18=, 0
	i32.store	$discard=, s($pop18), $0
	i32.const	$push31=, 0
	return  	$pop31
.LBB1_11:                               # %if.then19.i41
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then8.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push1=, -10
	i32.store	$0=, v($pop5), $pop1
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.call	$discard=, foo@FUNCTION, $0
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load	$push2=, v($pop8)
	i32.const	$push7=, 1
	i32.add 	$push0=, $pop2, $pop7
	i32.store	$0=, v($pop9), $pop0
	i32.const	$push6=, 266
	i32.lt_s	$push3=, $0, $pop6
	br_if   	$pop3, 0        # 0: up to label10
# BB#2:                                 # %for.end
	end_loop                        # label11:
	i32.const	$push4=, 0
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.int32	0                       # 0x0
	.size	s, 4


	.ident	"clang version 3.9.0 "
