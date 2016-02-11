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
	i32.const	$push29=, 3
	i32.add 	$push1=, $pop0, $pop29
	i32.const	$push28=, -4
	i32.and 	$push2=, $pop1, $pop28
	tee_local	$push27=, $1=, $pop2
	i32.const	$push26=, 4
	i32.add 	$push3=, $pop27, $pop26
	i32.store	$discard=, 12($5), $pop3
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($5)
	i32.const	$push33=, 3
	i32.add 	$push8=, $pop7, $pop33
	i32.const	$push32=, -4
	i32.and 	$push9=, $pop8, $pop32
	tee_local	$push31=, $1=, $pop9
	i32.const	$push30=, 4
	i32.add 	$push10=, $pop31, $pop30
	i32.store	$discard=, 12($5), $pop10
	block
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 2
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($5)
	i32.const	$push38=, 3
	i32.add 	$push15=, $pop14, $pop38
	i32.const	$push37=, -4
	i32.and 	$push16=, $pop15, $pop37
	tee_local	$push36=, $1=, $pop16
	i32.const	$push35=, 4
	i32.add 	$push17=, $pop36, $pop35
	i32.store	$discard=, 12($5), $pop17
	block
	i32.load	$push18=, 0($1)
	i32.const	$push34=, 3
	i32.ne  	$push19=, $pop18, $pop34
	br_if   	0, $pop19       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push20=, 12($5)
	i32.const	$push43=, 3
	i32.add 	$push21=, $pop20, $pop43
	i32.const	$push42=, -4
	i32.and 	$push22=, $pop21, $pop42
	tee_local	$push41=, $1=, $pop22
	i32.const	$push40=, 4
	i32.add 	$push23=, $pop41, $pop40
	i32.store	$discard=, 12($5), $pop23
	block
	i32.load	$push24=, 0($1)
	i32.const	$push39=, 4
	i32.ne  	$push25=, $pop24, $pop39
	br_if   	0, $pop25       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_5:                                # %if.then9
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
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
