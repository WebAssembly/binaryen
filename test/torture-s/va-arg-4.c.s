	.text
	.file	"va-arg-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.load	$push20=, __stack_pointer($pop21)
	i32.const	$push22=, 16
	i32.sub 	$4=, $pop20, $pop22
	i32.const	$push23=, 0
	i32.store	__stack_pointer($pop23), $4
	block   	
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 97
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load8_u	$push3=, 1($0)
	i32.const	$push4=, 98
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %lor.lhs.false7
	i32.load8_u	$push6=, 2($0)
	i32.const	$push7=, 99
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end
	i32.const	$push9=, 4
	i32.add 	$0=, $2, $pop9
	i32.store	12($4), $0
	i32.load	$push10=, 0($2)
	i32.const	$push11=, 42
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.4:                                # %if.end17
	i32.const	$push13=, 8
	i32.add 	$3=, $2, $pop13
	i32.store	12($4), $3
	i32.load	$push14=, 0($0)
	i32.const	$push15=, 120
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.5:                                # %if.end23
	i32.const	$push17=, 12
	i32.add 	$push18=, $2, $pop17
	i32.store	12($4), $pop18
	i32.load	$push19=, 0($3)
	br_if   	0, $pop19       # 0: down to label0
# %bb.6:                                # %if.end29
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $4, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	return
.LBB0_7:                                # %if.then
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
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 48
	i32.sub 	$0=, $pop13, $pop15
	i32.const	$push16=, 0
	i32.store	__stack_pointer($pop16), $0
	i32.const	$push2=, 40
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, main.x+24($pop0):p2align=0
	i64.store	0($pop3), $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $0, $pop5
	i32.const	$push22=, 0
	i64.load	$push4=, main.x+16($pop22):p2align=0
	i64.store	0($pop6), $pop4
	i32.const	$push8=, 24
	i32.add 	$push9=, $0, $pop8
	i32.const	$push21=, 0
	i64.load	$push7=, main.x+8($pop21):p2align=0
	i64.store	0($pop9), $pop7
	i64.const	$push10=, 120
	i64.store	4($0):p2align=2, $pop10
	i32.const	$push11=, 42
	i32.store	0($0), $pop11
	i32.const	$push20=, 0
	i64.load	$push12=, main.x($pop20):p2align=0
	i64.store	16($0), $pop12
	i32.const	$push17=, 16
	i32.add 	$push18=, $0, $pop17
	call    	f@FUNCTION, $pop18, $0, $0
	i32.const	$push19=, 0
	call    	exit@FUNCTION, $pop19
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.x,@object          # @main.x
	.section	.data.main.x,"aw",@progbits
main.x:
	.asciz	"abc\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	main.x, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
