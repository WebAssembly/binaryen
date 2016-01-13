	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61673.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	i32.const	$push0=, -121
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 84
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.load8_s	$0=, 0($0)
	block   	.LBB1_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.store8	$discard=, e($pop2), $0
.LBB1_2:                                # %if.end
	call    	bar@FUNCTION, $0
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	i32.load8_s	$0=, 0($0)
	block   	.LBB2_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB2_2
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.store8	$discard=, e($pop2), $0
.LBB2_2:                                # %if.end
	return
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$2=, main.c
	i32.const	$push0=, 33
	i32.store8	$1=, e($0), $pop0
	call    	foo@FUNCTION, $2
	block   	.LBB3_8
	i32.load8_u	$push1=, e($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB3_8
# BB#1:                                 # %if.end
	i32.const	$3=, main.c+1
	call    	foo@FUNCTION, $3
	i32.const	$4=, 135
	block   	.LBB3_7
	i32.load8_u	$push3=, e($0)
	i32.ne  	$push4=, $pop3, $4
	br_if   	$pop4, .LBB3_7
# BB#2:                                 # %if.end6
	i32.store8	$discard=, e($0), $1
	call    	baz@FUNCTION, $2
	block   	.LBB3_6
	i32.load8_u	$push5=, e($0)
	i32.ne  	$push6=, $pop5, $1
	br_if   	$pop6, .LBB3_6
# BB#3:                                 # %if.end11
	call    	baz@FUNCTION, $3
	block   	.LBB3_5
	i32.load8_u	$push7=, e($0)
	i32.ne  	$push8=, $pop7, $4
	br_if   	$pop8, .LBB3_5
# BB#4:                                 # %if.end16
	return  	$0
.LBB3_5:                                # %if.then15
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then10
	call    	abort@FUNCTION
	unreachable
.LBB3_7:                                # %if.then5
	call    	abort@FUNCTION
	unreachable
.LBB3_8:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.type	main.c,@object          # @main.c
	.section	.rodata.main.c,"a",@progbits
main.c:
	.ascii	"T\207"
	.size	main.c, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
