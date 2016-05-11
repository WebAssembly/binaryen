	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990524-1.c"
	.section	.text.loop,"ax",@progbits
	.hidden	loop
	.globl	loop
	.type	loop,@function
loop:                                   # @loop
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load8_u	$push1=, 0($1)
	i32.store8	$push20=, 0($0), $pop1
	tee_local	$push19=, $4=, $pop20
	i32.const	$push18=, 24
	i32.shl 	$push2=, $pop19, $pop18
	i32.const	$push17=, 24
	i32.shr_s	$3=, $pop2, $pop17
	i32.const	$push16=, 1
	i32.add 	$2=, $1, $pop16
	block
	block
	i32.const	$push15=, 34
	i32.eq  	$push3=, $4, $pop15
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push21=, 92
	i32.ne  	$push4=, $3, $pop21
	br_if   	1, $pop4        # 1: down to label2
.LBB0_3:                                # %sw.bb2
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push14=, 92
	i32.store8	$discard=, 0($0), $pop14
	i32.const	$push13=, 1
	i32.add 	$push6=, $0, $pop13
	i32.load8_u	$push5=, 0($1)
	i32.store8	$discard=, 0($pop6), $pop5
	i32.const	$push12=, 2
	i32.add 	$push0=, $0, $pop12
	copy_local	$0=, $pop0
	copy_local	$1=, $2
	br      	1               # 1: up to label0
.LBB0_4:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push22=, 1
	i32.add 	$0=, $0, $pop22
	copy_local	$1=, $2
	br_if   	0, $3           # 0: up to label0
# BB#5:                                 # %loopDone2
	end_loop                        # label1:
	block
	i32.const	$push7=, a
	i32.sub 	$push8=, $pop7, $0
	i32.const	$push9=, b
	i32.sub 	$push10=, $pop9, $2
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	0, $pop11       # 0: down to label4
# BB#6:                                 # %if.end
	return
.LBB0_7:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	loop, .Lfunc_end0-loop

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, a
	i32.const	$push0=, b
	call    	loop@FUNCTION, $pop1, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.asciz	"12345"
	.size	a, 6

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.asciz	"12345"
	.size	b, 6


	.ident	"clang version 3.9.0 "
