	.text
	.file	"931004-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 16
	i32.sub 	$3=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $3
	i32.const	$push26=, 4
	i32.add 	$push1=, $1, $pop26
	i32.store	12($3), $pop1
	block   	
	block   	
	i32.const	$push25=, 1
	i32.lt_s	$push2=, $0, $pop25
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push27=, 10
	i32.add 	$push3=, $2, $pop27
	i32.load8_s	$push4=, 0($1)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	2, $pop5        # 2: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push29=, 20
	i32.add 	$push7=, $2, $pop29
	i32.const	$push28=, 1
	i32.add 	$push8=, $1, $pop28
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop7, $pop9
	br_if   	2, $pop10       # 2: down to label0
# %bb.4:                                # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push31=, 30
	i32.add 	$push11=, $2, $pop31
	i32.const	$push30=, 2
	i32.add 	$push6=, $1, $pop30
	i32.load8_s	$push0=, 0($pop6)
	i32.ne  	$push12=, $pop11, $pop0
	br_if   	2, $pop12       # 2: down to label0
# %bb.5:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push34=, 1
	i32.add 	$2=, $2, $pop34
	i32.const	$push33=, 8
	i32.add 	$push13=, $1, $pop33
	i32.store	12($3), $pop13
	i32.const	$push32=, 4
	i32.add 	$1=, $1, $pop32
	i32.lt_s	$push14=, $2, $0
	br_if   	0, $pop14       # 0: up to label2
.LBB0_6:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push15=, 0($1)
	i32.const	$push16=, 123
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# %bb.7:                                # %if.end22
	i32.const	$push24=, 0
	i32.const	$push22=, 16
	i32.add 	$push23=, $3, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	return  	$1
.LBB0_8:                                # %if.then
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
	i32.const	$push20=, 0
	i32.load	$push19=, __stack_pointer($pop20)
	i32.const	$push21=, 48
	i32.sub 	$0=, $pop19, $pop21
	i32.const	$push22=, 0
	i32.store	__stack_pointer($pop22), $0
	i32.const	$push0=, 186520586
	i32.store	32($0), $pop0
	i32.const	$push23=, 28
	i32.add 	$push24=, $0, $pop23
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop24, $pop1
	i32.load8_u	$push3=, 34($0)
	i32.store8	0($pop2), $pop3
	i32.const	$push4=, 7957
	i32.store16	36($0), $pop4
	i32.const	$push25=, 24
	i32.add 	$push26=, $0, $pop25
	i32.const	$push36=, 2
	i32.add 	$push5=, $pop26, $pop36
	i32.load8_u	$push6=, 37($0)
	i32.store8	0($pop5), $pop6
	i32.const	$push7=, 8214
	i32.store16	39($0):p2align=0, $pop7
	i32.const	$push27=, 20
	i32.add 	$push28=, $0, $pop27
	i32.const	$push35=, 2
	i32.add 	$push8=, $pop28, $pop35
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i32.load8_u	$push11=, 0($pop10)
	i32.store8	0($pop8), $pop11
	i32.const	$push12=, 12
	i32.store8	38($0), $pop12
	i32.load16_u	$push13=, 32($0)
	i32.store16	28($0), $pop13
	i32.load16_u	$push14=, 35($0):p2align=0
	i32.store16	24($0), $pop14
	i32.load16_u	$push15=, 38($0)
	i32.store16	20($0), $pop15
	i32.const	$push16=, 123
	i32.store	12($0), $pop16
	i32.const	$push29=, 20
	i32.add 	$push30=, $0, $pop29
	i32.store	8($0), $pop30
	i32.const	$push31=, 24
	i32.add 	$push32=, $0, $pop31
	i32.store	4($0), $pop32
	i32.const	$push33=, 28
	i32.add 	$push34=, $0, $pop33
	i32.store	0($0), $pop34
	i32.const	$push17=, 3
	i32.call	$drop=, f@FUNCTION, $pop17, $0
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
