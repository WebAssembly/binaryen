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
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 255
	i32.and 	$4=, $pop19, $pop18
	block
	block
	block
	i32.const	$push17=, 0
	i32.load	$push16=, s($pop17)
	tee_local	$push15=, $3=, $pop16
	i32.eqz 	$push22=, $pop15
	br_if   	0, $pop22       # 0: down to label2
# BB#1:                                 # %if.else
	block
	i32.ne  	$push4=, $4, $1
	br_if   	0, $pop4        # 0: down to label3
# BB#2:                                 # %if.else
	i32.const	$push2=, 1
	i32.add 	$push3=, $2, $pop2
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
	i32.ne  	$push6=, $4, $0
	br_if   	1, $pop6        # 1: down to label0
# BB#5:                                 # %lor.lhs.false
	i32.const	$push7=, 1
	i32.add 	$push8=, $2, $pop7
	i32.const	$push9=, 255
	i32.and 	$push10=, $pop8, $pop9
	i32.ne  	$push11=, $pop10, $1
	br_if   	1, $pop11       # 1: down to label0
.LBB0_6:                                # %if.end21
	end_block                       # label1:
	i32.const	$push14=, 0
	i32.const	$push12=, 1
	i32.xor 	$push13=, $3, $pop12
	i32.store	$drop=, s($pop14), $pop13
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
	i32.const	$push1=, 0
	i32.load	$push24=, v($pop1)
	tee_local	$push23=, $2=, $pop24
	i32.const	$push22=, 255
	i32.and 	$4=, $pop23, $pop22
	i32.const	$push21=, 1
	i32.add 	$push2=, $0, $pop21
	i32.const	$push20=, 255
	i32.and 	$0=, $pop2, $pop20
	block
	block
	block
	block
	block
	i32.const	$push19=, 0
	i32.load	$push18=, s($pop19)
	tee_local	$push17=, $3=, $pop18
	i32.eqz 	$push35=, $pop17
	br_if   	0, $pop35       # 0: down to label8
# BB#1:                                 # %if.else.i
	i32.ne  	$push4=, $4, $0
	br_if   	3, $pop4        # 3: down to label5
# BB#2:                                 # %if.else.i
	i32.const	$push29=, 1
	i32.add 	$push3=, $2, $pop29
	i32.const	$push28=, 255
	i32.and 	$push27=, $pop3, $pop28
	tee_local	$push26=, $2=, $pop27
	i32.ne  	$push5=, $pop26, $1
	br_if   	3, $pop5        # 3: down to label5
# BB#3:                                 # %bar.exit
	i32.const	$push8=, 0
	i32.const	$push6=, 1
	i32.xor 	$push7=, $3, $pop6
	i32.store	$push0=, s($pop8), $pop7
	br_if   	1, $pop0        # 1: down to label7
	br      	2               # 2: down to label6
.LBB1_4:                                # %if.then.i
	end_block                       # label8:
	i32.ne  	$push9=, $4, $1
	br_if   	3, $pop9        # 3: down to label4
# BB#5:                                 # %lor.lhs.false.i
	i32.const	$push32=, 1
	i32.add 	$push10=, $2, $pop32
	i32.const	$push11=, 255
	i32.and 	$push31=, $pop10, $pop11
	tee_local	$push30=, $2=, $pop31
	i32.ne  	$push12=, $pop30, $0
	br_if   	3, $pop12       # 3: down to label4
# BB#6:                                 # %bar.exit.thread
	i32.const	$push13=, 0
	i32.const	$push33=, 1
	i32.store	$drop=, s($pop13), $pop33
.LBB1_7:                                # %if.else.i40
	end_block                       # label7:
	i32.ne  	$push14=, $4, $1
	br_if   	1, $pop14       # 1: down to label5
# BB#8:                                 # %if.else.i40
	i32.ne  	$push15=, $2, $0
	br_if   	1, $pop15       # 1: down to label5
.LBB1_9:                                # %bar.exit43
	end_block                       # label6:
	i32.const	$push16=, 0
	i32.store	$drop=, s($pop16), $3
	i32.const	$push34=, 0
	return  	$pop34
.LBB1_10:                               # %if.then19.i41
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then8.i
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
	i32.const	$0=, -10
	i32.const	$push5=, 0
	i32.const	$push4=, -10
	i32.store	$drop=, v($pop5), $pop4
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.call	$drop=, foo@FUNCTION, $0
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, v($pop10)
	i32.const	$push9=, 1
	i32.add 	$push8=, $pop1, $pop9
	tee_local	$push7=, $0=, $pop8
	i32.store	$push0=, v($pop11), $pop7
	i32.const	$push6=, 266
	i32.lt_s	$push2=, $pop0, $pop6
	br_if   	0, $pop2        # 0: up to label9
# BB#2:                                 # %for.end
	end_loop                        # label10:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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
	.functype	abort, void
