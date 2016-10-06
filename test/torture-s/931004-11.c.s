	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-11.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.load8_u	$push9=, 0($2)
	i32.const	$push10=, 11
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end17
	i32.load8_u	$push12=, 1($2)
	i32.const	$push13=, 21
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end23
	i32.load8_u	$push15=, 2($2)
	i32.const	$push16=, 31
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end29
	i32.load8_u	$push18=, 0($3)
	i32.const	$push19=, 12
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#7:                                 # %if.end35
	i32.load8_u	$push21=, 1($3)
	i32.const	$push22=, 22
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#8:                                 # %if.end41
	i32.load8_u	$push24=, 2($3)
	i32.const	$push25=, 32
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#9:                                 # %if.end47
	i32.const	$push27=, 123
	i32.ne  	$push28=, $4, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#10:                                # %if.end51
	return  	$1
.LBB0_11:                               # %if.then50
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 32
	i32.sub 	$push42=, $pop22, $pop23
	tee_local	$push41=, $1=, $pop42
	i32.store	__stack_pointer($pop24), $pop41
	i32.const	$push0=, 30
	i32.store8	18($1), $pop0
	i32.const	$push1=, 11
	i32.store8	19($1), $pop1
	i32.const	$push2=, 12
	i32.store8	22($1), $pop2
	i32.const	$push3=, 5130
	i32.store16	16($1), $pop3
	i32.const	$push4=, 21
	i32.store8	20($1), $pop4
	i32.const	$push5=, 22
	i32.store8	23($1), $pop5
	i32.const	$push25=, 12
	i32.add 	$push26=, $1, $pop25
	i32.const	$push6=, 2
	i32.add 	$push7=, $pop26, $pop6
	i32.load8_u	$push8=, 18($1)
	i32.store8	0($pop7), $pop8
	i32.const	$push9=, 31
	i32.store8	21($1), $pop9
	i32.const	$push10=, 24
	i32.add 	$push40=, $1, $pop10
	tee_local	$push39=, $0=, $pop40
	i32.const	$push11=, 32
	i32.store8	0($pop39), $pop11
	i32.const	$push27=, 8
	i32.add 	$push28=, $1, $pop27
	i32.const	$push38=, 2
	i32.add 	$push12=, $pop28, $pop38
	i32.load8_u	$push13=, 21($1)
	i32.store8	0($pop12), $pop13
	i32.load16_u	$push14=, 16($1)
	i32.store16	12($1), $pop14
	i32.load16_u	$push15=, 19($1):p2align=0
	i32.store16	8($1), $pop15
	i32.const	$push29=, 4
	i32.add 	$push30=, $1, $pop29
	i32.const	$push37=, 2
	i32.add 	$push16=, $pop30, $pop37
	i32.load8_u	$push17=, 0($0)
	i32.store8	0($pop16), $pop17
	i32.load16_u	$push18=, 22($1)
	i32.store16	4($1), $pop18
	i32.const	$push31=, 12
	i32.add 	$push32=, $1, $pop31
	i32.const	$push33=, 8
	i32.add 	$push34=, $1, $pop33
	i32.const	$push35=, 4
	i32.add 	$push36=, $1, $pop35
	i32.const	$push19=, 123
	i32.call	$drop=, f@FUNCTION, $1, $pop32, $pop34, $pop36, $pop19
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
