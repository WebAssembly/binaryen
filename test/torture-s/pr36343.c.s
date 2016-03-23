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
	i32.store	$discard=, 0($0), $pop0
	return
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
	.local  	f32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$3=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $3
	i32.const	$push0=, 0
	i32.store	$discard=, 12($3), $pop0
	i32.const	$push1=, 1065353216
	i32.store	$discard=, 8($3), $pop1
	i32.const	$push13=, 12
	i32.add 	$push14=, $3, $pop13
	i32.const	$push15=, 8
	i32.add 	$push16=, $3, $pop15
	i32.select	$push5=, $pop14, $pop16, $0
	tee_local	$push4=, $2=, $pop5
	call    	bar@FUNCTION, $pop4
	block
	block
	i32.const	$push17=, 0
	i32.eq  	$push18=, $0, $pop17
	br_if   	0, $pop18       # 0: down to label1
# BB#1:                                 # %if.then2
	i32.load	$push2=, 0($2)
	i32.load	$push3=, 0($pop2)
	f32.convert_s/i32	$1=, $pop3
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end3
	end_block                       # label1:
	f32.load	$1=, 8($3)
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	return  	$1
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
