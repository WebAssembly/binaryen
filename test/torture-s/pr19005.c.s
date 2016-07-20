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
	i32.load	$push16=, v($pop0)
	tee_local	$push15=, $4=, $pop16
	i32.const	$push1=, 255
	i32.and 	$3=, $pop15, $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $4, $pop2
	i32.const	$push14=, 255
	i32.and 	$4=, $pop3, $pop14
	block
	block
	block
	i32.const	$push13=, 0
	i32.load	$push12=, s($pop13)
	tee_local	$push11=, $2=, $pop12
	i32.eqz 	$push17=, $pop11
	br_if   	0, $pop17       # 0: down to label2
# BB#1:                                 # %if.else
	block
	i32.ne  	$push4=, $3, $1
	br_if   	0, $pop4        # 0: down to label3
# BB#2:                                 # %if.else
	i32.eq  	$push5=, $4, $0
	br_if   	2, $pop5        # 2: down to label1
.LBB0_3:                                # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	i32.ne  	$push6=, $3, $0
	br_if   	1, $pop6        # 1: down to label0
# BB#5:                                 # %if.then
	i32.ne  	$push7=, $4, $1
	br_if   	1, $pop7        # 1: down to label0
.LBB0_6:                                # %if.end21
	end_block                       # label1:
	i32.const	$push10=, 0
	i32.const	$push8=, 1
	i32.xor 	$push9=, $2, $pop8
	i32.store	$drop=, s($pop10), $pop9
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 255
	i32.and 	$1=, $0, $pop1
	i32.const	$push2=, 0
	i32.load	$push25=, v($pop2)
	tee_local	$push24=, $4=, $pop25
	i32.const	$push23=, 255
	i32.and 	$3=, $pop24, $pop23
	i32.const	$push3=, 1
	i32.add 	$push4=, $0, $pop3
	i32.const	$push22=, 255
	i32.and 	$2=, $pop4, $pop22
	i32.const	$push21=, 1
	i32.add 	$push5=, $4, $pop21
	i32.const	$push20=, 255
	i32.and 	$4=, $pop5, $pop20
	block
	block
	block
	block
	i32.const	$push19=, 0
	i32.load	$push18=, s($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.eqz 	$push31=, $pop17
	br_if   	0, $pop31       # 0: down to label7
# BB#1:                                 # %if.else.i
	block
	i32.ne  	$push27=, $3, $2
	tee_local	$push26=, $5=, $pop27
	br_if   	0, $pop26       # 0: down to label8
# BB#2:                                 # %if.else.i
	i32.eq  	$push29=, $4, $1
	tee_local	$push28=, $6=, $pop29
	i32.eqz 	$push32=, $pop28
	br_if   	0, $pop32       # 0: down to label8
# BB#3:                                 # %bar.exit
	i32.const	$push8=, 0
	i32.const	$push6=, 1
	i32.xor 	$push7=, $0, $pop6
	i32.store	$push0=, s($pop8), $pop7
	br_if   	2, $pop0        # 2: down to label6
# BB#4:                                 # %if.then.i33
	br_if   	0, $5           # 0: down to label8
# BB#5:                                 # %if.then.i33
	br_if   	3, $6           # 3: down to label5
.LBB1_6:                                # %if.then8.i34
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then.i
	end_block                       # label7:
	i32.ne  	$push9=, $3, $1
	br_if   	2, $pop9        # 2: down to label4
# BB#8:                                 # %if.then.i
	i32.ne  	$push10=, $4, $2
	br_if   	2, $pop10       # 2: down to label4
# BB#9:                                 # %bar.exit.thread
	i32.const	$push13=, 0
	i32.const	$push11=, 1
	i32.xor 	$push12=, $0, $pop11
	i32.store	$drop=, s($pop13), $pop12
.LBB1_10:                               # %if.else.i38
	end_block                       # label6:
	i32.ne  	$push14=, $3, $1
	br_if   	1, $pop14       # 1: down to label4
# BB#11:                                # %if.else.i38
	i32.ne  	$push15=, $4, $2
	br_if   	1, $pop15       # 1: down to label4
.LBB1_12:                               # %bar.exit41
	end_block                       # label5:
	i32.const	$push16=, 0
	i32.store	$drop=, s($pop16), $0
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_13:                               # %if.then8.i
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
