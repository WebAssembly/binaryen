	.text
	.file	"931004-11.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end11
	i32.load8_u	$push9=, 0($2)
	i32.const	$push10=, 11
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end17
	i32.load8_u	$push12=, 1($2)
	i32.const	$push13=, 21
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %if.end23
	i32.load8_u	$push15=, 2($2)
	i32.const	$push16=, 31
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# %bb.6:                                # %if.end29
	i32.load8_u	$push18=, 0($3)
	i32.const	$push19=, 12
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.7:                                # %if.end35
	i32.load8_u	$push21=, 1($3)
	i32.const	$push22=, 22
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.8:                                # %if.end41
	i32.load8_u	$push24=, 2($3)
	i32.const	$push25=, 32
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# %bb.9:                                # %if.end47
	i32.const	$push27=, 123
	i32.ne  	$push28=, $4, $pop27
	br_if   	0, $pop28       # 0: down to label0
# %bb.10:                               # %if.end51
	return  	$2
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 32
	i32.sub 	$0=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $0
	i32.const	$push0=, 186520586
	i32.store	16($0), $pop0
	i32.const	$push22=, 12
	i32.add 	$push23=, $0, $pop22
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop23, $pop1
	i32.load8_u	$push3=, 18($0)
	i32.store8	0($pop2), $pop3
	i32.const	$push4=, 7957
	i32.store16	20($0), $pop4
	i32.const	$push24=, 8
	i32.add 	$push25=, $0, $pop24
	i32.const	$push35=, 2
	i32.add 	$push5=, $pop25, $pop35
	i32.load8_u	$push6=, 21($0)
	i32.store8	0($pop5), $pop6
	i32.const	$push7=, 8214
	i32.store16	23($0):p2align=0, $pop7
	i32.const	$push26=, 4
	i32.add 	$push27=, $0, $pop26
	i32.const	$push34=, 2
	i32.add 	$push8=, $pop27, $pop34
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i32.load8_u	$push11=, 0($pop10)
	i32.store8	0($pop8), $pop11
	i32.const	$push12=, 12
	i32.store8	22($0), $pop12
	i32.load16_u	$push13=, 16($0)
	i32.store16	12($0), $pop13
	i32.load16_u	$push14=, 19($0):p2align=0
	i32.store16	8($0), $pop14
	i32.load16_u	$push15=, 22($0)
	i32.store16	4($0), $pop15
	i32.const	$push28=, 12
	i32.add 	$push29=, $0, $pop28
	i32.const	$push30=, 8
	i32.add 	$push31=, $0, $pop30
	i32.const	$push32=, 4
	i32.add 	$push33=, $0, $pop32
	i32.const	$push16=, 123
	i32.call	$drop=, f@FUNCTION, $0, $pop29, $pop31, $pop33, $pop16
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
