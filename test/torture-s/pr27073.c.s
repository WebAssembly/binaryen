	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27073.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 65535
	i32.and 	$push1=, $4, $pop0
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop1, $pop13
	br_if   	$pop14, 0       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push2=, 0
	i32.sub 	$4=, $pop2, $4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push12=, 4
	i32.add 	$push3=, $0, $pop12
	i32.store	$discard=, 0($pop3), $6
	i32.const	$push11=, 8
	i32.add 	$push4=, $0, $pop11
	i32.store	$discard=, 0($pop4), $7
	i32.const	$push10=, 12
	i32.add 	$push5=, $0, $pop10
	i32.store	$discard=, 0($pop5), $8
	i32.const	$push9=, 16
	i32.add 	$push6=, $0, $pop9
	i32.store	$discard=, 0($pop6), $9
	i32.store	$discard=, 0($0), $5
	i32.const	$push8=, 1
	i32.add 	$4=, $4, $pop8
	i32.const	$push7=, 20
	i32.add 	$0=, $0, $pop7
	br_if   	$4, 0           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push4=, 2
	i32.const	$push3=, 100
	i32.const	$push41=, 200
	i32.const	$push2=, 300
	i32.const	$push1=, 400
	i32.const	$push0=, 500
	call    	foo@FUNCTION, $3, $0, $0, $0, $pop4, $pop3, $pop41, $pop2, $pop1, $pop0
	block
	i32.load	$push5=, 0($3):p2align=4
	i32.const	$push40=, 100
	i32.ne  	$push6=, $pop5, $pop40
	br_if   	$pop6, 0        # 0: down to label3
# BB#1:                                 # %for.cond
	i32.const	$push7=, 4
	i32.or  	$push8=, $3, $pop7
	i32.load	$push9=, 0($pop8)
	i32.const	$push42=, 200
	i32.ne  	$push10=, $pop9, $pop42
	br_if   	$pop10, 0       # 0: down to label3
# BB#2:                                 # %for.cond.1
	i32.const	$push11=, 8
	i32.or  	$push12=, $3, $pop11
	i32.load	$push13=, 0($pop12):p2align=3
	i32.const	$push14=, 300
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label3
# BB#3:                                 # %for.cond.2
	i32.const	$push16=, 12
	i32.or  	$push17=, $3, $pop16
	i32.load	$push18=, 0($pop17)
	i32.const	$push19=, 400
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, 0       # 0: down to label3
# BB#4:                                 # %for.cond.3
	i32.load	$push21=, 16($3):p2align=4
	i32.const	$push22=, 500
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, 0       # 0: down to label3
# BB#5:                                 # %for.cond.4
	i32.load	$push24=, 20($3)
	i32.const	$push25=, 100
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, 0       # 0: down to label3
# BB#6:                                 # %for.cond.5
	i32.load	$push27=, 24($3):p2align=3
	i32.const	$push28=, 200
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, 0       # 0: down to label3
# BB#7:                                 # %for.cond.6
	i32.load	$push30=, 28($3)
	i32.const	$push31=, 300
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	$pop32, 0       # 0: down to label3
# BB#8:                                 # %for.cond.7
	i32.load	$push33=, 32($3):p2align=4
	i32.const	$push34=, 400
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	$pop35, 0       # 0: down to label3
# BB#9:                                 # %for.cond.8
	i32.load	$push36=, 36($3)
	i32.const	$push37=, 500
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	$pop38, 0       # 0: down to label3
# BB#10:                                # %for.cond.9
	i32.const	$push39=, 0
	call    	exit@FUNCTION, $pop39
	unreachable
.LBB1_11:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
