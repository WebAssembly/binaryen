	.text
	.file	"strct-varg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 16
	i32.sub 	$push32=, $pop24, $pop26
	tee_local	$push31=, $2=, $pop32
	i32.store	__stack_pointer($pop27), $pop31
	i32.store	12($2), $1
	block   	
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push34=, 12($2)
	tee_local	$push33=, $0=, $pop34
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop33, $pop2
	i32.store	12($2), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$push5=, 43690
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	i32.load	$push7=, 4($0)
	i32.const	$push8=, 21845
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %if.end5
	i32.const	$push10=, 12
	i32.add 	$push36=, $0, $pop10
	tee_local	$push35=, $1=, $pop36
	i32.store	12($2), $pop35
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 3
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end10
	i32.const	$push16=, 20
	i32.add 	$push17=, $0, $pop16
	i32.store	12($2), $pop17
	i32.load	$push18=, 0($1)
	i32.const	$push19=, 65535
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %lor.lhs.false15
	i32.load	$push21=, 16($0)
	i32.const	$push22=, 4369
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end19
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $2, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	return  	$2
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
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 48
	i32.sub 	$push16=, $pop5, $pop7
	tee_local	$push15=, $0=, $pop16
	i32.store	__stack_pointer($pop8), $pop15
	i64.const	$push0=, 18764712181759
	i64.store	32($0), $pop0
	i64.const	$push1=, 93823560624810
	i64.store	24($0), $pop1
	i64.const	$push14=, 93823560624810
	i64.store	40($0), $pop14
	i64.const	$push13=, 18764712181759
	i64.store	16($0), $pop13
	i32.const	$push2=, 3
	i32.store	4($0), $pop2
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	8($0), $pop10
	i32.const	$push11=, 24
	i32.add 	$push12=, $0, $pop11
	i32.store	0($0), $pop12
	i32.const	$push3=, 2
	i32.call	$drop=, f@FUNCTION, $pop3, $0
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
