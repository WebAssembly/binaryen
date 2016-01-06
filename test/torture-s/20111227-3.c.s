	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111227-3.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB0_3
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, BB0_3
# BB#1:                                 # %entry
	i32.const	$2=, 65535
	i32.load16_u	$push0=, s($1)
	i32.and 	$push3=, $pop0, $2
	i32.eq  	$push4=, $pop3, $2
	br_if   	$pop4, BB0_3
# BB#2:                                 # %if.then
	call    	abort
	unreachable
BB0_3:                                  # %if.end
	block   	BB0_6
	i32.const	$push6=, 1
	i32.ne  	$push7=, $0, $pop6
	br_if   	$pop7, BB0_6
# BB#4:                                 # %if.end
	i32.load	$push5=, i($1)
	i32.const	$push8=, -1
	i32.eq  	$push9=, $pop5, $pop8
	br_if   	$pop9, BB0_6
# BB#5:                                 # %if.then8
	call    	abort
	unreachable
BB0_6:                                  # %if.end9
	block   	BB0_9
	br_if   	$0, BB0_9
# BB#7:                                 # %if.end9
	i32.load	$push10=, l($1)
	i32.const	$push11=, -1
	i32.eq  	$push12=, $pop10, $pop11
	br_if   	$pop12, BB0_9
# BB#8:                                 # %if.then15
	call    	abort
	unreachable
BB0_9:                                  # %if.end16
	return
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load8_s	$2=, v($3)
	block   	BB1_6
	block   	BB1_5
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB1_5
# BB#1:                                 # %entry
	block   	BB1_4
	i32.const	$push0=, 1
	i32.eq  	$push1=, $1, $pop0
	br_if   	$pop1, BB1_4
# BB#2:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB1_6
# BB#3:                                 # %if.then
	i32.store16	$discard=, s($3), $2
	br      	BB1_6
BB1_4:                                  # %if.then3
	i32.store	$discard=, i($3), $2
	br      	BB1_6
BB1_5:                                  # %if.then8
	i32.store	$discard=, l($3), $2
BB1_6:                                  # %if.end11
	call    	bar, $1
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	call    	foo, $0, $0
	i32.const	$push0=, 1
	call    	foo, $0, $pop0
	i32.const	$push1=, 2
	call    	foo, $0, $pop1
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	v,@object               # @v
	.data
	.globl	v
v:
	.int8	255                     # 0xff
	.size	v, 1

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	1
s:
	.int16	0                       # 0x0
	.size	s, 2

	.type	i,@object               # @i
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	l,@object               # @l
	.globl	l
	.align	2
l:
	.int32	0                       # 0x0
	.size	l, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
