	.text
	.file	"20071202-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	8($0):p2align=2, $pop0
	i32.load	$1=, 0($0)
	i32.load	$push1=, 4($0)
	i32.store	0($0), $pop1
	i32.store	4($0), $1
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i64.const	$push7=, 0
	i64.store	0($pop3):p2align=2, $pop7
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i64.const	$push6=, 0
	i64.store	0($pop5):p2align=2, $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push69=, 0
	i32.load	$push68=, __stack_pointer($pop69)
	i32.const	$push70=, 80
	i32.sub 	$0=, $pop68, $pop70
	i32.const	$push71=, 0
	i32.store	__stack_pointer($pop71), $0
	i32.const	$push75=, 8
	i32.add 	$push76=, $0, $pop75
	i32.const	$push1=, .Lmain.s
	i32.const	$push0=, 68
	i32.call	$drop=, memcpy@FUNCTION, $pop76, $pop1, $pop0
	i32.const	$push77=, 8
	i32.add 	$push78=, $0, $pop77
	call    	foo@FUNCTION, $pop78
	block   	
	i32.load	$push3=, 8($0)
	i32.const	$push2=, 12
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push6=, 12($0)
	i32.const	$push5=, 6
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %lor.lhs.false2
	i32.load	$push8=, 16($0)
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %lor.lhs.false3
	i32.const	$push9=, 20
	i32.add 	$push10=, $0, $pop9
	i32.load	$push11=, 0($pop10)
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %lor.lhs.false7
	i32.const	$push12=, 24
	i32.add 	$push13=, $0, $pop12
	i32.load	$push14=, 0($pop13)
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %lor.lhs.false11
	i32.const	$push15=, 28
	i32.add 	$push16=, $0, $pop15
	i32.load	$push17=, 0($pop16)
	br_if   	0, $pop17       # 0: down to label0
# %bb.6:                                # %lor.lhs.false15
	i32.const	$push18=, 32
	i32.add 	$push19=, $0, $pop18
	i32.load	$push20=, 0($pop19)
	br_if   	0, $pop20       # 0: down to label0
# %bb.7:                                # %lor.lhs.false19
	i32.const	$push21=, 36
	i32.add 	$push22=, $0, $pop21
	i32.load	$push23=, 0($pop22)
	br_if   	0, $pop23       # 0: down to label0
# %bb.8:                                # %if.end
	i32.load	$push25=, 40($0)
	i32.const	$push24=, 7
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label0
# %bb.9:                                # %lor.lhs.false24
	i32.const	$push27=, 44
	i32.add 	$push28=, $0, $pop27
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 8
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.10:                               # %lor.lhs.false28
	i32.const	$push32=, 48
	i32.add 	$push33=, $0, $pop32
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 9
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# %bb.11:                               # %lor.lhs.false33
	i32.const	$push37=, 52
	i32.add 	$push38=, $0, $pop37
	i32.load	$push39=, 0($pop38)
	i32.const	$push40=, 10
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# %bb.12:                               # %lor.lhs.false38
	i32.const	$push42=, 56
	i32.add 	$push43=, $0, $pop42
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 11
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label0
# %bb.13:                               # %lor.lhs.false43
	i32.const	$push47=, 60
	i32.add 	$push48=, $0, $pop47
	i32.load	$push49=, 0($pop48)
	i32.const	$push50=, 12
	i32.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label0
# %bb.14:                               # %lor.lhs.false48
	i32.const	$push52=, 64
	i32.add 	$push53=, $0, $pop52
	i32.load	$push54=, 0($pop53)
	i32.const	$push55=, 13
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label0
# %bb.15:                               # %lor.lhs.false53
	i32.const	$push57=, 68
	i32.add 	$push58=, $0, $pop57
	i32.load	$push59=, 0($pop58)
	i32.const	$push60=, 14
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	0, $pop61       # 0: down to label0
# %bb.16:                               # %lor.lhs.false58
	i32.const	$push62=, 72
	i32.add 	$push63=, $0, $pop62
	i32.load	$push64=, 0($pop63)
	i32.const	$push65=, 15
	i32.ne  	$push66=, $pop64, $pop65
	br_if   	0, $pop66       # 0: down to label0
# %bb.17:                               # %if.end64
	i32.const	$push74=, 0
	i32.const	$push72=, 80
	i32.add 	$push73=, $0, $pop72
	i32.store	__stack_pointer($pop74), $pop73
	i32.const	$push67=, 0
	return  	$pop67
.LBB1_18:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.p2align	2
.Lmain.s:
	.int32	6                       # 0x6
	.int32	12                      # 0xc
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.size	.Lmain.s, 68


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
