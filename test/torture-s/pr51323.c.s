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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 48
	i32.sub 	$1=, $pop26, $pop27
	i32.const	$push28=, __stack_pointer
	i32.store	$discard=, 0($pop28), $1
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	$discard=, v($pop1), $pop0
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 32($1), $pop2
	i32.const	$push34=, 20
	i32.add 	$push35=, $1, $pop34
	i32.const	$push32=, 20
	i32.add 	$push33=, $1, $pop32
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop33, $pop5
	i32.const	$push3=, 4
	i32.store	$push4=, 40($1):p2align=3, $pop3
	i32.store	$push24=, 0($pop6), $pop4
	tee_local	$push23=, $0=, $pop24
	i32.add 	$push7=, $pop35, $pop23
	i32.load	$push8=, 36($1)
	i32.store	$discard=, 0($pop7), $pop8
	i32.load	$push9=, 32($1):p2align=3
	i32.store	$discard=, 20($1), $pop9
	i32.const	$push10=, 9
	i32.const	$push36=, 20
	i32.add 	$push37=, $1, $pop36
	call    	bar@FUNCTION, $pop10, $pop37
	i32.const	$push22=, 0
	i32.const	$push11=, 17
	i32.store	$discard=, v($pop22), $pop11
	i64.const	$push12=, 73014444048
	i64.store	$discard=, 32($1), $pop12
	i32.const	$push38=, 8
	i32.add 	$push39=, $1, $pop38
	i32.const	$push21=, 8
	i32.add 	$push15=, $pop39, $pop21
	i32.const	$push13=, 18
	i32.store	$push14=, 40($1):p2align=3, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	i32.const	$push40=, 8
	i32.add 	$push41=, $1, $pop40
	i32.add 	$push16=, $pop41, $0
	i32.load	$push17=, 36($1)
	i32.store	$discard=, 0($pop16), $pop17
	i32.load	$push18=, 32($1):p2align=3
	i32.store	$discard=, 8($1), $pop18
	i32.const	$push20=, 9
	i32.const	$push42=, 8
	i32.add 	$push43=, $1, $pop42
	call    	bar@FUNCTION, $pop20, $pop43
	i32.const	$push19=, 0
	i32.const	$push31=, __stack_pointer
	i32.const	$push29=, 48
	i32.add 	$push30=, $1, $pop29
	i32.store	$discard=, 0($pop31), $pop30
	return  	$pop19
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
