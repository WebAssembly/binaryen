	.text
	.file	"931004-5.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load16_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.load16_u	$push3=, 2($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.load16_u	$push6=, 0($2)
	i32.const	$push7=, 11
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end12
	i32.load16_u	$push9=, 2($2)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end18
	i32.load16_u	$push12=, 0($3)
	i32.const	$push13=, 12
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %if.end24
	i32.load16_u	$push15=, 2($3)
	i32.const	$push16=, 22
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# %bb.6:                                # %if.end30
	i32.const	$push18=, 123
	i32.ne  	$push19=, $4, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.7:                                # %if.end34
	return  	$2
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
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i64.const	$push0=, 6192501028618251
	i64.store	20($0):p2align=2, $pop0
	i32.const	$push1=, 1310730
	i32.store	16($0), $pop1
	i32.const	$push16=, 1310730
	i32.store	12($0), $pop16
	i32.load	$push2=, 20($0)
	i32.store	8($0), $pop2
	i32.load	$push3=, 24($0)
	i32.store	4($0), $pop3
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.const	$push4=, 123
	i32.call	$drop=, f@FUNCTION, $0, $pop11, $pop13, $pop15, $pop4
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
