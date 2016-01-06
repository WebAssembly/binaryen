	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43385.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB0_3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, BB0_3
# BB#1:                                 # %entry
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, BB0_3
# BB#2:                                 # %if.then
	i32.const	$0=, 0
	i32.load	$push0=, e($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, e($0), $pop2
BB0_3:                                  # %if.end
	return
func_end0:
	.size	foo, func_end0-foo

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
func_end1:
	.size	bar, func_end1-bar

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
	call    	foo, $1, $2
	block   	BB2_24
	i32.load	$push0=, e($3)
	i32.ne  	$push1=, $pop0, $5
	br_if   	$pop1, BB2_24
# BB#1:                                 # %if.end
	call    	foo, $1, $0
	block   	BB2_23
	i32.load	$push2=, e($3)
	i32.ne  	$push3=, $pop2, $5
	br_if   	$pop3, BB2_23
# BB#2:                                 # %if.end5
	call    	foo, $2, $2
	block   	BB2_22
	i32.load	$push4=, e($3)
	i32.ne  	$push5=, $pop4, $4
	br_if   	$pop5, BB2_22
# BB#3:                                 # %if.end10
	call    	foo, $2, $0
	block   	BB2_21
	i32.load	$push6=, e($3)
	i32.ne  	$push7=, $pop6, $4
	br_if   	$pop7, BB2_21
# BB#4:                                 # %if.end14
	call    	foo, $0, $2
	block   	BB2_20
	i32.load	$push8=, e($3)
	i32.ne  	$push9=, $pop8, $4
	br_if   	$pop9, BB2_20
# BB#5:                                 # %if.end18
	call    	foo, $0, $0
	block   	BB2_19
	i32.load	$push10=, e($3)
	i32.ne  	$push11=, $pop10, $4
	br_if   	$pop11, BB2_19
# BB#6:                                 # %if.end21
	block   	BB2_18
	i32.call	$push12=, bar, $1, $2
	i32.ne  	$push13=, $pop12, $5
	br_if   	$pop13, BB2_18
# BB#7:                                 # %if.end26
	block   	BB2_17
	i32.call	$push14=, bar, $1, $0
	br_if   	$pop14, BB2_17
# BB#8:                                 # %if.end31
	block   	BB2_16
	i32.call	$push15=, bar, $2, $2
	i32.ne  	$push16=, $pop15, $5
	br_if   	$pop16, BB2_16
# BB#9:                                 # %if.end37
	block   	BB2_15
	i32.call	$push17=, bar, $2, $0
	br_if   	$pop17, BB2_15
# BB#10:                                # %if.end42
	block   	BB2_14
	i32.call	$push18=, bar, $0, $2
	br_if   	$pop18, BB2_14
# BB#11:                                # %if.end47
	block   	BB2_13
	i32.call	$push19=, bar, $0, $0
	br_if   	$pop19, BB2_13
# BB#12:                                # %if.end51
	return  	$3
BB2_13:                                 # %if.then50
	call    	abort
	unreachable
BB2_14:                                 # %if.then46
	call    	abort
	unreachable
BB2_15:                                 # %if.then41
	call    	abort
	unreachable
BB2_16:                                 # %if.then36
	call    	abort
	unreachable
BB2_17:                                 # %if.then30
	call    	abort
	unreachable
BB2_18:                                 # %if.then25
	call    	abort
	unreachable
BB2_19:                                 # %if.then20
	call    	abort
	unreachable
BB2_20:                                 # %if.then17
	call    	abort
	unreachable
BB2_21:                                 # %if.then13
	call    	abort
	unreachable
BB2_22:                                 # %if.then9
	call    	abort
	unreachable
BB2_23:                                 # %if.then4
	call    	abort
	unreachable
BB2_24:                                 # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	e,@object               # @e
	.bss
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
