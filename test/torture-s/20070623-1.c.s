	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070623-1.c"
	.section	.text.nge,"ax",@progbits
	.hidden	nge
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
.Lfunc_end0:
	.size	nge, .Lfunc_end0-nge

	.section	.text.ngt,"ax",@progbits
	.hidden	ngt
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
.Lfunc_end1:
	.size	ngt, .Lfunc_end1-ngt

	.section	.text.nle,"ax",@progbits
	.hidden	nle
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
.Lfunc_end2:
	.size	nle, .Lfunc_end2-nle

	.section	.text.nlt,"ax",@progbits
	.hidden	nlt
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
.Lfunc_end3:
	.size	nlt, .Lfunc_end3-nlt

	.section	.text.neq,"ax",@progbits
	.hidden	neq
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
.Lfunc_end4:
	.size	neq, .Lfunc_end4-neq

	.section	.text.nne,"ax",@progbits
	.hidden	nne
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
.Lfunc_end5:
	.size	nne, .Lfunc_end5-nne

	.section	.text.ngeu,"ax",@progbits
	.hidden	ngeu
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
.Lfunc_end6:
	.size	ngeu, .Lfunc_end6-ngeu

	.section	.text.ngtu,"ax",@progbits
	.hidden	ngtu
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
.Lfunc_end7:
	.size	ngtu, .Lfunc_end7-ngtu

	.section	.text.nleu,"ax",@progbits
	.hidden	nleu
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
.Lfunc_end8:
	.size	nleu, .Lfunc_end8-nleu

	.section	.text.nltu,"ax",@progbits
	.hidden	nltu
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
.Lfunc_end9:
	.size	nltu, .Lfunc_end9-nltu

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 2147483647
	i32.const	$1=, -2147483648
	block   	.LBB10_40
	i32.call	$push0=, nge@FUNCTION, $1, $0
	br_if   	$pop0, .LBB10_40
# BB#1:                                 # %if.end
	i32.call	$2=, nge@FUNCTION, $0, $1
	i32.const	$3=, -1
	block   	.LBB10_39
	i32.ne  	$push1=, $2, $3
	br_if   	$pop1, .LBB10_39
# BB#2:                                 # %if.end4
	block   	.LBB10_38
	i32.call	$push2=, ngt@FUNCTION, $1, $0
	br_if   	$pop2, .LBB10_38
# BB#3:                                 # %if.end8
	block   	.LBB10_37
	i32.call	$push3=, ngt@FUNCTION, $0, $1
	i32.ne  	$push4=, $pop3, $3
	br_if   	$pop4, .LBB10_37
# BB#4:                                 # %if.end12
	block   	.LBB10_36
	i32.call	$push5=, nle@FUNCTION, $1, $0
	i32.ne  	$push6=, $pop5, $3
	br_if   	$pop6, .LBB10_36
# BB#5:                                 # %if.end16
	block   	.LBB10_35
	i32.call	$push7=, nle@FUNCTION, $0, $1
	br_if   	$pop7, .LBB10_35
# BB#6:                                 # %if.end20
	block   	.LBB10_34
	i32.call	$push8=, nlt@FUNCTION, $1, $0
	i32.ne  	$push9=, $pop8, $3
	br_if   	$pop9, .LBB10_34
# BB#7:                                 # %if.end24
	block   	.LBB10_33
	i32.call	$push10=, nlt@FUNCTION, $0, $1
	br_if   	$pop10, .LBB10_33
# BB#8:                                 # %if.end28
	block   	.LBB10_32
	i32.call	$push11=, neq@FUNCTION, $1, $0
	br_if   	$pop11, .LBB10_32
# BB#9:                                 # %if.end32
	block   	.LBB10_31
	i32.call	$push12=, neq@FUNCTION, $0, $1
	br_if   	$pop12, .LBB10_31
# BB#10:                                # %if.end36
	block   	.LBB10_30
	i32.call	$push13=, nne@FUNCTION, $1, $0
	i32.ne  	$push14=, $pop13, $3
	br_if   	$pop14, .LBB10_30
# BB#11:                                # %if.end40
	block   	.LBB10_29
	i32.call	$push15=, nne@FUNCTION, $0, $1
	i32.ne  	$push16=, $pop15, $3
	br_if   	$pop16, .LBB10_29
# BB#12:                                # %if.end44
	i32.const	$0=, 0
	block   	.LBB10_28
	i32.call	$push17=, ngeu@FUNCTION, $0, $3
	br_if   	$pop17, .LBB10_28
# BB#13:                                # %if.end48
	block   	.LBB10_27
	i32.call	$push18=, ngeu@FUNCTION, $3, $0
	i32.ne  	$push19=, $pop18, $3
	br_if   	$pop19, .LBB10_27
# BB#14:                                # %if.end52
	block   	.LBB10_26
	i32.call	$push20=, ngtu@FUNCTION, $0, $3
	br_if   	$pop20, .LBB10_26
# BB#15:                                # %if.end56
	block   	.LBB10_25
	i32.call	$push21=, ngtu@FUNCTION, $3, $0
	i32.ne  	$push22=, $pop21, $3
	br_if   	$pop22, .LBB10_25
# BB#16:                                # %if.end60
	block   	.LBB10_24
	i32.call	$push23=, nleu@FUNCTION, $0, $3
	i32.ne  	$push24=, $pop23, $3
	br_if   	$pop24, .LBB10_24
# BB#17:                                # %if.end64
	block   	.LBB10_23
	i32.call	$push25=, nleu@FUNCTION, $3, $0
	br_if   	$pop25, .LBB10_23
# BB#18:                                # %if.end68
	block   	.LBB10_22
	i32.call	$push26=, nltu@FUNCTION, $0, $3
	i32.ne  	$push27=, $pop26, $3
	br_if   	$pop27, .LBB10_22
# BB#19:                                # %if.end72
	block   	.LBB10_21
	i32.call	$push28=, nltu@FUNCTION, $3, $0
	br_if   	$pop28, .LBB10_21
# BB#20:                                # %if.end76
	call    	exit@FUNCTION, $0
	unreachable
.LBB10_21:                              # %if.then75
	call    	abort@FUNCTION
	unreachable
.LBB10_22:                              # %if.then71
	call    	abort@FUNCTION
	unreachable
.LBB10_23:                              # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB10_24:                              # %if.then63
	call    	abort@FUNCTION
	unreachable
.LBB10_25:                              # %if.then59
	call    	abort@FUNCTION
	unreachable
.LBB10_26:                              # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB10_27:                              # %if.then51
	call    	abort@FUNCTION
	unreachable
.LBB10_28:                              # %if.then47
	call    	abort@FUNCTION
	unreachable
.LBB10_29:                              # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB10_30:                              # %if.then39
	call    	abort@FUNCTION
	unreachable
.LBB10_31:                              # %if.then35
	call    	abort@FUNCTION
	unreachable
.LBB10_32:                              # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB10_33:                              # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB10_34:                              # %if.then23
	call    	abort@FUNCTION
	unreachable
.LBB10_35:                              # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB10_36:                              # %if.then15
	call    	abort@FUNCTION
	unreachable
.LBB10_37:                              # %if.then11
	call    	abort@FUNCTION
	unreachable
.LBB10_38:                              # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB10_39:                              # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB10_40:                              # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end10:
	.size	main, .Lfunc_end10-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
