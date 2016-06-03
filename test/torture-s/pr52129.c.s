	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52129.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, t+2
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push2=, 0($1)
	i32.const	$push3=, t+69
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push6=, t+81
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %lor.lhs.false2
	i32.const	$push8=, t+17
	i32.ne  	$push9=, $2, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %lor.lhs.false2
	i32.load	$push5=, 4($1)
	i32.const	$push10=, 27
	i32.ne  	$push11=, $pop5, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push12=, 29
	return  	$pop12
.LBB0_6:                                # %if.then
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
	.param  	i32, i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push17=, __stack_pointer($pop7), $pop13
	tee_local	$push16=, $6=, $pop17
	i64.load	$push0=, 0($3):p2align=2
	i64.store	$drop=, 8($pop16):p2align=2, $pop0
	i32.const	$push11=, 8
	i32.add 	$push12=, $6, $pop11
	i32.add 	$push15=, $5, $4
	tee_local	$push14=, $5=, $pop15
	i32.const	$push1=, 64
	i32.add 	$push2=, $5, $pop1
	i32.call	$drop=, foo@FUNCTION, $0, $pop12, $pop14, $pop2
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $6, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push3=, 29
                                        # fallthrough-return: $pop3
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
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	i32.store	$push17=, __stack_pointer($pop8), $pop14
	tee_local	$push16=, $0=, $pop17
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.s($pop0):p2align=2
	i64.store	$drop=, 8($pop16):p2align=2, $pop1
	i32.const	$push4=, t+2
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push3=, 17
	i32.const	$push2=, t
	i32.call	$drop=, bar@FUNCTION, $pop4, $0, $0, $pop13, $pop3, $pop2
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$drop=, __stack_pointer($pop11), $pop10
	i32.const	$push15=, 0
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
t:
	.skip	128
	.size	t, 128

	.type	.Lmain.s,@object        # @main.s
	.section	.data.rel.ro..Lmain.s,"aw",@progbits
	.p2align	2
.Lmain.s:
	.int32	t+69
	.int32	27                      # 0x1b
	.size	.Lmain.s, 8


	.ident	"clang version 3.9.0 "
	.functype	abort, void
