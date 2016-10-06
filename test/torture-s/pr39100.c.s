	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push22=, $pop9, $pop10
	tee_local	$push21=, $8=, $pop22
	i32.const	$push20=, 0
	i32.store	12($pop21), $pop20
	i32.const	$push19=, 0
	i32.store	8($8), $pop19
	block   	
	block   	
	i32.eqz 	$push31=, $1
	br_if   	0, $pop31       # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push15=, 12
	i32.add 	$push16=, $8, $pop15
	copy_local	$6=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $8, $pop17
	copy_local	$5=, $pop18
	i32.const	$push2=, 6
	i32.add 	$4=, $0, $pop2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push24=, 4
	i32.add 	$2=, $1, $pop24
	i32.load	$3=, 4($1)
	block   	
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push23=, 1
	i32.and 	$push1=, $pop0, $pop23
	br_if   	0, $pop1        # 0: down to label4
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push28=, 4
	i32.add 	$push27=, $0, $pop28
	tee_local	$push26=, $7=, $pop27
	i32.load16_u	$push5=, 0($7)
	i32.const	$push25=, 1
	i32.add 	$push6=, $pop5, $pop25
	i32.store16	0($pop26), $pop6
	copy_local	$7=, $5
	copy_local	$5=, $2
	br      	1               # 1: down to label3
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load16_u	$push3=, 0($4)
	i32.const	$push29=, 1
	i32.add 	$push4=, $pop3, $pop29
	i32.store16	0($4), $pop4
	copy_local	$7=, $6
	copy_local	$6=, $2
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.store	0($7), $1
	copy_local	$1=, $3
	br_if   	0, $3           # 0: up to label2
# BB#6:                                 # %while.end.loopexit
	end_loop
	i32.load	$1=, 8($8)
	br      	1               # 1: down to label0
.LBB0_7:
	end_block                       # label1:
	i32.const	$push11=, 8
	i32.add 	$push12=, $8, $pop11
	copy_local	$5=, $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $8, $pop13
	copy_local	$6=, $pop14
	i32.const	$1=, 0
.LBB0_8:                                # %while.end
	end_block                       # label0:
	i32.store	0($6), $1
	i32.const	$push30=, 0
	i32.store	0($5), $pop30
	i32.load	$push7=, 12($8)
	i32.store	0($0), $pop7
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
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 32
	i32.sub 	$push30=, $pop14, $pop15
	tee_local	$push29=, $2=, $pop30
	i32.store	__stack_pointer($pop16), $pop29
	i64.const	$push0=, 0
	i64.store	24($2), $pop0
	i32.const	$push1=, 8
	i32.or  	$push28=, $2, $pop1
	tee_local	$push27=, $0=, $pop28
	i32.store	4($2), $pop27
	i32.const	$push2=, 0
	i32.store	0($2), $pop2
	i32.const	$push26=, 0
	i32.store	12($2), $pop26
	i32.const	$push25=, 1
	i32.store	8($2), $pop25
	block   	
	i32.const	$push20=, 24
	i32.add 	$push21=, $2, $pop20
	i32.call	$push24=, foo@FUNCTION, $pop21, $2
	tee_local	$push23=, $1=, $pop24
	i32.load16_u	$push3=, 4($pop23)
	i32.const	$push22=, 1
	i32.ne  	$push4=, $pop3, $pop22
	br_if   	0, $pop4        # 0: down to label5
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push5=, 6($1)
	i32.const	$push31=, 1
	i32.ne  	$push6=, $pop5, $pop31
	br_if   	0, $pop6        # 0: down to label5
# BB#2:                                 # %if.end
	i32.load	$push7=, 24($2)
	i32.ne  	$push8=, $pop7, $0
	br_if   	0, $pop8        # 0: down to label5
# BB#3:                                 # %if.end13
	i32.load	$push9=, 12($2)
	i32.ne  	$push10=, $pop9, $2
	br_if   	0, $pop10       # 0: down to label5
# BB#4:                                 # %if.end20
	i32.load	$push11=, 4($2)
	br_if   	0, $pop11       # 0: down to label5
# BB#5:                                 # %if.end24
	i32.const	$push19=, 0
	i32.const	$push17=, 32
	i32.add 	$push18=, $2, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	i32.const	$push12=, 0
	return  	$pop12
.LBB1_6:                                # %if.then23
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
