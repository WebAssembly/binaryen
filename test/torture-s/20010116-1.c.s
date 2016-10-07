	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010116-1.c"
	.section	.text.find,"ax",@progbits
	.hidden	find
	.globl	find
	.type	find,@function
find:                                   # @find
	.param  	i32, i32
# BB#0:                                 # %for.cond
	block   	
	i32.sub 	$push0=, $1, $0
	i32.const	$push1=, 12
	i32.div_s	$push2=, $pop0, $pop1
	i32.const	$push3=, 2
	i32.shr_s	$push7=, $pop2, $pop3
	tee_local	$push6=, $1=, $pop7
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $pop6, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %for.body
	call    	ok@FUNCTION, $1
	unreachable
.LBB0_2:                                # %for.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	find, .Lfunc_end0-find

	.section	.text.ok,"ax",@progbits
	.hidden	ok
	.globl	ok
	.type	ok,@function
ok:                                     # @ok
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ok, .Lfunc_end1-ok

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 48
	i32.sub 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.store	__stack_pointer($pop5), $pop6
	i32.const	$push0=, 48
	i32.add 	$push1=, $0, $pop0
	call    	find@FUNCTION, $0, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
