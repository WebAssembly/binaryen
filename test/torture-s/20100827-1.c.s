	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100827-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	block
	i32.load8_u	$push0=, 0($0)
	i32.eqz 	$push7=, $pop0
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %if.end.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push4=, $0, $2
	tee_local	$push3=, $1=, $pop4
	i32.eqz 	$push8=, $pop3
	br_if   	3, $pop8        # 3: down to label0
# BB#3:                                 # %if.end5
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, 1
	i32.add 	$push1=, $1, $pop5
	i32.load8_u	$push2=, 0($pop1)
	br_if   	0, $pop2        # 0: up to label2
.LBB0_4:                                # %do.end
	end_loop                        # label3:
	end_block                       # label1:
	return  	$2
.LBB0_5:                                # %if.then4
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2


	.ident	"clang version 3.9.0 "
	.functype	abort, void
