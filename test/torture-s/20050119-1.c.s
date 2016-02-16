	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050119-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	block
	i32.load8_u	$push0=, 0($0)
	i32.load8_u	$push1=, 1($0)
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 2($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label0
# BB#2:                                 # %if.end7
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$10=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$10=, 0($2), $10
	i32.const	$push0=, 1
	i32.store8	$push18=, 8($10):p2align=3, $pop0
	tee_local	$push17=, $0=, $pop18
	i32.const	$3=, 8
	i32.add 	$3=, $10, $3
	i32.or  	$push1=, $3, $pop17
	i32.store8	$discard=, 0($pop1), $0
	i32.const	$push2=, 2
	i32.const	$4=, 8
	i32.add 	$4=, $10, $4
	i32.or  	$push3=, $4, $pop2
	i32.const	$push16=, 2
	i32.store8	$discard=, 0($pop3):p2align=1, $pop16
	i32.const	$push7=, 4
	i32.const	$5=, 8
	i32.add 	$5=, $10, $5
	i32.or  	$push8=, $5, $pop7
	i32.const	$push4=, 3
	i32.const	$6=, 8
	i32.add 	$6=, $10, $6
	i32.or  	$push5=, $6, $pop4
	i32.const	$push15=, 3
	i32.store8	$push6=, 0($pop5), $pop15
	i32.store8	$discard=, 0($pop8):p2align=2, $pop6
	i32.const	$push9=, 5
	i32.const	$7=, 8
	i32.add 	$7=, $10, $7
	i32.or  	$push10=, $7, $pop9
	i32.const	$push11=, 258
	i32.store16	$discard=, 0($pop10):p2align=0, $pop11
	i32.const	$push12=, 7
	i32.const	$8=, 8
	i32.add 	$8=, $10, $8
	i32.or  	$push13=, $8, $pop12
	i32.const	$push14=, 0
	i32.store8	$0=, 0($pop13), $pop14
	i32.const	$9=, 8
	i32.add 	$9=, $10, $9
	call    	foo@FUNCTION, $9
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
