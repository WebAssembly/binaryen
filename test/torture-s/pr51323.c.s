	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51323.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 9
	i32.ne  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %entry
	br_if   	0, $1           # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, v($pop1)
	i32.ne  	$push4=, $pop0, $0
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 0
	call    	foo@FUNCTION, $pop0, $pop1, $0
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$9=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$9=, 0($2), $9
	i32.const	$push3=, 2
	i32.store	$discard=, 32($9):p2align=3, $pop3
	i32.const	$push4=, 4
	i32.const	$4=, 32
	i32.add 	$4=, $9, $4
	i32.or  	$push5=, $4, $pop4
	tee_local	$push23=, $0=, $pop5
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	$push2=, v($pop1), $pop0
	i32.store	$discard=, 0($pop23), $pop2
	i32.const	$push7=, 8
	i32.const	$5=, 20
	i32.add 	$5=, $9, $5
	i32.add 	$push8=, $5, $pop7
	i32.const	$push22=, 4
	i32.store	$push6=, 40($9):p2align=3, $pop22
	i32.store	$discard=, 0($pop8), $pop6
	i64.load	$push9=, 32($9)
	i64.store	$discard=, 20($9):p2align=2, $pop9
	i32.const	$push10=, 9
	i32.const	$6=, 20
	i32.add 	$6=, $9, $6
	call    	bar@FUNCTION, $pop10, $6
	i32.const	$push21=, 0
	i32.const	$push11=, 17
	i32.store	$push12=, v($pop21), $pop11
	i32.store	$discard=, 0($0), $pop12
	i32.const	$push13=, 16
	i32.store	$discard=, 32($9):p2align=3, $pop13
	i32.const	$push20=, 8
	i32.const	$7=, 8
	i32.add 	$7=, $9, $7
	i32.add 	$push16=, $7, $pop20
	i32.const	$push14=, 18
	i32.store	$push15=, 40($9):p2align=3, $pop14
	i32.store	$discard=, 0($pop16), $pop15
	i64.load	$push17=, 32($9)
	i64.store	$discard=, 8($9):p2align=2, $pop17
	i32.const	$push19=, 9
	i32.const	$8=, 8
	i32.add 	$8=, $9, $8
	call    	bar@FUNCTION, $pop19, $8
	i32.const	$push18=, 0
	i32.const	$3=, 48
	i32.add 	$9=, $9, $3
	i32.const	$3=, __stack_pointer
	i32.store	$9=, 0($3), $9
	return  	$pop18
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4


	.ident	"clang version 3.9.0 "
