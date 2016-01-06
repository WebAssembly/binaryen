	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61673.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_3
	i32.const	$push0=, -121
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 84
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, BB0_3
# BB#2:                                 # %if.then
	call    	abort
	unreachable
BB0_3:                                  # %if.end
	return
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.load8_s	$0=, 0($0)
	block   	BB1_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.store8	$discard=, e($pop2), $0
BB1_2:                                  # %if.end
	call    	bar, $0
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	i32.load8_s	$0=, 0($0)
	block   	BB2_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB2_2
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.store8	$discard=, e($pop2), $0
BB2_2:                                  # %if.end
	return
func_end2:
	.size	baz, func_end2-baz

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
	call    	foo, $2
	block   	BB3_8
	i32.load8_u	$push1=, e($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB3_8
# BB#1:                                 # %if.end
	i32.const	$3=, main.c+1
	call    	foo, $3
	i32.const	$4=, 135
	block   	BB3_7
	i32.load8_u	$push3=, e($0)
	i32.ne  	$push4=, $pop3, $4
	br_if   	$pop4, BB3_7
# BB#2:                                 # %if.end6
	i32.store8	$discard=, e($0), $1
	call    	baz, $2
	block   	BB3_6
	i32.load8_u	$push5=, e($0)
	i32.ne  	$push6=, $pop5, $1
	br_if   	$pop6, BB3_6
# BB#3:                                 # %if.end11
	call    	baz, $3
	block   	BB3_5
	i32.load8_u	$push7=, e($0)
	i32.ne  	$push8=, $pop7, $4
	br_if   	$pop8, BB3_5
# BB#4:                                 # %if.end16
	return  	$0
BB3_5:                                  # %if.then15
	call    	abort
	unreachable
BB3_6:                                  # %if.then10
	call    	abort
	unreachable
BB3_7:                                  # %if.then5
	call    	abort
	unreachable
BB3_8:                                  # %if.then
	call    	abort
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	e,@object               # @e
	.bss
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.type	main.c,@object          # @main.c
	.section	.rodata,"a",@progbits
main.c:
	.ascii	"T\207"
	.size	main.c, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
