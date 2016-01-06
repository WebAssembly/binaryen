	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070623-1.c"
	.globl	nge
	.type	nge,@function
nge:                                    # @nge
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ge_s	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end0:
	.size	nge, func_end0-nge

	.globl	ngt
	.type	ngt,@function
ngt:                                    # @ngt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_s	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end1:
	.size	ngt, func_end1-ngt

	.globl	nle
	.type	nle,@function
nle:                                    # @nle
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.le_s	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end2:
	.size	nle, func_end2-nle

	.globl	nlt
	.type	nlt,@function
nlt:                                    # @nlt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end3:
	.size	nlt, func_end3-nlt

	.globl	neq
	.type	neq,@function
neq:                                    # @neq
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.eq  	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end4:
	.size	neq, func_end4-neq

	.globl	nne
	.type	nne,@function
nne:                                    # @nne
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ne  	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end5:
	.size	nne, func_end5-nne

	.globl	ngeu
	.type	ngeu,@function
ngeu:                                   # @ngeu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ge_u	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end6:
	.size	ngeu, func_end6-ngeu

	.globl	ngtu
	.type	ngtu,@function
ngtu:                                   # @ngtu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_u	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end7:
	.size	ngtu, func_end7-ngtu

	.globl	nleu
	.type	nleu,@function
nleu:                                   # @nleu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.le_u	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end8:
	.size	nleu, func_end8-nleu

	.globl	nltu
	.type	nltu,@function
nltu:                                   # @nltu
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_u	$push0=, $0, $1
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end9:
	.size	nltu, func_end9-nltu

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 2147483647
	i32.const	$1=, -2147483648
	block   	BB10_40
	i32.call	$push0=, nge, $1, $0
	br_if   	$pop0, BB10_40
# BB#1:                                 # %if.end
	i32.call	$2=, nge, $0, $1
	i32.const	$3=, -1
	block   	BB10_39
	i32.ne  	$push1=, $2, $3
	br_if   	$pop1, BB10_39
# BB#2:                                 # %if.end4
	block   	BB10_38
	i32.call	$push2=, ngt, $1, $0
	br_if   	$pop2, BB10_38
# BB#3:                                 # %if.end8
	block   	BB10_37
	i32.call	$push3=, ngt, $0, $1
	i32.ne  	$push4=, $pop3, $3
	br_if   	$pop4, BB10_37
# BB#4:                                 # %if.end12
	block   	BB10_36
	i32.call	$push5=, nle, $1, $0
	i32.ne  	$push6=, $pop5, $3
	br_if   	$pop6, BB10_36
# BB#5:                                 # %if.end16
	block   	BB10_35
	i32.call	$push7=, nle, $0, $1
	br_if   	$pop7, BB10_35
# BB#6:                                 # %if.end20
	block   	BB10_34
	i32.call	$push8=, nlt, $1, $0
	i32.ne  	$push9=, $pop8, $3
	br_if   	$pop9, BB10_34
# BB#7:                                 # %if.end24
	block   	BB10_33
	i32.call	$push10=, nlt, $0, $1
	br_if   	$pop10, BB10_33
# BB#8:                                 # %if.end28
	block   	BB10_32
	i32.call	$push11=, neq, $1, $0
	br_if   	$pop11, BB10_32
# BB#9:                                 # %if.end32
	block   	BB10_31
	i32.call	$push12=, neq, $0, $1
	br_if   	$pop12, BB10_31
# BB#10:                                # %if.end36
	block   	BB10_30
	i32.call	$push13=, nne, $1, $0
	i32.ne  	$push14=, $pop13, $3
	br_if   	$pop14, BB10_30
# BB#11:                                # %if.end40
	block   	BB10_29
	i32.call	$push15=, nne, $0, $1
	i32.ne  	$push16=, $pop15, $3
	br_if   	$pop16, BB10_29
# BB#12:                                # %if.end44
	i32.const	$0=, 0
	block   	BB10_28
	i32.call	$push17=, ngeu, $0, $3
	br_if   	$pop17, BB10_28
# BB#13:                                # %if.end48
	block   	BB10_27
	i32.call	$push18=, ngeu, $3, $0
	i32.ne  	$push19=, $pop18, $3
	br_if   	$pop19, BB10_27
# BB#14:                                # %if.end52
	block   	BB10_26
	i32.call	$push20=, ngtu, $0, $3
	br_if   	$pop20, BB10_26
# BB#15:                                # %if.end56
	block   	BB10_25
	i32.call	$push21=, ngtu, $3, $0
	i32.ne  	$push22=, $pop21, $3
	br_if   	$pop22, BB10_25
# BB#16:                                # %if.end60
	block   	BB10_24
	i32.call	$push23=, nleu, $0, $3
	i32.ne  	$push24=, $pop23, $3
	br_if   	$pop24, BB10_24
# BB#17:                                # %if.end64
	block   	BB10_23
	i32.call	$push25=, nleu, $3, $0
	br_if   	$pop25, BB10_23
# BB#18:                                # %if.end68
	block   	BB10_22
	i32.call	$push26=, nltu, $0, $3
	i32.ne  	$push27=, $pop26, $3
	br_if   	$pop27, BB10_22
# BB#19:                                # %if.end72
	block   	BB10_21
	i32.call	$push28=, nltu, $3, $0
	br_if   	$pop28, BB10_21
# BB#20:                                # %if.end76
	call    	exit, $0
	unreachable
BB10_21:                                # %if.then75
	call    	abort
	unreachable
BB10_22:                                # %if.then71
	call    	abort
	unreachable
BB10_23:                                # %if.then67
	call    	abort
	unreachable
BB10_24:                                # %if.then63
	call    	abort
	unreachable
BB10_25:                                # %if.then59
	call    	abort
	unreachable
BB10_26:                                # %if.then55
	call    	abort
	unreachable
BB10_27:                                # %if.then51
	call    	abort
	unreachable
BB10_28:                                # %if.then47
	call    	abort
	unreachable
BB10_29:                                # %if.then43
	call    	abort
	unreachable
BB10_30:                                # %if.then39
	call    	abort
	unreachable
BB10_31:                                # %if.then35
	call    	abort
	unreachable
BB10_32:                                # %if.then31
	call    	abort
	unreachable
BB10_33:                                # %if.then27
	call    	abort
	unreachable
BB10_34:                                # %if.then23
	call    	abort
	unreachable
BB10_35:                                # %if.then19
	call    	abort
	unreachable
BB10_36:                                # %if.then15
	call    	abort
	unreachable
BB10_37:                                # %if.then11
	call    	abort
	unreachable
BB10_38:                                # %if.then7
	call    	abort
	unreachable
BB10_39:                                # %if.then3
	call    	abort
	unreachable
BB10_40:                                # %if.then
	call    	abort
	unreachable
func_end10:
	.size	main, func_end10-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
