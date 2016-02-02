	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050125-1.c"
	.section	.text.seterr,"ax",@progbits
	.hidden	seterr
	.globl	seterr
	.type	seterr,@function
seterr:                                 # @seterr
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.store	$discard=, 8($0), $1
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	seterr, .Lfunc_end0-seterr

	.section	.text.bracket_empty,"ax",@progbits
	.hidden	bracket_empty
	.globl	bracket_empty
	.type	bracket_empty,@function
bracket_empty:                          # @bracket_empty
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	tee_local	$push9=, $1=, $pop0
	i32.load	$push1=, 4($0)
	i32.ge_u	$push2=, $pop9, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %land.lhs.true
	i32.const	$push3=, 1
	i32.add 	$push4=, $1, $pop3
	i32.store	$discard=, 0($0), $pop4
	i32.load8_u	$push5=, 0($1)
	i32.const	$push6=, 93
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB1_3:                                # %lor.lhs.false
	end_block                       # label0:
	i32.const	$push8=, 7
	i32.store	$discard=, 8($0), $pop8
	return
	.endfunc
.Lfunc_end1:
	.size	bracket_empty, .Lfunc_end1-bracket_empty

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
