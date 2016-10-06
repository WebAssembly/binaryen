	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51323.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 9
	i32.ne  	$push2=, $2, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	br_if   	0, $1           # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push0=, v($pop3)
	i32.ne  	$push4=, $pop0, $0
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 0
	call    	foo@FUNCTION, $pop0, $pop1, $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 48
	i32.sub 	$push35=, $pop14, $pop15
	tee_local	$push34=, $0=, $pop35
	i32.store	__stack_pointer($pop16), $pop34
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	v($pop1), $pop0
	i32.const	$push2=, 4
	i32.store	40($0), $pop2
	i32.const	$push20=, 20
	i32.add 	$push21=, $0, $pop20
	i32.const	$push3=, 8
	i32.add 	$push4=, $pop21, $pop3
	i32.const	$push33=, 4
	i32.store	0($pop4), $pop33
	i64.const	$push5=, 12884901890
	i64.store	32($0), $pop5
	i64.load	$push6=, 32($0)
	i64.store	20($0):p2align=2, $pop6
	i32.const	$push7=, 9
	i32.const	$push22=, 20
	i32.add 	$push23=, $0, $pop22
	call    	bar@FUNCTION, $pop7, $pop23
	i32.const	$push32=, 0
	i32.const	$push8=, 17
	i32.store	v($pop32), $pop8
	i32.const	$push9=, 18
	i32.store	40($0), $pop9
	i32.const	$push24=, 8
	i32.add 	$push25=, $0, $pop24
	i32.const	$push31=, 8
	i32.add 	$push10=, $pop25, $pop31
	i32.const	$push30=, 18
	i32.store	0($pop10), $pop30
	i64.const	$push11=, 73014444048
	i64.store	32($0), $pop11
	i64.load	$push12=, 32($0)
	i64.store	8($0):p2align=2, $pop12
	i32.const	$push29=, 9
	i32.const	$push26=, 8
	i32.add 	$push27=, $0, $pop26
	call    	bar@FUNCTION, $pop29, $pop27
	i32.const	$push19=, 0
	i32.const	$push17=, 48
	i32.add 	$push18=, $0, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	i32.const	$push28=, 0
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
