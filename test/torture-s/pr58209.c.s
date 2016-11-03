	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58209.c"
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
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
.LBB1_2:
	end_block                       # label1:
	i32.const	$push5=, buf
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, buf-4
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push13=, 4
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.call	$push10=, foo@FUNCTION, $2
	tee_local	$push9=, $0=, $pop10
	i32.ne  	$push0=, $pop11, $pop9
	br_if   	1, $pop0        # 1: down to label2
# BB#2:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	block   	
	i32.eqz 	$push20=, $2
	br_if   	0, $pop20       # 0: down to label5
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push15=, -1
	i32.add 	$push1=, $2, $pop15
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push14=, 4
	i32.add 	$push7=, $pop2, $pop14
	i32.eq  	$push3=, $pop7, $0
	br_if   	1, $pop3        # 1: down to label4
	br      	3               # 3: down to label2
.LBB2_4:                                #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	i32.const	$push8=, buf
	i32.ne  	$push4=, $pop8, $0
	br_if   	2, $pop4        # 2: down to label2
.LBB2_5:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label4:
	i32.const	$push19=, 1
	i32.add 	$push18=, $2, $pop19
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 26
	i32.le_s	$push5=, $pop17, $pop16
	br_if   	0, $pop5        # 0: up to label3
# BB#6:                                 # %for.end
	end_loop
	i32.const	$push6=, 0
	return  	$pop6
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
