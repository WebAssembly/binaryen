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
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$9=, $pop11, $pop12
	i32.const	$push1=, 0
	i32.store	$push0=, 12($9), $pop1
	i32.store	$2=, 8($9), $pop0
	block
	block
	i32.eqz 	$push26=, $1
	br_if   	0, $pop26       # 0: down to label1
# BB#1:                                 # %while.body.lr.ph.lr.ph
	i32.const	$push4=, 6
	i32.add 	$4=, $0, $pop4
	i32.const	$push17=, 8
	i32.add 	$push18=, $9, $pop17
	copy_local	$7=, $pop18
	i32.const	$push19=, 12
	i32.add 	$push20=, $9, $pop19
	copy_local	$8=, $pop20
.LBB0_2:                                # %while.body.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label2:
	copy_local	$6=, $1
.LBB0_3:                                # %while.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load	$1=, 4($6)
	i32.const	$push22=, 4
	i32.add 	$3=, $6, $pop22
	i32.load8_u	$push2=, 0($6)
	i32.const	$push21=, 1
	i32.and 	$push3=, $pop2, $pop21
	br_if   	1, $pop3        # 1: down to label5
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push24=, 4
	i32.add 	$5=, $0, $pop24
	i32.load16_u	$push6=, 0($5)
	i32.const	$push23=, 1
	i32.add 	$push7=, $pop6, $pop23
	i32.store16	$drop=, 0($5), $pop7
	i32.store	$drop=, 0($7), $6
	copy_local	$6=, $1
	copy_local	$7=, $3
	br_if   	0, $1           # 0: up to label4
	br      	3               # 3: down to label3
.LBB0_5:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	i32.load16_u	$5=, 0($4)
	i32.store	$drop=, 0($8), $6
	i32.const	$push25=, 1
	i32.add 	$push5=, $5, $pop25
	i32.store16	$drop=, 0($4), $pop5
	copy_local	$8=, $3
	br_if   	0, $1           # 0: up to label2
	br      	3               # 3: down to label0
.LBB0_6:
	end_loop                        # label3:
	copy_local	$7=, $3
	br      	1               # 1: down to label0
.LBB0_7:
	end_block                       # label1:
	i32.const	$push13=, 12
	i32.add 	$push14=, $9, $pop13
	copy_local	$8=, $pop14
	i32.const	$push15=, 8
	i32.add 	$push16=, $9, $pop15
	copy_local	$7=, $pop16
.LBB0_8:                                # %while.end
	end_block                       # label0:
	i32.load	$push8=, 8($9)
	i32.store	$drop=, 0($8), $pop8
	i32.store	$drop=, 0($7), $2
	i32.load	$push9=, 12($9)
	i32.store	$drop=, 0($0), $pop9
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
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 32
	i32.sub 	$push24=, $pop16, $pop17
	i32.store	$push26=, 0($pop18), $pop24
	tee_local	$push25=, $1=, $pop26
	i32.const	$push5=, 1
	i32.store	$drop=, 8($pop25), $pop5
	i32.const	$push3=, 0
	i32.store	$push0=, 0($1), $pop3
	i32.store	$drop=, 12($1), $pop0
	i64.const	$push2=, 0
	i64.store	$drop=, 24($1), $pop2
	i32.const	$push4=, 8
	i32.or  	$push1=, $1, $pop4
	i32.store	$0=, 4($1), $pop1
	i32.const	$push22=, 24
	i32.add 	$push23=, $1, $pop22
	i32.call	$drop=, foo@FUNCTION, $pop23, $1
	block
	i32.load	$push6=, 28($1)
	i32.const	$push7=, 65537
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label6
# BB#1:                                 # %if.end
	i32.load	$push9=, 24($1)
	i32.ne  	$push10=, $pop9, $0
	br_if   	0, $pop10       # 0: down to label6
# BB#2:                                 # %if.end13
	i32.load	$push11=, 12($1)
	i32.ne  	$push12=, $pop11, $1
	br_if   	0, $pop12       # 0: down to label6
# BB#3:                                 # %if.end20
	i32.load	$push13=, 4($1)
	br_if   	0, $pop13       # 0: down to label6
# BB#4:                                 # %if.end24
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 32
	i32.add 	$push20=, $1, $pop19
	i32.store	$drop=, 0($pop21), $pop20
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_5:                                # %if.then23
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
