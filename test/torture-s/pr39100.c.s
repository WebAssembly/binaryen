	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push25=, $pop12, $pop13
	tee_local	$push24=, $6=, $pop25
	i32.const	$push23=, 0
	i32.store	$drop=, 12($pop24), $pop23
	i32.const	$push14=, 12
	i32.add 	$push15=, $6, $pop14
	i32.store	$drop=, 8($6), $pop15
	i32.const	$push22=, 0
	i32.store	$drop=, 4($6), $pop22
	i32.const	$push16=, 4
	i32.add 	$push17=, $6, $pop16
	i32.store	$drop=, 0($6), $pop17
	block
	block
	i32.eqz 	$push33=, $1
	br_if   	0, $pop33       # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push2=, 6
	i32.add 	$4=, $0, $pop2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push27=, 4
	i32.add 	$2=, $1, $pop27
	i32.load	$3=, 4($1)
	block
	block
	i32.load8_u	$push0=, 0($1)
	i32.const	$push26=, 1
	i32.and 	$push1=, $pop0, $pop26
	br_if   	0, $pop1        # 0: down to label5
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push31=, 4
	i32.add 	$push30=, $0, $pop31
	tee_local	$push29=, $5=, $pop30
	i32.load16_u	$push5=, 0($5)
	i32.const	$push28=, 1
	i32.add 	$push6=, $pop5, $pop28
	i32.store16	$drop=, 0($pop29), $pop6
	copy_local	$5=, $6
	br      	1               # 1: down to label4
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.load16_u	$push3=, 0($4)
	i32.const	$push32=, 1
	i32.add 	$push4=, $pop3, $pop32
	i32.store16	$drop=, 0($4), $pop4
	i32.const	$push20=, 8
	i32.add 	$push21=, $6, $pop20
	copy_local	$5=, $pop21
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push7=, 0($5)
	i32.store	$drop=, 0($pop7), $1
	i32.store	$drop=, 0($5), $2
	copy_local	$1=, $3
	br_if   	0, $3           # 0: up to label2
# BB#6:                                 # %while.end.loopexit
	end_loop                        # label3:
	i32.load	$1=, 8($6)
	i32.load	$3=, 4($6)
	br      	1               # 1: down to label0
.LBB0_7:                                # %entry.while.end_crit_edge
	end_block                       # label1:
	i32.const	$push18=, 12
	i32.add 	$push19=, $6, $pop18
	copy_local	$1=, $pop19
.LBB0_8:                                # %while.end
	end_block                       # label0:
	i32.store	$drop=, 0($1), $3
	i32.load	$push9=, 0($6)
	i32.const	$push8=, 0
	i32.store	$drop=, 0($pop9), $pop8
	i32.load	$push10=, 12($6)
	i32.store	$drop=, 0($0), $pop10
	copy_local	$push34=, $0
                                        # fallthrough-return: $pop34
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
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push27=, $pop15, $pop16
	tee_local	$push26=, $1=, $pop27
	i32.store	$drop=, __stack_pointer($pop17), $pop26
	i64.const	$push0=, 0
	i64.store	$drop=, 24($1), $pop0
	i32.const	$push1=, 8
	i32.or  	$push25=, $1, $pop1
	tee_local	$push24=, $0=, $pop25
	i32.store	$drop=, 4($1), $pop24
	i32.const	$push2=, 0
	i32.store	$drop=, 0($1), $pop2
	i32.const	$push3=, 1
	i32.store	$drop=, 8($1), $pop3
	i32.const	$push23=, 0
	i32.store	$drop=, 12($1), $pop23
	block
	i32.const	$push21=, 24
	i32.add 	$push22=, $1, $pop21
	i32.call	$push4=, foo@FUNCTION, $pop22, $1
	i32.load	$push5=, 4($pop4)
	i32.const	$push6=, 65537
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label6
# BB#1:                                 # %if.end
	i32.load	$push8=, 24($1)
	i32.ne  	$push9=, $pop8, $0
	br_if   	0, $pop9        # 0: down to label6
# BB#2:                                 # %if.end13
	i32.load	$push10=, 12($1)
	i32.ne  	$push11=, $pop10, $1
	br_if   	0, $pop11       # 0: down to label6
# BB#3:                                 # %if.end20
	i32.load	$push12=, 4($1)
	br_if   	0, $pop12       # 0: down to label6
# BB#4:                                 # %if.end24
	i32.const	$push20=, 0
	i32.const	$push18=, 32
	i32.add 	$push19=, $1, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_5:                                # %if.then23
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
