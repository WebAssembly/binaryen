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
	i32.load8_u	$push0=, 0($1)
	i32.store8	$push16=, 0($0), $pop0
	tee_local	$push15=, $4=, $pop16
	i32.const	$push14=, 24
	i32.shl 	$push1=, $pop15, $pop14
	i32.const	$push13=, 24
	i32.shr_s	$3=, $pop1, $pop13
	i32.const	$push12=, 1
	i32.add 	$2=, $1, $pop12
	block
	block
	i32.const	$push11=, 34
	i32.eq  	$push2=, $4, $pop11
	br_if   	0, $pop2        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 92
	i32.ne  	$push3=, $3, $pop17
	br_if   	1, $pop3        # 1: down to label2
.LBB0_3:                                # %sw.bb2
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push21=, 92
	i32.store8	$discard=, 0($0), $pop21
	i32.const	$push20=, 2
	i32.add 	$3=, $0, $pop20
	i32.const	$push19=, 1
	i32.add 	$push5=, $0, $pop19
	i32.load8_u	$push4=, 0($1)
	i32.store8	$discard=, 0($pop5), $pop4
	copy_local	$0=, $3
	copy_local	$1=, $2
	br      	1               # 1: up to label0
.LBB0_4:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push18=, 1
	i32.add 	$0=, $0, $pop18
	copy_local	$1=, $2
	br_if   	0, $3           # 0: up to label0
# BB#5:                                 # %loopDone2
	end_loop                        # label1:
	block
	i32.const	$push6=, a
	i32.sub 	$push7=, $pop6, $0
	i32.const	$push8=, b
	i32.sub 	$push9=, $pop8, $2
	i32.ne  	$push10=, $pop7, $pop9
	br_if   	0, $pop10       # 0: down to label4
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
