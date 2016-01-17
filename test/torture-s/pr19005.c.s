	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19005.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.load	$2=, v($5)
	i32.load	$3=, s($5)
	i32.const	$6=, 255
	i32.and 	$4=, $2, $6
	block
	block
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $3, $pop12
	br_if   	$pop13, 0       # 0: down to label2
# BB#1:                                 # %if.else
	block
	i32.ne  	$push3=, $4, $1
	br_if   	$pop3, 0        # 0: down to label3
# BB#2:                                 # %if.else
	i32.const	$push1=, 1
	i32.add 	$push2=, $2, $pop1
	i32.and 	$push0=, $pop2, $6
	i32.eq  	$push4=, $pop0, $0
	br_if   	$pop4, 2        # 2: down to label1
.LBB0_3:                                # %if.then19
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	i32.ne  	$push5=, $4, $0
	br_if   	$pop5, 1        # 1: down to label0
# BB#5:                                 # %lor.lhs.false
	i32.const	$push6=, 1
	i32.add 	$push7=, $2, $pop6
	i32.and 	$push8=, $pop7, $6
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, 1        # 1: down to label0
.LBB0_6:                                # %if.end21
	end_block                       # label1:
	i32.const	$push10=, 1
	i32.xor 	$push11=, $3, $pop10
	i32.store	$discard=, s($5), $pop11
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 1
	i32.const	$6=, 255
	i32.const	$7=, 0
	i32.load	$3=, v($7)
	i32.load	$4=, s($7)
	i32.and 	$1=, $0, $6
	i32.add 	$push0=, $0, $5
	i32.and 	$2=, $pop0, $6
	i32.and 	$0=, $3, $6
	block
	block
	block
	block
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $4, $pop11
	br_if   	$pop12, 0       # 0: down to label8
# BB#1:                                 # %if.else.i
	block
	i32.ne  	$push2=, $0, $2
	br_if   	$pop2, 0        # 0: down to label9
# BB#2:                                 # %if.else.i
	i32.add 	$push1=, $3, $5
	i32.and 	$6=, $pop1, $6
	i32.ne  	$push3=, $6, $1
	br_if   	$pop3, 0        # 0: down to label9
# BB#3:                                 # %bar.exit
	i32.xor 	$push4=, $4, $5
	i32.store	$discard=, s($7), $pop4
	i32.eq  	$push5=, $4, $5
	br_if   	$pop5, 3        # 3: down to label6
	br      	2               # 2: down to label7
.LBB1_4:                                # %if.then19.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then.i
	end_block                       # label8:
	i32.ne  	$push6=, $0, $1
	br_if   	$pop6, 3        # 3: down to label4
# BB#6:                                 # %lor.lhs.false.i
	i32.add 	$push7=, $3, $5
	i32.and 	$6=, $pop7, $6
	i32.ne  	$push8=, $6, $2
	br_if   	$pop8, 3        # 3: down to label4
# BB#7:                                 # %bar.exit.thread
	i32.store	$discard=, s($7), $5
.LBB1_8:                                # %if.else.i40
	end_block                       # label7:
	i32.ne  	$push9=, $0, $1
	br_if   	$pop9, 1        # 1: down to label5
# BB#9:                                 # %if.else.i40
	i32.ne  	$push10=, $6, $2
	br_if   	$pop10, 1       # 1: down to label5
.LBB1_10:                               # %bar.exit43
	end_block                       # label6:
	i32.store	$discard=, s($7), $4
	return  	$7
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push1=, -10
	i32.store	$1=, v($0), $pop1
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.call	$discard=, foo@FUNCTION, $1
	i32.load	$push2=, v($0)
	i32.const	$push3=, 1
	i32.add 	$push0=, $pop2, $pop3
	i32.store	$1=, v($0), $pop0
	i32.const	$push4=, 266
	i32.lt_s	$push5=, $1, $pop4
	br_if   	$pop5, 0        # 0: up to label10
# BB#2:                                 # %for.end
	end_loop                        # label11:
	return  	$0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.align	2
v:
	.int32	0                       # 0x0
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.int32	0                       # 0x0
	.size	s, 4


	.ident	"clang version 3.9.0 "
