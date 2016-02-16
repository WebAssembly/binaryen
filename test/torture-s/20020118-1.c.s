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
	i32.load	$push33=, q($pop34)
	tee_local	$push32=, $0=, $pop33
	i32.load8_s	$push0=, 2($pop32)
	i32.store	$discard=, n($pop35), $pop0
	i32.const	$push31=, 0
	i32.load8_s	$push1=, 2($0)
	i32.store	$discard=, n($pop31), $pop1
	i32.const	$push30=, 0
	i32.load8_s	$push2=, 2($0)
	i32.store	$discard=, n($pop30), $pop2
	i32.const	$push29=, 0
	i32.load8_s	$push3=, 2($0)
	i32.store	$discard=, n($pop29), $pop3
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push26=, q($pop27)
	tee_local	$push25=, $0=, $pop26
	i32.load8_s	$push4=, 2($pop25)
	i32.store	$discard=, n($pop28), $pop4
	i32.const	$push24=, 0
	i32.load8_s	$push5=, 2($0)
	i32.store	$discard=, n($pop24), $pop5
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, q($pop22)
	tee_local	$push20=, $0=, $pop21
	i32.load8_s	$push6=, 2($pop20)
	i32.store	$discard=, n($pop23), $pop6
	i32.const	$push19=, 0
	i32.load8_s	$push7=, 2($0)
	i32.store	$discard=, n($pop19), $pop7
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load	$push16=, q($pop17)
	tee_local	$push15=, $0=, $pop16
	i32.load8_s	$push8=, 2($pop15)
	i32.store	$discard=, n($pop18), $pop8
	i32.const	$push14=, 0
	i32.load8_s	$push9=, 2($0)
	i32.store	$discard=, n($pop14), $pop9
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.load	$push10=, q($pop12)
	i32.load8_s	$push11=, 2($pop10)
	i32.store	$discard=, n($pop13), $pop11
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
