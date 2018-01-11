	.text
	.file	"20070623-1.c"
	.section	.text.nge,"ax",@progbits
	.hidden	nge                     # -- Begin function nge
	.globl	nge
	.type	nge,@function
nge:                                    # @nge
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.ge_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	nge, .Lfunc_end0-nge
                                        # -- End function
	.section	.text.ngt,"ax",@progbits
	.hidden	ngt                     # -- Begin function ngt
	.globl	ngt
	.type	ngt,@function
ngt:                                    # @ngt
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.gt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	ngt, .Lfunc_end1-ngt
                                        # -- End function
	.section	.text.nle,"ax",@progbits
	.hidden	nle                     # -- Begin function nle
	.globl	nle
	.type	nle,@function
nle:                                    # @nle
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.le_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	nle, .Lfunc_end2-nle
                                        # -- End function
	.section	.text.nlt,"ax",@progbits
	.hidden	nlt                     # -- Begin function nlt
	.globl	nlt
	.type	nlt,@function
nlt:                                    # @nlt
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.lt_s	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end3:
	.size	nlt, .Lfunc_end3-nlt
                                        # -- End function
	.section	.text.neq,"ax",@progbits
	.hidden	neq                     # -- Begin function neq
	.globl	neq
	.type	neq,@function
neq:                                    # @neq
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.eq  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	neq, .Lfunc_end4-neq
                                        # -- End function
	.section	.text.nne,"ax",@progbits
	.hidden	nne                     # -- Begin function nne
	.globl	nne
	.type	nne,@function
nne:                                    # @nne
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.ne  	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end5:
	.size	nne, .Lfunc_end5-nne
                                        # -- End function
	.section	.text.ngeu,"ax",@progbits
	.hidden	ngeu                    # -- Begin function ngeu
	.globl	ngeu
	.type	ngeu,@function
ngeu:                                   # @ngeu
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.ge_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end6:
	.size	ngeu, .Lfunc_end6-ngeu
                                        # -- End function
	.section	.text.ngtu,"ax",@progbits
	.hidden	ngtu                    # -- Begin function ngtu
	.globl	ngtu
	.type	ngtu,@function
ngtu:                                   # @ngtu
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.gt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end7:
	.size	ngtu, .Lfunc_end7-ngtu
                                        # -- End function
	.section	.text.nleu,"ax",@progbits
	.hidden	nleu                    # -- Begin function nleu
	.globl	nleu
	.type	nleu,@function
nleu:                                   # @nleu
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.le_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end8:
	.size	nleu, .Lfunc_end8-nleu
                                        # -- End function
	.section	.text.nltu,"ax",@progbits
	.hidden	nltu                    # -- Begin function nltu
	.globl	nltu
	.type	nltu,@function
nltu:                                   # @nltu
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, -1
	i32.const	$push1=, 0
	i32.lt_u	$push0=, $0, $1
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end9:
	.size	nltu, .Lfunc_end9-nltu
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push34=, -2147483648
	i32.const	$push33=, 2147483647
	i32.call	$push0=, nge@FUNCTION, $pop34, $pop33
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push36=, 2147483647
	i32.const	$push35=, -2147483648
	i32.call	$push1=, nge@FUNCTION, $pop36, $pop35
	i32.const	$push2=, -1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push38=, -2147483648
	i32.const	$push37=, 2147483647
	i32.call	$push4=, ngt@FUNCTION, $pop38, $pop37
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %if.end8
	i32.const	$push41=, 2147483647
	i32.const	$push40=, -2147483648
	i32.call	$push5=, ngt@FUNCTION, $pop41, $pop40
	i32.const	$push39=, -1
	i32.ne  	$push6=, $pop5, $pop39
	br_if   	0, $pop6        # 0: down to label0
# %bb.4:                                # %if.end12
	i32.const	$push44=, -2147483648
	i32.const	$push43=, 2147483647
	i32.call	$push7=, nle@FUNCTION, $pop44, $pop43
	i32.const	$push42=, -1
	i32.ne  	$push8=, $pop7, $pop42
	br_if   	0, $pop8        # 0: down to label0
# %bb.5:                                # %if.end16
	i32.const	$push46=, 2147483647
	i32.const	$push45=, -2147483648
	i32.call	$push9=, nle@FUNCTION, $pop46, $pop45
	br_if   	0, $pop9        # 0: down to label0
