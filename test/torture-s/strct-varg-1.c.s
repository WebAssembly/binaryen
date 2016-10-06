	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-varg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push32=, $pop25, $pop26
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
.LBB0_7:                                # %if.then18
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 48
	i32.sub 	$push19=, $pop11, $pop12
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop13), $pop18
	i64.const	$push0=, 93823560624810
	i64.store	40($0), $pop0
	i64.const	$push1=, 18764712181759
	i64.store	32($0), $pop1
	i64.load	$push2=, 40($0)
	i64.store	24($0):p2align=2, $pop2
	i32.const	$push3=, 20
	i32.add 	$push4=, $0, $pop3
	i32.load	$push5=, 36($0)
	i32.store	0($pop4), $pop5
	i32.load	$push6=, 32($0)
	i32.store	16($0), $pop6
	i32.const	$push7=, 3
	i32.store	4($0), $pop7
	i32.const	$push14=, 24
	i32.add 	$push15=, $0, $pop14
	i32.store	0($0), $pop15
	i32.const	$push16=, 16
	i32.add 	$push17=, $0, $pop16
	i32.store	8($0), $pop17
	i32.const	$push8=, 2
	i32.call	$drop=, f@FUNCTION, $pop8, $0
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
