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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, __stack_pointer
	i32.const	$push17=, __stack_pointer
	i32.load	$push18=, 0($pop17)
	i32.const	$push19=, 48
	i32.sub 	$push36=, $pop18, $pop19
	i32.store	$1=, 0($pop20), $pop36
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	$drop=, v($pop1), $pop0
	i64.const	$push2=, 12884901890
	i64.store	$drop=, 32($1), $pop2
	i32.const	$push24=, 20
	i32.add 	$push25=, $1, $pop24
	i32.const	$push3=, 4
	i32.store	$push42=, 40($1), $pop3
	tee_local	$push41=, $2=, $pop42
	i32.add 	$push4=, $pop25, $pop41
	i32.load	$push5=, 36($1)
	i32.store	$drop=, 0($pop4), $pop5
	i32.const	$push26=, 20
	i32.add 	$push27=, $1, $pop26
	i32.const	$push6=, 8
	i32.add 	$push7=, $pop27, $pop6
	i32.store	$drop=, 0($pop7), $2
	i32.load	$push8=, 32($1)
	i32.store	$drop=, 20($1), $pop8
	i32.const	$push9=, 9
	i32.const	$push28=, 20
	i32.add 	$push29=, $1, $pop28
	call    	bar@FUNCTION, $pop9, $pop29
	i32.const	$push40=, 0
	i32.const	$push10=, 17
	i32.store	$drop=, v($pop40), $pop10
	i64.const	$push11=, 73014444048
	i64.store	$drop=, 32($1), $pop11
	i32.const	$push12=, 18
	i32.store	$0=, 40($1), $pop12
	i32.const	$push30=, 8
	i32.add 	$push31=, $1, $pop30
	i32.add 	$push13=, $2, $pop31
	i32.load	$push14=, 36($1)
	i32.store	$drop=, 0($pop13), $pop14
	i32.const	$push32=, 8
	i32.add 	$push33=, $1, $pop32
	i32.const	$push39=, 8
	i32.add 	$push15=, $pop33, $pop39
	i32.store	$drop=, 0($pop15), $0
	i32.load	$push16=, 32($1)
	i32.store	$drop=, 8($1), $pop16
	i32.const	$push38=, 9
	i32.const	$push34=, 8
	i32.add 	$push35=, $1, $pop34
	call    	bar@FUNCTION, $pop38, $pop35
	i32.const	$push23=, __stack_pointer
	i32.const	$push21=, 48
	i32.add 	$push22=, $1, $pop21
	i32.store	$drop=, 0($pop23), $pop22
	i32.const	$push37=, 0
	return  	$pop37
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
