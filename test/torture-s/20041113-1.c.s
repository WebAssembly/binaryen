	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041113-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push26=, 3
	i32.add 	$push1=, $pop0, $pop26
	i32.const	$push25=, -4
	i32.and 	$push24=, $pop1, $pop25
	tee_local	$push23=, $1=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	$discard=, 12($5), $pop2
	block
	block
	block
	block
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($5)
	i32.const	$push31=, 3
	i32.add 	$push7=, $pop6, $pop31
	i32.const	$push30=, -4
	i32.and 	$push29=, $pop7, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.const	$push27=, 4
	i32.add 	$push8=, $pop28, $pop27
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 2
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label2
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($5)
	i32.const	$push37=, 3
	i32.add 	$push13=, $pop12, $pop37
	i32.const	$push36=, -4
	i32.and 	$push35=, $pop13, $pop36
	tee_local	$push34=, $1=, $pop35
	i32.const	$push33=, 4
	i32.add 	$push14=, $pop34, $pop33
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($1)
	i32.const	$push32=, 3
	i32.ne  	$push16=, $pop15, $pop32
	br_if   	2, $pop16       # 2: down to label1
# BB#3:                                 # %if.end7
	i32.load	$push17=, 12($5)
	i32.const	$push43=, 3
	i32.add 	$push18=, $pop17, $pop43
	i32.const	$push42=, -4
	i32.and 	$push41=, $pop18, $pop42
	tee_local	$push40=, $1=, $pop41
	i32.const	$push39=, 4
	i32.add 	$push19=, $pop40, $pop39
	i32.store	$discard=, 12($5), $pop19
	i32.load	$push20=, 0($1)
	i32.const	$push38=, 4
	i32.ne  	$push21=, $pop20, $pop38
	br_if   	3, $pop21       # 3: down to label0
# BB#4:                                 # %if.end10
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then3
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then9
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$5=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	i32.const	$push0=, 0
	f64.load	$push1=, a($pop0)
	f64.const	$push2=, 0x1.4p3
	f64.div 	$push3=, $pop1, $pop2
	i32.trunc_s/f64	$2=, $pop3
	i32.const	$push4=, 8
	i32.or  	$push5=, $5, $pop4
	i32.const	$push6=, 3
	i32.store	$discard=, 0($pop5):p2align=3, $pop6
	i32.const	$push7=, 12
	i32.or  	$push8=, $5, $pop7
	i32.store	$discard=, 0($pop8), $2
	i64.const	$push9=, 8589934593
	i64.store	$discard=, 0($5):p2align=4, $pop9
	call    	test@FUNCTION, $2, $5
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
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
