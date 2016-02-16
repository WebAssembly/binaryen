	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111227-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push16=, 0
	i32.load16_u	$push0=, s($pop16)
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push15=, 65535
	i32.ne  	$push5=, $pop4, $pop15
	br_if   	1, $pop5        # 1: down to label2
.LBB0_2:                                # %if.end
	end_block                       # label3:
	block
	i32.const	$push7=, 1
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push17=, 0
	i32.load	$push6=, i($pop17)
	i32.const	$push9=, -1
	i32.ne  	$push10=, $pop6, $pop9
	br_if   	2, $pop10       # 2: down to label1
.LBB0_4:                                # %if.end9
	end_block                       # label4:
	block
	br_if   	0, $0           # 0: down to label5
# BB#5:                                 # %if.end9
	i32.const	$push12=, 0
	i32.load	$push11=, l($pop12)
	i32.const	$push13=, -1
	i32.ne  	$push14=, $pop11, $pop13
	br_if   	3, $pop14       # 3: down to label0
.LBB0_6:                                # %if.end16
	end_block                       # label5:
	return
.LBB0_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then8
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then15
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
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.load8_s	$2=, v($pop6)
	block
	block
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push0=, 1
	i32.eq  	$push1=, $1, $pop0
	br_if   	1, $pop1        # 1: down to label7
# BB#2:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	2, $pop3        # 2: down to label6
# BB#3:                                 # %if.then
	i32.const	$push5=, 0
	i32.store16	$discard=, s($pop5), $2
	br      	2               # 2: down to label6
.LBB1_4:                                # %if.then8
	end_block                       # label8:
	i32.const	$push7=, 0
	i32.store	$discard=, l($pop7), $2
	br      	1               # 1: down to label6
.LBB1_5:                                # %if.then3
	end_block                       # label7:
	i32.const	$push4=, 0
	i32.store	$discard=, i($pop4), $2
.LBB1_6:                                # %if.end11
	end_block                       # label6:
	call    	bar@FUNCTION, $1
	return
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
	i32.const	$push0=, 0
	call    	foo@FUNCTION, $0, $pop0
	i32.const	$push1=, 1
	call    	foo@FUNCTION, $0, $pop1
	i32.const	$push2=, 2
	call    	foo@FUNCTION, $0, $pop2
	i32.const	$push3=, 0
	return  	$pop3
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
v:
	.int8	255                     # 0xff
	.size	v, 1

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	1
s:
	.int16	0                       # 0x0
	.size	s, 2

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.bss.l,"aw",@nobits
	.globl	l
	.p2align	2
l:
	.int32	0                       # 0x0
	.size	l, 4


	.ident	"clang version 3.9.0 "
