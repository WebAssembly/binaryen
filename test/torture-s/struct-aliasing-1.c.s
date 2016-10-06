	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-aliasing-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.load	$push1=, 0($1)
	i32.add 	$push2=, $2, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push17=, $pop5, $pop6
	tee_local	$push16=, $0=, $pop17
	i32.store	__stack_pointer($pop7), $pop16
	i32.const	$push0=, 1
	i32.store	12($0), $pop0
	block   	
	i32.const	$push11=, 12
	i32.add 	$push12=, $0, $pop11
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.call	$push1=, foo@FUNCTION, $pop12, $pop14
	i32.const	$push15=, 1
	i32.ne  	$push2=, $pop1, $pop15
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
