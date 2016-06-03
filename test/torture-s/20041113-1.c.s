	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041113-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 16
	i32.sub 	$push27=, $pop21, $pop22
	i32.store	$push31=, __stack_pointer($pop23), $pop27
	tee_local	$push30=, $4=, $pop31
	i32.store	$push29=, 12($4), $1
	tee_local	$push28=, $1=, $pop29
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop28, $pop0
	i32.store	$2=, 12($pop30), $pop1
	block
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	$3=, 12($4), $pop6
	i32.load	$push7=, 0($2)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push10=, 12
	i32.add 	$push11=, $1, $pop10
	i32.store	$2=, 12($4), $pop11
	i32.load	$push12=, 0($3)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 16
	i32.add 	$push16=, $1, $pop15
	i32.store	$drop=, 12($4), $pop16
	i32.load	$push17=, 0($2)
	i32.const	$push18=, 4
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $4, $pop24
	i32.store	$drop=, __stack_pointer($pop26), $pop25
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
	i32.sub 	$push12=, $pop9, $pop10
	i32.store	$push15=, __stack_pointer($pop11), $pop12
	tee_local	$push14=, $2=, $pop15
	i32.const	$push0=, 3
	i32.store	$drop=, 8($pop14), $pop0
	i32.const	$push1=, 2
	i32.store	$drop=, 4($2), $pop1
	i32.const	$push2=, 1
	i32.store	$drop=, 0($2), $pop2
	i32.const	$push3=, 0
	f64.load	$push4=, a($pop3)
	f64.const	$push5=, 0x1.4p3
	f64.div 	$push6=, $pop4, $pop5
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	$drop=, 12($2), $pop7
	call    	test@FUNCTION, $2, $2
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
