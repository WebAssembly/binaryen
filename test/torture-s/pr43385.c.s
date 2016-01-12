	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43385.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, .LBB0_3
# BB#2:                                 # %if.then
	i32.const	$0=, 0
	i32.load	$push0=, e($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, e($0), $pop2
.LBB0_3:                                # %if.end
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.ne  	$push0=, $0, $2
	i32.ne  	$push1=, $1, $2
	i32.and 	$push2=, $pop0, $pop1
	return  	$pop2
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	copy_local	$0=, $3
	#APP
	#NO_APP
	i32.const	$4=, 2
	i32.add 	$1=, $0, $4
	i32.const	$5=, 1
	i32.add 	$2=, $0, $5
	call    	foo@FUNCTION, $1, $2
	block   	.LBB2_24
	i32.load	$push0=, e($3)
	i32.ne  	$push1=, $pop0, $5
	br_if   	$pop1, .LBB2_24
# BB#1:                                 # %if.end
	call    	foo@FUNCTION, $1, $0
	block   	.LBB2_23
	i32.load	$push2=, e($3)
	i32.ne  	$push3=, $pop2, $5
	br_if   	$pop3, .LBB2_23
# BB#2:                                 # %if.end5
	call    	foo@FUNCTION, $2, $2
	block   	.LBB2_22
	i32.load	$push4=, e($3)
	i32.ne  	$push5=, $pop4, $4
	br_if   	$pop5, .LBB2_22
# BB#3:                                 # %if.end10
	call    	foo@FUNCTION, $2, $0
	block   	.LBB2_21
	i32.load	$push6=, e($3)
	i32.ne  	$push7=, $pop6, $4
	br_if   	$pop7, .LBB2_21
# BB#4:                                 # %if.end14
	call    	foo@FUNCTION, $0, $2
	block   	.LBB2_20
	i32.load	$push8=, e($3)
	i32.ne  	$push9=, $pop8, $4
	br_if   	$pop9, .LBB2_20
# BB#5:                                 # %if.end18
	call    	foo@FUNCTION, $0, $0
	block   	.LBB2_19
	i32.load	$push10=, e($3)
	i32.ne  	$push11=, $pop10, $4
	br_if   	$pop11, .LBB2_19
# BB#6:                                 # %if.end21
	block   	.LBB2_18
	i32.call	$push12=, bar@FUNCTION, $1, $2
	i32.ne  	$push13=, $pop12, $5
	br_if   	$pop13, .LBB2_18
# BB#7:                                 # %if.end26
	block   	.LBB2_17
	i32.call	$push14=, bar@FUNCTION, $1, $0
	br_if   	$pop14, .LBB2_17
# BB#8:                                 # %if.end31
	block   	.LBB2_16
	i32.call	$push15=, bar@FUNCTION, $2, $2
	i32.ne  	$push16=, $pop15, $5
	br_if   	$pop16, .LBB2_16
# BB#9:                                 # %if.end37
	block   	.LBB2_15
	i32.call	$push17=, bar@FUNCTION, $2, $0
	br_if   	$pop17, .LBB2_15
# BB#10:                                # %if.end42
	block   	.LBB2_14
	i32.call	$push18=, bar@FUNCTION, $0, $2
	br_if   	$pop18, .LBB2_14
# BB#11:                                # %if.end47
	block   	.LBB2_13
	i32.call	$push19=, bar@FUNCTION, $0, $0
	br_if   	$pop19, .LBB2_13
# BB#12:                                # %if.end51
	return  	$3
.LBB2_13:                               # %if.then50
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then46
	call    	abort@FUNCTION
	unreachable
.LBB2_15:                               # %if.then41
	call    	abort@FUNCTION
	unreachable
.LBB2_16:                               # %if.then36
	call    	abort@FUNCTION
	unreachable
.LBB2_17:                               # %if.then30
	call    	abort@FUNCTION
	unreachable
.LBB2_18:                               # %if.then25
	call    	abort@FUNCTION
	unreachable
.LBB2_19:                               # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB2_20:                               # %if.then17
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.then13
	call    	abort@FUNCTION
	unreachable
.LBB2_22:                               # %if.then9
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
