	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060905-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$2=, s-384
	copy_local	$3=, $4
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$0=, 128
	block
	i32.lt_s	$push0=, $3, $0
	br_if   	$pop0, 0        # 0: down to label2
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load8_u	$1=, 0($2)
	i32.const	$push1=, 0
	i32.store8	$discard=, g($pop1), $1
	i32.const	$push2=, 1
	i32.add 	$4=, $4, $pop2
.LBB0_3:                                # %for.inc.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push3=, 1
	i32.add 	$3=, $3, $pop3
	i32.const	$push4=, 3
	i32.add 	$2=, $2, $pop4
	i32.const	$push5=, 256
	i32.ne  	$push6=, $3, $pop5
	br_if   	$pop6, 0        # 0: up to label0
# BB#4:                                 # %foo.exit
	end_loop                        # label1:
	block
	i32.ne  	$push7=, $4, $0
	br_if   	$pop7, 0        # 0: down to label3
# BB#5:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_6:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	4
s:
	.skip	768
	.size	s, 768

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
