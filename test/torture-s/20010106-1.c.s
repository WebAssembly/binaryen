	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010106-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 2
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	i32.const	$push0=, 7
	i32.ge_u	$push1=, $pop6, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push9=, 2
	i32.shl 	$push2=, $0, $pop9
	i32.const	$push3=, .Lswitch.table
	i32.add 	$push4=, $pop2, $pop3
	i32.load	$push5=, 0($pop4)
	return  	$pop5
.LBB0_2:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table,@object  # @switch.table
	.section	.rodata..Lswitch.table,"a",@progbits
	.p2align	4
.Lswitch.table:
	.int32	33                      # 0x21
	.int32	0                       # 0x0
	.int32	7                       # 0x7
	.int32	4                       # 0x4
	.int32	3                       # 0x3
	.int32	15                      # 0xf
	.int32	9                       # 0x9
	.size	.Lswitch.table, 28


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
