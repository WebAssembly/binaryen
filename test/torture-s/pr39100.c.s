	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 16
	i32.sub 	$9=, $pop16, $pop17
	i32.const	$push18=, 12
	i32.add 	$push19=, $9, $pop18
	copy_local	$8=, $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $9, $pop20
	copy_local	$7=, $pop21
	i32.const	$push0=, 0
	i32.store	$push1=, 12($9), $pop0
	i32.store	$3=, 8($9), $pop1
	block
	i32.const	$push26=, 0
	i32.eq  	$push27=, $1, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph.lr.ph
	i32.const	$push4=, 6
	i32.add 	$4=, $0, $pop4
	i32.const	$push22=, 8
	i32.add 	$push23=, $9, $pop22
	copy_local	$7=, $pop23
	i32.const	$push24=, 12
	i32.add 	$push25=, $9, $pop24
	copy_local	$8=, $pop25
.LBB0_2:                                # %while.body.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label1:
	copy_local	$6=, $1
.LBB0_3:                                # %while.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.load	$1=, 4($6)
	i32.const	$push11=, 4
	i32.add 	$2=, $6, $pop11
	i32.load8_u	$push2=, 0($6)
	i32.const	$push10=, 1
	i32.and 	$push3=, $pop2, $pop10
	br_if   	1, $pop3        # 1: down to label4
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push14=, 4
	i32.add 	$5=, $0, $pop14
	i32.load16_u	$push6=, 0($5)
	i32.const	$push13=, 1
	i32.add 	$push7=, $pop6, $pop13
	i32.store16	$discard=, 0($5), $pop7
	i32.store	$discard=, 0($7), $6
	copy_local	$6=, $1
	copy_local	$7=, $2
	br_if   	0, $1           # 0: up to label3
	br      	3               # 3: down to label2
.LBB0_5:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label4:
	i32.load16_u	$5=, 0($4)
	i32.store	$discard=, 0($8), $6
	i32.const	$push12=, 1
	i32.add 	$push5=, $5, $pop12
	i32.store16	$discard=, 0($4), $pop5
	copy_local	$8=, $2
	br_if   	0, $1           # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_6:
	end_loop                        # label2:
	copy_local	$7=, $2
.LBB0_7:                                # %while.end
	end_block                       # label0:
	i32.load	$push8=, 8($9)
	i32.store	$discard=, 0($8), $pop8
	i32.store	$discard=, 0($7), $3
	i32.load	$push9=, 12($9)
	i32.store	$discard=, 0($0), $pop9
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 32
	i32.sub 	$1=, $pop16, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $1
	i32.const	$push5=, 1
	i32.store	$discard=, 8($1), $pop5
	i32.const	$push2=, 0
	i32.store	$push3=, 0($1), $pop2
	i32.store	$discard=, 12($1), $pop3
	i64.const	$push1=, 0
	i64.store	$discard=, 24($1), $pop1
	i32.const	$push4=, 8
	i32.or  	$push0=, $1, $pop4
	i32.store	$0=, 4($1), $pop0
	i32.const	$push22=, 24
	i32.add 	$push23=, $1, $pop22
	i32.call	$discard=, foo@FUNCTION, $pop23, $1
	block
	i32.load	$push6=, 28($1)
	i32.const	$push7=, 65537
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label5
# BB#1:                                 # %if.end
	i32.load	$push9=, 24($1)
	i32.ne  	$push10=, $pop9, $0
	br_if   	0, $pop10       # 0: down to label5
# BB#2:                                 # %if.end13
	i32.load	$push11=, 12($1)
	i32.ne  	$push12=, $pop11, $1
	br_if   	0, $pop12       # 0: down to label5
# BB#3:                                 # %if.end20
	i32.load	$push13=, 4($1)
	br_if   	0, $pop13       # 0: down to label5
# BB#4:                                 # %if.end24
	i32.const	$push14=, 0
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 32
	i32.add 	$push20=, $1, $pop19
	i32.store	$discard=, 0($pop21), $pop20
	return  	$pop14
.LBB1_5:                                # %if.then23
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
