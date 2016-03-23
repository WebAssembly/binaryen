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
	i32.const	$push2=, 9
	i32.ne  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %entry
	br_if   	0, $1           # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, v($pop1)
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
	return
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
	i32.const	$push21=, __stack_pointer
	i32.load	$push22=, 0($pop21)
	i32.const	$push23=, 48
	i32.sub 	$0=, $pop22, $pop23
	i32.const	$push24=, __stack_pointer
	i32.store	$discard=, 0($pop24), $0
	i32.const	$push3=, 2
	i32.store	$discard=, 32($0):p2align=3, $pop3
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	$push2=, v($pop1), $pop0
	i32.store	$discard=, 36($0), $pop2
	i32.const	$push28=, 20
	i32.add 	$push29=, $0, $pop28
	i32.const	$push6=, 8
	i32.add 	$push7=, $pop29, $pop6
	i32.const	$push4=, 4
	i32.store	$push5=, 40($0):p2align=3, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i64.load	$push8=, 32($0)
	i64.store	$discard=, 20($0):p2align=2, $pop8
	i32.const	$push9=, 9
	i32.const	$push30=, 20
	i32.add 	$push31=, $0, $pop30
	call    	bar@FUNCTION, $pop9, $pop31
	i32.const	$push12=, 16
	i32.store	$discard=, 32($0):p2align=3, $pop12
	i32.const	$push20=, 0
	i32.const	$push10=, 17
	i32.store	$push11=, v($pop20), $pop10
	i32.store	$discard=, 36($0), $pop11
	i32.const	$push32=, 8
	i32.add 	$push33=, $0, $pop32
	i32.const	$push19=, 8
	i32.add 	$push15=, $pop33, $pop19
	i32.const	$push13=, 18
	i32.store	$push14=, 40($0):p2align=3, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	i64.load	$push16=, 32($0)
	i64.store	$discard=, 8($0):p2align=2, $pop16
	i32.const	$push18=, 9
	i32.const	$push34=, 8
	i32.add 	$push35=, $0, $pop34
	call    	bar@FUNCTION, $pop18, $pop35
	i32.const	$push17=, 0
	i32.const	$push27=, __stack_pointer
	i32.const	$push25=, 48
	i32.add 	$push26=, $0, $pop25
	i32.store	$discard=, 0($pop27), $pop26
	return  	$pop17
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


	.ident	"clang version 3.9.0 "
