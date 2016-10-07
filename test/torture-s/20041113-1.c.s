	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041113-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push27=, $pop18, $pop19
	tee_local	$push26=, $4=, $pop27
	i32.store	__stack_pointer($pop20), $pop26
	i32.store	12($4), $1
	i32.const	$push0=, 4
	i32.add 	$push25=, $1, $pop0
	tee_local	$push24=, $2=, $pop25
	i32.store	12($4), $pop24
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 8
	i32.add 	$push29=, $1, $pop4
	tee_local	$push28=, $3=, $pop29
	i32.store	12($4), $pop28
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push31=, $1, $pop8
	tee_local	$push30=, $2=, $pop31
	i32.store	12($4), $pop30
	i32.load	$push9=, 0($3)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push12=, 16
	i32.add 	$push13=, $1, $pop12
	i32.store	12($4), $pop13
	i32.load	$push14=, 0($2)
	i32.const	$push15=, 4
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $4, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB0_5:                                # %if.then15
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push14=, $pop9, $pop10
	tee_local	$push13=, $2=, $pop14
	i32.store	__stack_pointer($pop11), $pop13
	i32.const	$push0=, 3
	i32.store	8($2), $pop0
	i32.const	$push1=, 2
	i32.store	4($2), $pop1
	i32.const	$push2=, 1
	i32.store	0($2), $pop2
	i32.const	$push3=, 0
	f64.load	$push4=, a($pop3)
	f64.const	$push5=, 0x1.4p3
	f64.div 	$push6=, $pop4, $pop5
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	12($2), $pop7
	call    	test@FUNCTION, $2, $2
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int64	4630826316843712512     # double 40
	.size	a, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
