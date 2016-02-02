	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020118-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push0=, q($pop34)
	tee_local	$push33=, $0=, $pop0
	i32.load8_s	$push1=, 2($pop33)
	i32.store	$discard=, n($pop35), $pop1
	i32.const	$push32=, 0
	i32.load8_s	$push2=, 2($0)
	i32.store	$discard=, n($pop32), $pop2
	i32.const	$push31=, 0
	i32.load8_s	$push3=, 2($0)
	i32.store	$discard=, n($pop31), $pop3
	i32.const	$push30=, 0
	i32.load8_s	$push4=, 2($0)
	i32.store	$discard=, n($pop30), $pop4
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push5=, q($pop28)
	tee_local	$push27=, $0=, $pop5
	i32.load8_s	$push6=, 2($pop27)
	i32.store	$discard=, n($pop29), $pop6
	i32.const	$push26=, 0
	i32.load8_s	$push7=, 2($0)
	i32.store	$discard=, n($pop26), $pop7
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push8=, q($pop24)
	tee_local	$push23=, $0=, $pop8
	i32.load8_s	$push9=, 2($pop23)
	i32.store	$discard=, n($pop25), $pop9
	i32.const	$push22=, 0
	i32.load8_s	$push10=, 2($0)
	i32.store	$discard=, n($pop22), $pop10
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push11=, q($pop20)
	tee_local	$push19=, $0=, $pop11
	i32.load8_s	$push12=, 2($pop19)
	i32.store	$discard=, n($pop21), $pop12
	i32.const	$push18=, 0
	i32.load8_s	$push13=, 2($0)
	i32.store	$discard=, n($pop18), $pop13
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push14=, q($pop16)
	i32.load8_s	$push15=, 2($pop14)
	i32.store	$discard=, n($pop17), $pop15
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 3.9.0 "
