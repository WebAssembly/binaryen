	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111227-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.load16_u	$push0=, s($1)
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push5=, 255
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end
	end_block                       # label0:
	block
	i32.const	$push8=, 1
	i32.ne  	$push9=, $0, $pop8
	br_if   	$pop9, 0        # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push7=, i($1)
	i32.const	$push10=, 255
	i32.eq  	$push11=, $pop7, $pop10
	br_if   	$pop11, 0       # 0: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.end9
	end_block                       # label1:
	block
	br_if   	$0, 0           # 0: down to label2
# BB#7:                                 # %if.end9
	i32.load	$push12=, l($1)
	i32.const	$push13=, 255
	i32.eq  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label2
# BB#8:                                 # %if.then15
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.end16
	end_block                       # label2:
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load8_u	$2=, v($3)
	block
	block
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, 0        # 0: down to label4
# BB#1:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.eq  	$push1=, $1, $pop0
	br_if   	$pop1, 0        # 0: down to label5
# BB#2:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, 2        # 2: down to label3
# BB#3:                                 # %if.then
	i32.store16	$discard=, s($3), $2
	br      	2               # 2: down to label3
.LBB1_4:                                # %if.then3
	end_block                       # label5:
	i32.store	$discard=, i($3), $2
	br      	1               # 1: down to label3
.LBB1_5:                                # %if.then8
	end_block                       # label4:
	i32.store	$discard=, l($3), $2
.LBB1_6:                                # %if.end11
	end_block                       # label3:
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
	i32.const	$0=, 0
	call    	foo@FUNCTION, $0, $0
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $0, $pop0
	i32.const	$push1=, 2
	call    	foo@FUNCTION, $0, $pop1
	return  	$0
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
	.align	1
s:
	.int16	0                       # 0x0
	.size	s, 2

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.bss.l,"aw",@nobits
	.globl	l
	.align	2
l:
	.int32	0                       # 0x0
	.size	l, 4


	.ident	"clang version 3.9.0 "