# %bb.6:                                # %if.end20
	i32.const	$push48=, -2147483648
	i32.const	$push47=, 2147483647
	i32.call	$push10=, nlt@FUNCTION, $pop48, $pop47
	i32.const	$push11=, -1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.7:                                # %if.end24
	i32.const	$push50=, 2147483647
	i32.const	$push49=, -2147483648
	i32.call	$push13=, nlt@FUNCTION, $pop50, $pop49
	br_if   	0, $pop13       # 0: down to label0
# %bb.8:                                # %if.end28
	i32.const	$push52=, -2147483648
	i32.const	$push51=, 2147483647
	i32.call	$push14=, neq@FUNCTION, $pop52, $pop51
	br_if   	0, $pop14       # 0: down to label0
# %bb.9:                                # %if.end32
	i32.const	$push54=, 2147483647
	i32.const	$push53=, -2147483648
	i32.call	$push15=, neq@FUNCTION, $pop54, $pop53
	br_if   	0, $pop15       # 0: down to label0
# %bb.10:                               # %if.end36
	i32.const	$push57=, -2147483648
	i32.const	$push56=, 2147483647
	i32.call	$push16=, nne@FUNCTION, $pop57, $pop56
	i32.const	$push55=, -1
	i32.ne  	$push17=, $pop16, $pop55
	br_if   	0, $pop17       # 0: down to label0
# %bb.11:                               # %if.end40
	i32.const	$push60=, 2147483647
	i32.const	$push59=, -2147483648
	i32.call	$push18=, nne@FUNCTION, $pop60, $pop59
	i32.const	$push58=, -1
	i32.ne  	$push19=, $pop18, $pop58
	br_if   	0, $pop19       # 0: down to label0
# %bb.12:                               # %if.end44
	i32.const	$push62=, 0
	i32.const	$push61=, -1
	i32.call	$push20=, ngeu@FUNCTION, $pop62, $pop61
	br_if   	0, $pop20       # 0: down to label0
# %bb.13:                               # %if.end48
	i32.const	$push65=, -1
	i32.const	$push64=, 0
	i32.call	$push21=, ngeu@FUNCTION, $pop65, $pop64
	i32.const	$push63=, -1
	i32.ne  	$push22=, $pop21, $pop63
	br_if   	0, $pop22       # 0: down to label0
# %bb.14:                               # %if.end52
	i32.const	$push67=, 0
	i32.const	$push66=, -1
	i32.call	$push23=, ngtu@FUNCTION, $pop67, $pop66
	br_if   	0, $pop23       # 0: down to label0
# %bb.15:                               # %if.end56
	i32.const	$push70=, -1
	i32.const	$push69=, 0
	i32.call	$push24=, ngtu@FUNCTION, $pop70, $pop69
	i32.const	$push68=, -1
	i32.ne  	$push25=, $pop24, $pop68
	br_if   	0, $pop25       # 0: down to label0
# %bb.16:                               # %if.end60
	i32.const	$push73=, 0
	i32.const	$push72=, -1
	i32.call	$push26=, nleu@FUNCTION, $pop73, $pop72
	i32.const	$push71=, -1
	i32.ne  	$push27=, $pop26, $pop71
	br_if   	0, $pop27       # 0: down to label0
# %bb.17:                               # %if.end64
	i32.const	$push75=, -1
	i32.const	$push74=, 0
	i32.call	$push28=, nleu@FUNCTION, $pop75, $pop74
	br_if   	0, $pop28       # 0: down to label0
# %bb.18:                               # %if.end68
	i32.const	$push78=, 0
	i32.const	$push77=, -1
	i32.call	$push29=, nltu@FUNCTION, $pop78, $pop77
	i32.const	$push76=, -1
	i32.ne  	$push30=, $pop29, $pop76
	br_if   	0, $pop30       # 0: down to label0
# %bb.19:                               # %if.end72
	i32.const	$push80=, -1
	i32.const	$push79=, 0
	i32.call	$push31=, nltu@FUNCTION, $pop80, $pop79
	br_if   	0, $pop31       # 0: down to label0
# %bb.20:                               # %if.end76
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
	unreachable
.LBB10_21:                              # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
