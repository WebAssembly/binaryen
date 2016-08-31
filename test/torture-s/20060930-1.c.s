	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060930-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$1
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push23=, $pop8, $pop9
	tee_local	$push22=, $4=, $pop23
	i32.store	$drop=, __stack_pointer($pop10), $pop22
	block
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push0=, 0
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.sub 	$push2=, $pop30, $0
	i32.const	$push29=, 0
	i32.gt_s	$push1=, $0, $pop29
	i32.select	$push28=, $pop2, $0, $pop1
	tee_local	$push27=, $0=, $pop28
	i32.sub 	$push5=, $pop31, $pop27
	i32.const	$push26=, -1
	i32.gt_s	$push25=, $0, $pop26
	tee_local	$push24=, $2=, $pop25
	i32.select	$0=, $pop0, $pop5, $pop24
	i32.const	$push14=, 8
	i32.add 	$push15=, $4, $pop14
	i32.const	$push16=, 12
	i32.add 	$push17=, $4, $pop16
	i32.select	$3=, $pop15, $pop17, $2
	i32.const	$push18=, 12
	i32.add 	$push19=, $4, $pop18
	i32.const	$push20=, 8
	i32.add 	$push21=, $4, $pop20
	i32.select	$2=, $pop19, $pop21, $2
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.store	$drop=, 0($3), $0
	i32.store	$drop=, 0($2), $0
	i32.load	$push6=, 12($4)
	i32.call	$drop=, bar@FUNCTION, $1, $pop6
	i32.const	$push34=, -1
	i32.add 	$push33=, $1, $pop34
	tee_local	$push32=, $1=, $pop33
	br_if   	0, $pop32       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $4, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.const	$push2=, 1
	call    	foo@FUNCTION, $pop0, $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
