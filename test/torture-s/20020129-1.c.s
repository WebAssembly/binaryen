	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020129-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$4=, 28($1)
	block
	block
	i32.load	$push0=, 28($0)
	i32.const	$push11=, 0
	i32.eq  	$push12=, $pop0, $pop11
	br_if   	$pop12, 0       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	i32.eq  	$push14=, $4, $pop13
	br_if   	$pop14, 1       # 1: down to label0
# BB#2:                                 # %if.then6
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.const	$2=, 28
	i32.add 	$push1=, $0, $2
	i32.store	$discard=, 0($pop1), $4
	i32.add 	$push2=, $1, $2
	i32.const	$push3=, 0
	i32.store	$discard=, 0($pop2), $pop3
	i32.const	$push15=, 0
	i32.eq  	$push16=, $4, $pop15
	br_if   	$pop16, 0       # 0: down to label0
.LBB0_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.store	$discard=, 4($4), $0
	i32.load	$4=, 0($4)
	br_if   	$4, 0           # 0: up to label2
.LBB0_5:                                # %if.end7
	end_loop                        # label3:
	end_block                       # label0:
	i32.load	$2=, 12($1)
	i32.const	$4=, -1
	block
	block
	i32.load	$push4=, 12($0)
	i32.eq  	$push5=, $pop4, $4
	br_if   	$pop5, 0        # 0: down to label5
# BB#6:                                 # %if.end22
	i32.eq  	$push6=, $2, $4
	br_if   	$pop6, 1        # 1: down to label4
# BB#7:                                 # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.end22.thread
	end_block                       # label5:
	i32.const	$3=, 12
	i32.add 	$push7=, $0, $3
	i32.store	$discard=, 0($pop7), $2
	i32.load	$push8=, 16($1)
	i32.store	$discard=, 16($0), $pop8
	i32.add 	$push9=, $1, $3
	i32.store	$discard=, 0($pop9), $4
	i32.const	$push10=, 0
	i32.store	$discard=, 16($1), $pop10
.LBB0_9:                                # %if.end27
	end_block                       # label4:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 6
	i32.store	$discard=, y($1), $pop0
	i32.const	$push1=, 145
	i32.store	$2=, y+12($1), $pop1
	i32.load	$5=, x+28($1)
	i32.load	$0=, y+28($1)
	block
	block
	i32.const	$push2=, 2448
	i32.store	$3=, y+16($1), $pop2
	i32.const	$push3=, -1
	i32.store	$4=, x+12($1), $pop3
	br_if   	$5, 0           # 0: down to label7
# BB#1:                                 # %if.then.i
	i32.store	$5=, x+28($1), $0
	i32.store	$discard=, y+28($1), $1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $5, $pop6
	br_if   	$pop7, 1        # 1: down to label6
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.const	$push4=, x
	i32.store	$discard=, 4($5), $pop4
	i32.load	$5=, 0($5)
	br_if   	$5, 0           # 0: up to label8
	br      	3               # 3: down to label6
.LBB1_3:                                # %if.end.i
	end_loop                        # label9:
	end_block                       # label7:
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, 0        # 0: down to label6
# BB#4:                                 # %if.then6.i
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %foo.exit
	end_block                       # label6:
	i32.store	$discard=, x+12($1), $2
	i32.store	$discard=, x+16($1), $3
	i32.store	$discard=, y+12($1), $4
	i32.store	$push5=, y+16($1), $1
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.align	2
y:
	.skip	32
	.size	y, 32

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.align	2
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 3.9.0 "
