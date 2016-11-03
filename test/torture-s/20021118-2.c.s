	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021118-2.c"
	.section	.text.t1,"ax",@progbits
	.hidden	t1
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	f64.const	$push0=, 0x1.8p1
	call_indirect	$pop0, $2
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.add 	$push9=, $0, $pop2
	tee_local	$push8=, $0=, $pop9
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	i32.load	$push5=, 0($pop4)
	i32.store	0($pop8), $pop5
	f32.const	$push7=, 0x1.4p1
	f32.const	$push6=, 0x1.cp1
	call_indirect	$pop7, $pop6, $3
	copy_local	$push10=, $3
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1

	.section	.text.t2,"ax",@progbits
	.hidden	t2
	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x1.8p2
	call_indirect	$pop0, $4
	f64.const	$push1=, 0x1.8p1
	call_indirect	$pop1, $2
	i32.const	$push2=, 2
	i32.shl 	$push3=, $1, $pop2
	i32.add 	$push10=, $0, $pop3
	tee_local	$push9=, $0=, $pop10
	i32.const	$push4=, 4
	i32.add 	$push5=, $0, $pop4
	i32.load	$push6=, 0($pop5)
	i32.store	0($pop9), $pop6
	f32.const	$push8=, 0x1.4p1
	f32.const	$push7=, 0x1.cp1
	call_indirect	$pop8, $pop7, $3
	copy_local	$push11=, $3
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	f64
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, 0x1.8p1
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f32, f32
# BB#0:                                 # %entry
	block   	
	f32.const	$push0=, 0x1.4p1
	f32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	f32.const	$push2=, 0x1.cp1
	f32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %if.end
	return
.LBB3_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	f32
# BB#0:                                 # %entry
	block   	
	f32.const	$push0=, 0x1.8p2
	f32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %if.end
	return
.LBB4_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f3, .Lfunc_end4-f3

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
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
