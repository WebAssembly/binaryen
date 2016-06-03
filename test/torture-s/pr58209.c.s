	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58209.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push5=, buf
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, buf
	block
	i32.eqz 	$push4=, $0
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$1=, $pop2, $pop3
.LBB1_2:                                # %return
	end_block                       # label1:
	copy_local	$push5=, $1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, buf-4
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	i32.call	$push7=, foo@FUNCTION, $2
	tee_local	$push6=, $0=, $pop7
	i32.ne  	$push0=, $pop8, $pop6
	br_if   	2, $pop0        # 2: down to label2
# BB#2:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$3=, buf
	block
	i32.eqz 	$push17=, $2
	br_if   	0, $pop17       # 0: down to label5
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push12=, -1
	i32.add 	$push1=, $2, $pop12
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push11=, 4
	i32.add 	$3=, $pop2, $pop11
.LBB2_4:                                # %bar.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	i32.ne  	$push3=, $3, $0
	br_if   	2, $pop3        # 2: down to label2
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$push15=, $2, $pop16
	tee_local	$push14=, $2=, $pop15
	i32.const	$push13=, 26
	i32.le_s	$push4=, $pop14, $pop13
	br_if   	0, $pop4        # 0: up to label3
# BB#6:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push5=, 0
	return  	$pop5
.LBB2_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	4096
	.size	buf, 4096


	.ident	"clang version 3.9.0 "
	.functype	abort, void
