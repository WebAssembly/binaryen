	.text
	.file	"pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$8=, $pop8, $pop10
	i32.const	$push20=, 0
	i32.store	12($8), $pop20
	i32.const	$push19=, 0
	i32.store	8($8), $pop19
	block   	
	block   	
	i32.eqz 	$push27=, $1
	br_if   	0, $pop27       # 0: down to label1
# %bb.1:                                # %while.body.lr.ph
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
	i32.const	$push22=, 4
	i32.add 	$2=, $1, $pop22
	i32.load	$3=, 4($1)
	block   	
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push21=, 1
	i32.and 	$push1=, $pop0, $pop21
	br_if   	0, $pop1        # 0: down to label4
# %bb.3:                                # %if.else
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push24=, 4
	i32.add 	$7=, $0, $pop24
	i32.load16_u	$push5=, 0($7)
	i32.const	$push23=, 1
	i32.add 	$push6=, $pop5, $pop23
	i32.store16	0($7), $pop6
	copy_local	$7=, $5
	copy_local	$5=, $2
	br      	1               # 1: down to label3
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load16_u	$push3=, 0($4)
	i32.const	$push25=, 1
	i32.add 	$push4=, $pop3, $pop25
	i32.store16	0($4), $pop4
	copy_local	$7=, $6
	copy_local	$6=, $2
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.store	0($7), $1
	copy_local	$1=, $3
	br_if   	0, $3           # 0: up to label2
# %bb.6:                                # %while.end.loopexit
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
	i32.const	$push26=, 0
	i32.store	0($5), $pop26
	i32.load	$push7=, 12($8)
	i32.store	0($0), $pop7
	copy_local	$push28=, $0
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 32
	i32.sub 	$2=, $pop14, $pop16
	i32.const	$push17=, 0
	i32.store	__stack_pointer($pop17), $2
	i64.const	$push0=, 0
	i64.store	24($2), $pop0
	i32.const	$push1=, 8
	i32.or  	$0=, $2, $pop1
	i32.store	4($2), $0
	i32.const	$push2=, 0
	i32.store	0($2), $pop2
	i64.const	$push3=, 1
	i64.store	8($2), $pop3
	i32.const	$push21=, 24
	i32.add 	$push22=, $2, $pop21
	i32.call	$1=, foo@FUNCTION, $pop22, $2
	block   	
	i32.load16_u	$push4=, 4($1)
	i32.const	$push23=, 1
	i32.ne  	$push5=, $pop4, $pop23
	br_if   	0, $pop5        # 0: down to label5
# %bb.1:                                # %lor.lhs.false
	i32.load16_u	$push6=, 6($1)
	i32.const	$push24=, 1
	i32.ne  	$push7=, $pop6, $pop24
	br_if   	0, $pop7        # 0: down to label5
# %bb.2:                                # %if.end
	i32.load	$push8=, 24($2)
	i32.ne  	$push9=, $pop8, $0
	br_if   	0, $pop9        # 0: down to label5
# %bb.3:                                # %if.end13
	i32.load	$push10=, 12($2)
	i32.ne  	$push11=, $pop10, $2
	br_if   	0, $pop11       # 0: down to label5
# %bb.4:                                # %if.end20
	i32.load	$push12=, 4($2)
	br_if   	0, $pop12       # 0: down to label5
# %bb.5:                                # %if.end24
	i32.const	$push20=, 0
	i32.const	$push18=, 32
	i32.add 	$push19=, $2, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_6:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
