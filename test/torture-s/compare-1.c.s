	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/compare-1.c"
	.globl	ieq
	.type	ieq,@function
ieq:                                    # @ieq
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ne  	$1=, $0, $1
	block   	.LBB0_20
	block   	.LBB0_4
	block   	.LBB0_3
	i32.const	$push0=, 0
	i32.eq  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %if.else
	i32.const	$push2=, 0
	i32.eq  	$push3=, $2, $pop2
	br_if   	$pop3, .LBB0_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
.LBB0_3:                                  # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB0_20
.LBB0_4:                                  # %if.end6
	block   	.LBB0_19
	block   	.LBB0_8
	block   	.LBB0_7
	br_if   	$1, .LBB0_7
# BB#5:                                 # %if.then10
	br_if   	$2, .LBB0_8
# BB#6:                                 # %if.then12
	call    	abort
	unreachable
.LBB0_7:                                  # %if.else14
	br_if   	$2, .LBB0_19
.LBB0_8:                                  # %if.end18
	block   	.LBB0_18
	block   	.LBB0_12
	block   	.LBB0_11
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, .LBB0_11
# BB#9:                                 # %if.else26
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, .LBB0_12
# BB#10:                                # %if.then28
	call    	abort
	unreachable
.LBB0_11:                                 # %if.then22
	i32.const	$push10=, 0
	i32.eq  	$push11=, $2, $pop10
	br_if   	$pop11, .LBB0_18
.LBB0_12:                                 # %if.end30
	block   	.LBB0_17
	block   	.LBB0_16
	block   	.LBB0_15
	br_if   	$1, .LBB0_15
# BB#13:                                # %if.then34
	br_if   	$2, .LBB0_16
# BB#14:                                # %if.then36
	call    	abort
	unreachable
.LBB0_15:                                 # %if.else38
	br_if   	$2, .LBB0_17
.LBB0_16:                                 # %if.end42
	return  	$2
.LBB0_17:                                 # %if.then40
	call    	abort
	unreachable
.LBB0_18:                                 # %if.then24
	call    	abort
	unreachable
.LBB0_19:                                 # %if.then16
	call    	abort
	unreachable
.LBB0_20:                                 # %if.then2
	call    	abort
	unreachable
.Lfunc_end0:
	.size	ieq, .Lfunc_end0-ieq

	.globl	ine
	.type	ine,@function
ine:                                    # @ine
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB1_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, .LBB1_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
.LBB1_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, .LBB1_5
.LBB1_4:                                  # %if.end6
	return  	$2
.LBB1_5:                                  # %if.then2
	call    	abort
	unreachable
.Lfunc_end1:
	.size	ine, .Lfunc_end1-ine

	.globl	ilt
	.type	ilt,@function
ilt:                                    # @ilt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB2_5
	block   	.LBB2_4
	block   	.LBB2_3
	i32.ge_s	$push0=, $0, $1
	br_if   	$pop0, .LBB2_3
# BB#1:                                 # %if.then
	br_if   	$2, .LBB2_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
.LBB2_3:                                  # %if.else
	br_if   	$2, .LBB2_5
.LBB2_4:                                  # %if.end6
	return  	$2
.LBB2_5:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end2:
	.size	ilt, .Lfunc_end2-ilt

	.globl	ile
	.type	ile,@function
ile:                                    # @ile
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB3_5
	block   	.LBB3_4
	block   	.LBB3_3
	i32.le_s	$push0=, $0, $1
	br_if   	$pop0, .LBB3_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, .LBB3_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
.LBB3_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, .LBB3_5
.LBB3_4:                                  # %if.end6
	return  	$2
.LBB3_5:                                  # %if.then2
	call    	abort
	unreachable
.Lfunc_end3:
	.size	ile, .Lfunc_end3-ile

	.globl	igt
	.type	igt,@function
igt:                                    # @igt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB4_5
	block   	.LBB4_4
	block   	.LBB4_3
	i32.le_s	$push0=, $0, $1
	br_if   	$pop0, .LBB4_3
# BB#1:                                 # %if.then
	br_if   	$2, .LBB4_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
.LBB4_3:                                  # %if.else
	br_if   	$2, .LBB4_5
.LBB4_4:                                  # %if.end6
	return  	$2
.LBB4_5:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end4:
	.size	igt, .Lfunc_end4-igt

	.globl	ige
	.type	ige,@function
ige:                                    # @ige
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB5_5
	block   	.LBB5_4
	block   	.LBB5_3
	i32.ge_s	$push0=, $0, $1
	br_if   	$pop0, .LBB5_3
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	$pop2, .LBB5_4
# BB#2:                                 # %if.then4
	call    	abort
	unreachable
.LBB5_3:                                  # %if.then
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	$pop4, .LBB5_5
.LBB5_4:                                  # %if.end6
	return  	$2
.LBB5_5:                                  # %if.then2
	call    	abort
	unreachable
.Lfunc_end5:
	.size	ige, .Lfunc_end5-ige

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end6:
	.size	main, .Lfunc_end6-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
