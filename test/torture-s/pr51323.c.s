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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 48
	i32.sub 	$push38=, $pop20, $pop21
	i32.store	$1=, __stack_pointer($pop22), $pop38
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	$drop=, v($pop3), $pop2
	i64.const	$push4=, 12884901890
	i64.store	$drop=, 32($1), $pop4
	i32.const	$push26=, 20
	i32.add 	$push27=, $1, $pop26
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop27, $pop5
	i32.load	$push7=, 36($1)
	i32.store	$drop=, 0($pop6), $pop7
	i32.const	$push28=, 20
	i32.add 	$push29=, $1, $pop28
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop29, $pop8
	i32.const	$push43=, 4
	i32.store	$push0=, 40($1), $pop43
	i32.store	$0=, 0($pop9), $pop0
	i32.load	$push10=, 32($1)
	i32.store	$drop=, 20($1), $pop10
	i32.const	$push11=, 9
	i32.const	$push30=, 20
	i32.add 	$push31=, $1, $pop30
	call    	bar@FUNCTION, $pop11, $pop31
	i32.const	$push42=, 0
	i32.const	$push12=, 17
	i32.store	$drop=, v($pop42), $pop12
	i64.const	$push13=, 73014444048
	i64.store	$drop=, 32($1), $pop13
	i32.const	$push32=, 8
	i32.add 	$push33=, $1, $pop32
	i32.add 	$push14=, $0, $pop33
	i32.load	$push15=, 36($1)
	i32.store	$drop=, 0($pop14), $pop15
	i32.const	$push34=, 8
	i32.add 	$push35=, $1, $pop34
	i32.const	$push41=, 8
	i32.add 	$push17=, $pop35, $pop41
	i32.const	$push16=, 18
	i32.store	$push1=, 40($1), $pop16
	i32.store	$drop=, 0($pop17), $pop1
	i32.load	$push18=, 32($1)
	i32.store	$drop=, 8($1), $pop18
	i32.const	$push40=, 9
	i32.const	$push36=, 8
	i32.add 	$push37=, $1, $pop36
	call    	bar@FUNCTION, $pop40, $pop37
	i32.const	$push25=, 0
	i32.const	$push23=, 48
	i32.add 	$push24=, $1, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
	i32.const	$push39=, 0
                                        # fallthrough-return: $pop39
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
	.functype	abort, void
