	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push23=, $pop12, $pop13
	tee_local	$push22=, $8=, $pop23
	i32.const	$push1=, 0
	i32.store	$push0=, 12($8), $pop1
	i32.store	$2=, 8($pop22), $pop0
	block
	block
	i32.eqz 	$push31=, $1
	br_if   	0, $pop31       # 0: down to label1
# BB#1:                                 # %while.body.lr.ph.lr.ph
	i32.const	$push18=, 12
	i32.add 	$push19=, $8, $pop18
	copy_local	$6=, $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $8, $pop20
	copy_local	$7=, $pop21
	i32.const	$push4=, 6
	i32.add 	$5=, $0, $pop4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push25=, 4
	i32.add 	$3=, $1, $pop25
	i32.load	$4=, 4($1)
	block
	i32.load8_u	$push2=, 0($1)
	i32.const	$push24=, 1
	i32.and 	$push3=, $pop2, $pop24
	br_if   	0, $pop3        # 0: down to label4
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$drop=, 0($7), $1
	i32.const	$push29=, 4
	i32.add 	$push28=, $0, $pop29
	tee_local	$push27=, $1=, $pop28
	i32.load16_u	$push7=, 0($1)
	i32.const	$push26=, 1
	i32.add 	$push8=, $pop7, $pop26
	i32.store16	$drop=, 0($pop27), $pop8
	copy_local	$1=, $4
	copy_local	$7=, $3
	br_if   	1, $4           # 1: up to label2
	br      	2               # 2: down to label3
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.store	$drop=, 0($6), $1
	i32.load16_u	$push5=, 0($5)
	i32.const	$push30=, 1
	i32.add 	$push6=, $pop5, $pop30
	i32.store16	$drop=, 0($5), $pop6
	copy_local	$1=, $4
	copy_local	$6=, $3
	br_if   	0, $4           # 0: up to label2
	br      	3               # 3: down to label0
.LBB0_5:
	end_loop                        # label3:
	copy_local	$7=, $3
	br      	1               # 1: down to label0
.LBB0_6:
	end_block                       # label1:
	i32.const	$push14=, 8
	i32.add 	$push15=, $8, $pop14
	copy_local	$7=, $pop15
	i32.const	$push16=, 12
	i32.add 	$push17=, $8, $pop16
	copy_local	$6=, $pop17
.LBB0_7:                                # %while.end
	end_block                       # label0:
	i32.load	$push9=, 8($8)
	i32.store	$drop=, 0($6), $pop9
	i32.store	$drop=, 0($7), $2
	i32.load	$push10=, 12($8)
	i32.store	$drop=, 0($0), $pop10
	copy_local	$push32=, $0
                                        # fallthrough-return: $pop32
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push23=, $pop15, $pop16
	i32.store	$push25=, __stack_pointer($pop17), $pop23
	tee_local	$push24=, $2=, $pop25
	i64.const	$push1=, 0
	i64.store	$drop=, 24($pop24), $pop1
	i32.const	$push2=, 8
	i32.or  	$push0=, $2, $pop2
	i32.store	$0=, 4($2), $pop0
	i32.const	$push3=, 0
	i32.store	$1=, 0($2), $pop3
	i32.const	$push4=, 1
	i32.store	$drop=, 8($2), $pop4
	i32.store	$drop=, 12($2), $1
	i32.const	$push21=, 24
	i32.add 	$push22=, $2, $pop21
	i32.call	$drop=, foo@FUNCTION, $pop22, $2
	block
	i32.load	$push6=, 28($2)
	i32.const	$push5=, 65537
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label5
# BB#1:                                 # %if.end
	i32.load	$push8=, 24($2)
	i32.ne  	$push9=, $pop8, $0
	br_if   	0, $pop9        # 0: down to label5
# BB#2:                                 # %if.end13
	i32.load	$push10=, 12($2)
	i32.ne  	$push11=, $pop10, $2
	br_if   	0, $pop11       # 0: down to label5
# BB#3:                                 # %if.end20
	i32.load	$push12=, 4($2)
	br_if   	0, $pop12       # 0: down to label5
# BB#4:                                 # %if.end24
	i32.const	$push20=, 0
	i32.const	$push18=, 32
	i32.add 	$push19=, $2, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_5:                                # %if.then23
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
