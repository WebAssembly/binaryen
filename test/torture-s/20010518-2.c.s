	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push26=, 0
	i32.load	$push27=, __stack_pointer($pop26)
	i32.const	$push28=, 48
	i32.sub 	$push35=, $pop27, $pop28
	tee_local	$push34=, $0=, $pop35
	i32.store	__stack_pointer($pop29), $pop34
	i32.const	$push0=, 1
	i32.store16	28($0), $pop0
	i32.const	$push33=, 2
	i32.store	24($0), $pop33
	i32.const	$push1=, 3
	i32.store16	22($0), $pop1
	i32.const	$push2=, 4
	i32.store16	20($0), $pop2
	i32.const	$push3=, 0
	i32.store	16($0), $pop3
	i32.const	$push32=, 0
	i32.store8	15($0), $pop32
	i32.const	$push31=, 0
	i32.store8	14($0), $pop31
	i32.load16_u	$push4=, 28($0)
	i32.store16	46($0), $pop4
	i32.load	$push5=, 24($0)
	i32.store	40($0), $pop5
	i32.load16_u	$push6=, 22($0)
	i32.store16	38($0), $pop6
	i32.load16_u	$push7=, 20($0)
	i32.store16	36($0), $pop7
	i32.load	$push8=, 16($0)
	i32.store	32($0), $pop8
	i32.load8_u	$push9=, 15($0)
	i32.store8	31($0), $pop9
	i32.load8_u	$push10=, 14($0)
	i32.store8	30($0), $pop10
	i32.const	$push11=, 99
	i32.store8	31($0), $pop11
	block   	
	i32.load16_u	$push12=, 46($0)
	i32.const	$push30=, 1
	i32.ne  	$push13=, $pop12, $pop30
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push14=, 40($0)
	i32.const	$push36=, 2
	i32.ne  	$push15=, $pop14, $pop36
	br_if   	0, $pop15       # 0: down to label0
# BB#2:                                 # %lor.lhs.false9
	i32.load16_u	$push17=, 38($0)
	i32.const	$push16=, 3
	i32.ne  	$push18=, $pop17, $pop16
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %lor.lhs.false14
	i32.load16_u	$push20=, 36($0)
	i32.const	$push19=, 4
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	0, $pop21       # 0: down to label0
# BB#4:                                 # %lor.lhs.false19
	i32.load8_u	$push23=, 31($0)
	i32.const	$push22=, 99
	i32.ne  	$push24=, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
