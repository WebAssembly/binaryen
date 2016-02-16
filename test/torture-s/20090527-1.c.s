	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090527-1.c"
	.section	.text.new_unit,"ax",@progbits
	.hidden	new_unit
	.globl	new_unit
	.type	new_unit,@function
new_unit:                               # @new_unit
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push9=, 4($0)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 1
	i32.ne  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.const	$push1=, 0
	i32.store	$1=, 0($pop3), $pop1
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.load	$push4=, 0($0)
	i32.const	$push10=, 1
	i32.ne  	$push5=, $pop4, $pop10
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %if.then3
	i32.const	$push6=, 0
	i32.store	$discard=, 0($0), $pop6
.LBB0_4:                                # %if.end5
	end_block                       # label1:
	block
	br_if   	0, $1           # 0: down to label2
# BB#5:                                 # %sw.epilog
	return
.LBB0_6:                                # %sw.default
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	new_unit, .Lfunc_end0-new_unit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %new_unit.exit
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
