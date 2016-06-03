	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36343.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	f32
	.local  	i32, i32, f32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push19=, __stack_pointer($pop7), $pop15
	tee_local	$push18=, $1=, $pop19
	i32.const	$push0=, 0
	i32.store	$drop=, 12($pop18), $pop0
	i32.const	$push1=, 1065353216
	i32.store	$drop=, 8($1), $pop1
	i32.const	$push11=, 12
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 8
	i32.add 	$push14=, $1, $pop13
	i32.select	$push17=, $pop12, $pop14, $0
	tee_local	$push16=, $2=, $pop17
	call    	bar@FUNCTION, $pop16
	block
	block
	i32.eqz 	$push20=, $0
	br_if   	0, $pop20       # 0: down to label1
# BB#1:                                 # %if.then2
	i32.load	$push2=, 0($2)
	i32.load	$push3=, 0($pop2)
	f32.convert_s/i32	$3=, $pop3
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end3
	end_block                       # label1:
	f32.load	$3=, 8($1)
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	copy_local	$push21=, $3
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	f32.call	$push0=, foo@FUNCTION, $pop3
	f32.const	$push1=, 0x0p0
	f32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
