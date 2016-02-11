	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-13.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$push0=, 12($4), $0
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push10=, $0=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($4), $pop6
	block
	i32.load	$push7=, 0($0)
	i32.const	$push8=, 1234
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$push22=, 4
	i32.or  	$push0=, $7, $pop22
	tee_local	$push21=, $3=, $pop0
	i32.store	$push1=, 0($pop21), $1
	i32.store	$push2=, 12($7), $pop1
	tee_local	$push20=, $2=, $pop2
	i32.const	$push19=, 3
	i32.add 	$push3=, $pop20, $pop19
	i32.const	$push18=, -4
	i32.and 	$push4=, $pop3, $pop18
	tee_local	$push17=, $1=, $pop4
	i32.const	$push16=, 4
	i32.add 	$push5=, $pop17, $pop16
	i32.store	$discard=, 12($7), $pop5
	block
	i32.load	$push6=, 0($1)
	i32.const	$push15=, 1234
	i32.ne  	$push7=, $pop6, $pop15
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %dummy.exit
	i32.store	$discard=, 0($3), $2
	i32.load	$push8=, 0($3)
	i32.store	$push9=, 12($7), $pop8
	i32.const	$push27=, 3
	i32.add 	$push10=, $pop9, $pop27
	i32.const	$push26=, -4
	i32.and 	$push11=, $pop10, $pop26
	tee_local	$push25=, $3=, $pop11
	i32.const	$push24=, 4
	i32.add 	$push12=, $pop25, $pop24
	i32.store	$discard=, 12($7), $pop12
	block
	i32.load	$push13=, 0($3)
	i32.const	$push23=, 1234
	i32.ne  	$push14=, $pop13, $pop23
	br_if   	0, $pop14       # 0: down to label2
# BB#2:                                 # %dummy.exit16
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return
.LBB1_3:                                # %if.then.i15
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 1234
	i32.store	$discard=, 0($3):p2align=4, $pop0
	call    	test@FUNCTION, $0, $3
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
