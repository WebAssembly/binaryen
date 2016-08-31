	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20061101-1.c"
	.section	.text.tar,"ax",@progbits
	.hidden	tar
	.globl	tar
	.type	tar,@function
tar:                                    # @tar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 36863
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, -1
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	tar, .Lfunc_end0-tar

	.section	.text.bug,"ax",@progbits
	.hidden	bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push20=, $pop7, $pop8
	tee_local	$push19=, $5=, $pop20
	i32.store	$drop=, __stack_pointer($pop9), $pop19
	i32.const	$4=, 0
	i32.const	$push18=, 0
	i32.store	$drop=, 12($5), $pop18
	i32.const	$push17=, -1
	i32.add 	$2=, $0, $pop17
	i32.const	$push13=, 8
	i32.add 	$push14=, $5, $pop13
	copy_local	$0=, $pop14
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.store	$drop=, 0($0), $4
	i32.load	$push0=, 12($5)
	i32.const	$push21=, -1
	i32.eq  	$push1=, $pop0, $pop21
	br_if   	2, $pop1        # 2: down to label1
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push27=, 8($5)
	tee_local	$push26=, $4=, $pop27
	i32.const	$push25=, 1
	i32.add 	$push3=, $pop26, $pop25
	i32.lt_s	$push2=, $4, $2
	i32.select	$push24=, $pop3, $2, $pop2
	tee_local	$push23=, $3=, $pop24
	i32.store	$drop=, 8($5), $pop23
	i32.const	$4=, -1
	i32.const	$push15=, 12
	i32.add 	$push16=, $5, $pop15
	copy_local	$0=, $pop16
	i32.mul 	$push4=, $3, $1
	i32.const	$push22=, 36863
	i32.eq  	$push5=, $pop4, $pop22
	br_if   	0, $pop5        # 0: up to label2
# BB#3:                                 # %if.then.i
	end_loop                        # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %while.end
	end_block                       # label1:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $5, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push20=, $pop8, $pop9
	tee_local	$push19=, $3=, $pop20
	i32.store	$drop=, __stack_pointer($pop10), $pop19
	i32.const	$2=, 0
	i32.const	$push18=, 0
	i32.store	$drop=, 12($3), $pop18
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	copy_local	$1=, $pop15
.LBB2_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.store	$drop=, 0($1), $2
	i32.load	$push0=, 12($3)
	i32.const	$push21=, -1
	i32.eq  	$push1=, $pop0, $pop21
	br_if   	2, $pop1        # 2: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push30=, 8($3)
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push3=, $pop29, $pop28
	i32.const	$push27=, 4
	i32.const	$push26=, 4
	i32.lt_s	$push2=, $2, $pop26
	i32.select	$push25=, $pop3, $pop27, $pop2
	tee_local	$push24=, $0=, $pop25
	i32.store	$drop=, 8($3), $pop24
	i32.const	$2=, -1
	i32.const	$push16=, 12
	i32.add 	$push17=, $3, $pop16
	copy_local	$1=, $pop17
	i32.const	$push23=, 36863
	i32.mul 	$push4=, $0, $pop23
	i32.const	$push22=, 36863
	i32.eq  	$push5=, $pop4, $pop22
	br_if   	0, $pop5        # 0: up to label5
# BB#3:                                 # %if.then.i.i
	end_loop                        # label6:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %bug.exit
	end_block                       # label4:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $3, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
