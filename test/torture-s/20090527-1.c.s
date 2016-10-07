	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090527-1.c"
	.section	.text.new_unit,"ax",@progbits
	.hidden	new_unit
	.globl	new_unit
	.type	new_unit,@function
new_unit:                               # @new_unit
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push8=, 4($0)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push6=, 1
	i32.ne  	$push0=, $pop7, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$1=, 0
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.const	$push9=, 0
	i32.store	0($pop2), $pop9
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.load	$push3=, 0($0)
	i32.const	$push10=, 1
	i32.ne  	$push4=, $pop3, $pop10
	br_if   	0, $pop4        # 0: down to label1
# BB#3:                                 # %if.then3
	i32.const	$push5=, 0
	i32.store	0($0), $pop5
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
