	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081117-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($0)
	i64.const	$push1=, 16
	i64.shr_u	$push2=, $pop0, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.eq  	$push4=, $pop3, $1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push14=, $pop4, $pop5
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop6), $pop13
	i32.const	$push12=, 0
	i64.load	$push0=, s($pop12)
	i64.store	8($0), $pop0
	block   	
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.const	$push1=, -2023406815
	i32.call	$push2=, f@FUNCTION, $pop11, $pop1
	i32.eqz 	$push16=, $pop2
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	3
s:
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.int8	33                      # 0x21
	.int8	67                      # 0x43
	.int8	101                     # 0x65
	.int8	135                     # 0x87
	.int8	2                       # 0x2
	.int8	0                       # 0x0
	.size	s, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
