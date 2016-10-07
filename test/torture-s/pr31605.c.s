	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31605.c"
	.section	.text.put_field,"ax",@progbits
	.hidden	put_field
	.globl	put_field
	.type	put_field,@function
put_field:                              # @put_field
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.add 	$push0=, $1, $0
	i32.const	$push1=, -8
	i32.or  	$push2=, $pop0, $pop1
	i32.const	$push5=, -8
	i32.ne  	$push3=, $pop2, $pop5
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end0:
	.size	put_field, .Lfunc_end0-put_field

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	call    	put_field@FUNCTION, $pop1, $pop0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
