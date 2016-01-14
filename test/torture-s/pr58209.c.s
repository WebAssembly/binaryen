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
	i32.const	$push6=, 0
	i32.eq  	$push7=, $0, $pop6
	br_if   	$pop7, 0        # 0: down to label0
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
	return  	$pop5
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
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$1=, $pop2, $pop3
.LBB1_2:                                # %return
	end_block                       # label1:
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, buf-4
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.call	$0=, foo@FUNCTION, $3
	i32.const	$1=, 4
	i32.add 	$2=, $2, $1
	i32.ne  	$push1=, $2, $0
	br_if   	$pop1, 2        # 2: down to label2
# BB#2:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$4=, buf
	block
	i32.const	$push9=, 0
	i32.eq  	$push10=, $3, $pop9
	br_if   	$pop10, 0       # 0: down to label5
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push2=, -1
	i32.add 	$push3=, $3, $pop2
	i32.call	$push4=, foo@FUNCTION, $pop3
	i32.add 	$4=, $pop4, $1
.LBB2_4:                                # %bar.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	i32.ne  	$push5=, $4, $0
	br_if   	$pop5, 2        # 2: down to label2
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push0=, 1
	i32.add 	$3=, $3, $pop0
	i32.const	$push6=, 26
	i32.le_s	$push7=, $3, $pop6
	br_if   	$pop7, 0        # 0: up to label3
# BB#6:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push8=, 0
	return  	$pop8
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
	.align	4
buf:
	.skip	4096
	.size	buf, 4096


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
