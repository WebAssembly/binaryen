	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, buf
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i32.const	$push2=, 64
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop1, $pop2
                                        # fallthrough-return
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
	i32.const	$2=, 0
	i32.const	$push17=, 0
	i32.const	$push2=, 2
	i32.store8	buf+64($pop17), $pop2
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push18=, buf
	i32.add 	$push3=, $2, $pop18
	i32.load8_u	$push4=, 0($pop3)
	br_if   	1, $pop4        # 1: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push22=, 1
	i32.add 	$push21=, $2, $pop22
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 63
	i32.le_s	$push5=, $pop20, $pop19
	br_if   	0, $pop5        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push7=, buf
	i32.const	$push23=, 1
	i32.const	$push6=, 64
	i32.call	$0=, memset@FUNCTION, $pop7, $pop23, $pop6
	i32.const	$2=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push24=, 63
	i32.gt_s	$push8=, $2, $pop24
	br_if   	1, $pop8        # 1: down to label2
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.add 	$1=, $2, $0
	i32.const	$push26=, 1
	i32.add 	$push0=, $2, $pop26
	copy_local	$2=, $pop0
	i32.load8_u	$push15=, 0($1)
	i32.const	$push25=, 1
	i32.eq  	$push16=, $pop15, $pop25
	br_if   	0, $pop16       # 0: up to label3
# BB#6:                                 # %if.then11
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %for.end15
	end_block                       # label2:
	i32.const	$push11=, buf
	i32.const	$push10=, 0
	i32.const	$push9=, 64
	i32.call	$0=, memset@FUNCTION, $pop11, $pop10, $pop9
	i32.const	$2=, 1
.LBB1_8:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label5:
	i32.const	$push27=, 63
	i32.gt_s	$push12=, $2, $pop27
	br_if   	1, $pop12       # 1: down to label4
# BB#9:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_8 Depth=1
	i32.add 	$1=, $2, $0
	i32.const	$push28=, 1
	i32.add 	$push1=, $2, $pop28
	copy_local	$2=, $pop1
	i32.load8_u	$push14=, 0($1)
	i32.eqz 	$push29=, $pop14
	br_if   	0, $pop29       # 0: up to label5
# BB#10:                                # %if.then24
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.end33
	end_block                       # label4:
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_12:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	65
	.size	buf, 65


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
