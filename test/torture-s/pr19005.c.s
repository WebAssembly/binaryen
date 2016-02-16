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
	i32.const	$push0=, 0
	i32.load	$push20=, v($pop0)
	tee_local	$push19=, $4=, $pop20
	i32.const	$push18=, 255
	i32.and 	$2=, $pop19, $pop18
	block
	block
	block
	i32.const	$push17=, 0
	i32.load	$push16=, s($pop17)
	tee_local	$push15=, $3=, $pop16
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop15, $pop22
	br_if   	0, $pop23       # 0: down to label2
# BB#1:                                 # %if.else
	block
	i32.ne  	$push4=, $2, $1
	br_if   	0, $pop4        # 0: down to label3
# BB#2:                                 # %if.else
	i32.const	$push2=, 1
	i32.add 	$push3=, $4, $pop2
	i32.const	$push21=, 255
	i32.and 	$push1=, $pop3, $pop21
	i32.eq  	$push5=, $pop1, $0
	br_if   	2, $pop5        # 2: down to label1
.LBB0_3:                                # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	i32.ne  	$push6=, $2, $0
	br_if   	1, $pop6        # 1: down to label0
# BB#5:                                 # %lor.lhs.false
	i32.const	$push7=, 1
	i32.add 	$push8=, $4, $pop7
	i32.const	$push9=, 255
	i32.and 	$push10=, $pop8, $pop9
	i32.ne  	$push11=, $pop10, $1
	br_if   	1, $pop11       # 1: down to label0
.LBB0_6:                                # %if.end21
	end_block                       # label1:
	i32.const	$push14=, 0
	i32.const	$push12=, 1
	i32.xor 	$push13=, $3, $pop12
	i32.store	$discard=, s($pop14), $pop13
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
	i32.add 	$push0=, $0, $pop24
	i32.const	$push23=, 255
	i32.and 	$2=, $pop0, $pop23
	i32.const	$push1=, 0
	i32.load	$push22=, v($pop1)
	tee_local	$push21=, $3=, $pop22
	i32.const	$push20=, 255
	i32.and 	$0=, $pop21, $pop20
	block
	block
	block
	block
	block
	block
	i32.const	$push19=, 0
	i32.load	$push18=, s($pop19)
	tee_local	$push17=, $4=, $pop18
	i32.const	$push31=, 0
	i32.eq  	$push32=, $pop17, $pop31
	br_if   	0, $pop32       # 0: down to label9
# BB#1:                                 # %if.else.i
	i32.ne  	$push3=, $0, $2
	br_if   	5, $pop3        # 5: down to label4
# BB#2:                                 # %if.else.i
	i32.const	$push29=, 1
	i32.add 	$push2=, $3, $pop29
	i32.const	$push28=, 255
	i32.and 	$3=, $pop2, $pop28
	i32.ne  	$push4=, $3, $1
	br_if   	5, $pop4        # 5: down to label4
# BB#3:                                 # %bar.exit
	i32.const	$push7=, 0
	i32.const	$push5=, 1
	i32.xor 	$push6=, $4, $pop5
	i32.store	$push8=, s($pop7), $pop6
	br_if   	1, $pop8        # 1: down to label8
	br      	2               # 2: down to label7
.LBB1_4:                                # %if.then.i
	end_block                       # label9:
	i32.ne  	$push9=, $0, $1
	br_if   	2, $pop9        # 2: down to label6
# BB#5:                                 # %lor.lhs.false.i
	i32.const	$push26=, 1
	i32.add 	$push10=, $3, $pop26
	i32.const	$push11=, 255
	i32.and 	$3=, $pop10, $pop11
	i32.ne  	$push12=, $3, $2
	br_if   	2, $pop12       # 2: down to label6
# BB#6:                                 # %bar.exit.thread
	i32.const	$push13=, 0
	i32.const	$push27=, 1
	i32.store	$discard=, s($pop13), $pop27
.LBB1_7:                                # %if.else.i40
	end_block                       # label8:
	i32.ne  	$push14=, $0, $1
	br_if   	2, $pop14       # 2: down to label5
# BB#8:                                 # %if.else.i40
	i32.ne  	$push15=, $3, $2
	br_if   	2, $pop15       # 2: down to label5
.LBB1_9:                                # %bar.exit43
	end_block                       # label7:
	i32.const	$push16=, 0
	i32.store	$discard=, s($pop16), $4
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_10:                               # %if.then8.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then19.i41
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then19.i
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
	br_if   	0, $pop3        # 0: up to label10
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
