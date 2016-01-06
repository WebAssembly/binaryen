	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/compare-1.c"
	.globl	ieq
	.type	ieq,@function
ieq:                                    # @ieq
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ne  	$1=, $0, $1
	block   	BB0_20
	block   	BB0_4
	block   	BB0_3
	i32.const	$push0=, 0
	i32.eq  	$push1=, $1, $pop0
	br_if   	$pop1, BB0_3
# BB#1:                                 # %if.else
	i32.const	$push2=, 0
	i32.eq  	$push3=, $2, $pop2
	br_if   	$pop3, BB0_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
BB0_3:                                  # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $2, $pop4
	br_if   	$pop5, BB0_20
BB0_4:                                  # %if.end6
	block   	BB0_19
	block   	BB0_8
	block   	BB0_7
	br_if   	$1, BB0_7
# BB#5:                                 # %if.then10
	br_if   	$2, BB0_8
# BB#6:                                 # %if.then12
	call    	abort
	unreachable
BB0_7:                                  # %if.else14
	br_if   	$2, BB0_19
BB0_8:                                  # %if.end18
	block   	BB0_18
	block   	BB0_12
	block   	BB0_11
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, BB0_11
# BB#9:                                 # %if.else26
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, BB0_12
# BB#10:                                # %if.then28
	call    	abort
	unreachable
BB0_11:                                 # %if.then22
	i32.const	$push10=, 0
	i32.eq  	$push11=, $2, $pop10
	br_if   	$pop11, BB0_18
BB0_12:                                 # %if.end30
	block   	BB0_17
	block   	BB0_16
	block   	BB0_15
	br_if   	$1, BB0_15
# BB#13:                                # %if.then34
	br_if   	$2, BB0_16
# BB#14:                                # %if.then36
	call    	abort
	unreachable
BB0_15:                                 # %if.else38
	br_if   	$2, BB0_17
BB0_16:                                 # %if.end42
	return  	$2
BB0_17:                                 # %if.then40
	call    	abort
	unreachable
BB0_18:                                 # %if.then24
	call    	abort
	unreachable
BB0_19:                                 # %if.then16
	call    	abort
	unreachable
BB0_20:                                 # %if.then2
	call    	abort
	unreachable
func_end0:
	.size	ieq, func_end0-ieq

	.globl	ine
	.type	ine,@function
ine:                                    # @ine
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_5
	block   	BB1_4
	block   	BB1_3
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, BB1_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, BB1_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
BB1_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, BB1_5
BB1_4:                                  # %if.end6
	return  	$2
BB1_5:                                  # %if.then2
	call    	abort
	unreachable
func_end1:
	.size	ine, func_end1-ine

	.globl	ilt
	.type	ilt,@function
ilt:                                    # @ilt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB2_5
	block   	BB2_4
	block   	BB2_3
	i32.ge_s	$push0=, $0, $1
	br_if   	$pop0, BB2_3
# BB#1:                                 # %if.then
	br_if   	$2, BB2_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB2_3:                                  # %if.else
	br_if   	$2, BB2_5
BB2_4:                                  # %if.end6
	return  	$2
BB2_5:                                  # %if.then4
	call    	abort
	unreachable
func_end2:
	.size	ilt, func_end2-ilt

	.globl	ile
	.type	ile,@function
ile:                                    # @ile
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB3_5
	block   	BB3_4
	block   	BB3_3
	i32.le_s	$push0=, $0, $1
	br_if   	$pop0, BB3_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, BB3_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
BB3_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, BB3_5
BB3_4:                                  # %if.end6
	return  	$2
BB3_5:                                  # %if.then2
	call    	abort
	unreachable
func_end3:
	.size	ile, func_end3-ile

	.globl	igt
	.type	igt,@function
igt:                                    # @igt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB4_5
	block   	BB4_4
	block   	BB4_3
	i32.le_s	$push0=, $0, $1
	br_if   	$pop0, BB4_3
# BB#1:                                 # %if.then
	br_if   	$2, BB4_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB4_3:                                  # %if.else
	br_if   	$2, BB4_5
BB4_4:                                  # %if.end6
	return  	$2
BB4_5:                                  # %if.then4
	call    	abort
	unreachable
func_end4:
	.size	igt, func_end4-igt

	.globl	ige
	.type	ige,@function
ige:                                    # @ige
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB5_5
	block   	BB5_4
	block   	BB5_3
	i32.ge_s	$push0=, $0, $1
	br_if   	$pop0, BB5_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, BB5_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
BB5_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, BB5_5
BB5_4:                                  # %if.end6
	return  	$2
BB5_5:                                  # %if.then2
	call    	abort
	unreachable
func_end5:
	.size	ige, func_end5-ige

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end6:
	.size	main, func_end6-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
