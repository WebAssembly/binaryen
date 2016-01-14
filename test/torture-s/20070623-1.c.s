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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	block
	i32.call	$push0=, nge@FUNCTION, $1, $0
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.call	$2=, nge@FUNCTION, $0, $1
	i32.const	$3=, -1
	block
	i32.ne  	$push1=, $2, $3
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.end4
	block
	i32.call	$push2=, ngt@FUNCTION, $1, $0
	br_if   	$pop2, 0        # 0: down to label2
# BB#3:                                 # %if.end8
	block
	i32.call	$push3=, ngt@FUNCTION, $0, $1
	i32.ne  	$push4=, $pop3, $3
	br_if   	$pop4, 0        # 0: down to label3
# BB#4:                                 # %if.end12
	block
	i32.call	$push5=, nle@FUNCTION, $1, $0
	i32.ne  	$push6=, $pop5, $3
	br_if   	$pop6, 0        # 0: down to label4
# BB#5:                                 # %if.end16
	block
	i32.call	$push7=, nle@FUNCTION, $0, $1
	br_if   	$pop7, 0        # 0: down to label5
# BB#6:                                 # %if.end20
	block
	i32.call	$push8=, nlt@FUNCTION, $1, $0
	i32.ne  	$push9=, $pop8, $3
	br_if   	$pop9, 0        # 0: down to label6
# BB#7:                                 # %if.end24
	block
	i32.call	$push10=, nlt@FUNCTION, $0, $1
	br_if   	$pop10, 0       # 0: down to label7
# BB#8:                                 # %if.end28
	block
	i32.call	$push11=, neq@FUNCTION, $1, $0
	br_if   	$pop11, 0       # 0: down to label8
# BB#9:                                 # %if.end32
	block
	i32.call	$push12=, neq@FUNCTION, $0, $1
	br_if   	$pop12, 0       # 0: down to label9
# BB#10:                                # %if.end36
	block
	i32.call	$push13=, nne@FUNCTION, $1, $0
	i32.ne  	$push14=, $pop13, $3
	br_if   	$pop14, 0       # 0: down to label10
# BB#11:                                # %if.end40
	block
	i32.call	$push15=, nne@FUNCTION, $0, $1
	i32.ne  	$push16=, $pop15, $3
	br_if   	$pop16, 0       # 0: down to label11
# BB#12:                                # %if.end44
	i32.const	$0=, 0
	block
	i32.call	$push17=, ngeu@FUNCTION, $0, $3
	br_if   	$pop17, 0       # 0: down to label12
# BB#13:                                # %if.end48
	block
	i32.call	$push18=, ngeu@FUNCTION, $3, $0
	i32.ne  	$push19=, $pop18, $3
	br_if   	$pop19, 0       # 0: down to label13
# BB#14:                                # %if.end52
	block
	i32.call	$push20=, ngtu@FUNCTION, $0, $3
	br_if   	$pop20, 0       # 0: down to label14
# BB#15:                                # %if.end56
	block
	i32.call	$push21=, ngtu@FUNCTION, $3, $0
	i32.ne  	$push22=, $pop21, $3
	br_if   	$pop22, 0       # 0: down to label15
# BB#16:                                # %if.end60
	block
	i32.call	$push23=, nleu@FUNCTION, $0, $3
	i32.ne  	$push24=, $pop23, $3
	br_if   	$pop24, 0       # 0: down to label16
# BB#17:                                # %if.end64
	block
	i32.call	$push25=, nleu@FUNCTION, $3, $0
	br_if   	$pop25, 0       # 0: down to label17
# BB#18:                                # %if.end68
	block
	i32.call	$push26=, nltu@FUNCTION, $0, $3
	i32.ne  	$push27=, $pop26, $3
	br_if   	$pop27, 0       # 0: down to label18
# BB#19:                                # %if.end72
	block
	i32.call	$push28=, nltu@FUNCTION, $3, $0
	br_if   	$pop28, 0       # 0: down to label19
# BB#20:                                # %if.end76
	call    	exit@FUNCTION, $0
	unreachable
.LBB10_21:                              # %if.then75
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB10_22:                              # %if.then71
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB10_23:                              # %if.then67
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB10_24:                              # %if.then63
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB10_25:                              # %if.then59
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB10_26:                              # %if.then55
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB10_27:                              # %if.then51
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB10_28:                              # %if.then47
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB10_29:                              # %if.then43
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB10_30:                              # %if.then39
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB10_31:                              # %if.then35
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB10_32:                              # %if.then31
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB10_33:                              # %if.then27
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB10_34:                              # %if.then23
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB10_35:                              # %if.then19
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB10_36:                              # %if.then15
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB10_37:                              # %if.then11
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB10_38:                              # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB10_39:                              # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB10_40:                              # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
