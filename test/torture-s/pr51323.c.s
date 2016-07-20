	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51323.c"
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
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 48
	i32.sub 	$push30=, $pop16, $pop17
	i32.store	$0=, __stack_pointer($pop18), $pop30
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	$drop=, v($pop3), $pop2
	i32.const	$push22=, 20
	i32.add 	$push23=, $0, $pop22
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop23, $pop5
	i32.const	$push4=, 4
	i32.store	$push0=, 40($0), $pop4
	i32.store	$drop=, 0($pop6), $pop0
	i64.const	$push7=, 12884901890
	i64.store	$drop=, 32($0), $pop7
	i64.load	$push8=, 32($0)
	i64.store	$drop=, 20($0):p2align=2, $pop8
	i32.const	$push9=, 9
	i32.const	$push24=, 20
	i32.add 	$push25=, $0, $pop24
	call    	bar@FUNCTION, $pop9, $pop25
	i32.const	$push34=, 0
	i32.const	$push10=, 17
	i32.store	$drop=, v($pop34), $pop10
	i32.const	$push26=, 8
	i32.add 	$push27=, $0, $pop26
	i32.const	$push33=, 8
	i32.add 	$push12=, $pop27, $pop33
	i32.const	$push11=, 18
	i32.store	$push1=, 40($0), $pop11
	i32.store	$drop=, 0($pop12), $pop1
	i64.const	$push13=, 73014444048
	i64.store	$drop=, 32($0), $pop13
	i64.load	$push14=, 32($0)
	i64.store	$drop=, 8($0):p2align=2, $pop14
	i32.const	$push32=, 9
	i32.const	$push28=, 8
	i32.add 	$push29=, $0, $pop28
	call    	bar@FUNCTION, $pop32, $pop29
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $0, $pop19
	i32.store	$drop=, __stack_pointer($pop21), $pop20
	i32.const	$push31=, 0
                                        # fallthrough-return: $pop31
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
