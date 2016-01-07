	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991201-1.c"
	.globl	reset_palette
	.type	reset_palette,@function
reset_palette:                          # @reset_palette
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, vc_cons
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$1=, $pop2, $pop1
	i32.const	$3=, 6
	i32.const	$0=, -64
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$2=, 64
	i32.load	$push7=, 0($1)
	i32.add 	$push8=, $pop7, $3
	i32.const	$push9=, -2
	i32.add 	$push10=, $pop8, $pop9
	i32.const	$push3=, default_red
	i32.add 	$push4=, $pop3, $0
	i32.add 	$push5=, $pop4, $2
	i32.load	$push6=, 0($pop5)
	i32.store8	$discard=, 0($pop10), $pop6
	i32.load	$push15=, 0($1)
	i32.add 	$push16=, $pop15, $3
	i32.const	$push17=, -1
	i32.add 	$push18=, $pop16, $pop17
	i32.const	$push11=, default_grn
	i32.add 	$push12=, $pop11, $0
	i32.add 	$push13=, $pop12, $2
	i32.load	$push14=, 0($pop13)
	i32.store8	$discard=, 0($pop18), $pop14
	i32.load	$push23=, 0($1)
	i32.add 	$push24=, $pop23, $3
	i32.const	$push19=, default_blu
	i32.add 	$push20=, $pop19, $0
	i32.add 	$push21=, $pop20, $2
	i32.load	$push22=, 0($pop21)
	i32.store8	$discard=, 0($pop24), $pop22
	i32.const	$push25=, 3
	i32.add 	$3=, $3, $pop25
	i32.const	$push26=, 4
	i32.add 	$0=, $0, $pop26
	br_if   	$0, .LBB0_1
.LBB0_2:                                  # %bar.exit
	return
.Lfunc_end0:
	.size	reset_palette, .Lfunc_end0-reset_palette

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 48
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$2=, 6
	copy_local	$1=, $0
.LBB2_1:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_2
	i32.load	$push3=, vc_cons($0)
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, -2
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push0=, default_red
	i32.add 	$push1=, $pop0, $1
	i32.load	$push2=, 0($pop1)
	i32.store8	$discard=, 0($pop6), $pop2
	i32.load	$push10=, vc_cons($0)
	i32.add 	$push11=, $pop10, $2
	i32.const	$push12=, -1
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push7=, default_grn
	i32.add 	$push8=, $pop7, $1
	i32.load	$push9=, 0($pop8)
	i32.store8	$discard=, 0($pop13), $pop9
	i32.load	$push17=, vc_cons($0)
	i32.add 	$push18=, $pop17, $2
	i32.const	$push14=, default_blu
	i32.add 	$push15=, $pop14, $1
	i32.load	$push16=, 0($pop15)
	i32.store8	$discard=, 0($pop18), $pop16
	i32.const	$push19=, 3
	i32.add 	$2=, $2, $pop19
	i32.const	$push20=, 4
	i32.add 	$1=, $1, $pop20
	i32.const	$push21=, 54
	i32.ne  	$push22=, $2, $pop21
	br_if   	$pop22, .LBB2_1
.LBB2_2:                                  # %reset_palette.exit
	i32.const	$push23=, 0
	call    	exit, $pop23
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	a_con,@object           # @a_con
	.bss
	.globl	a_con
	.align	2
a_con:
	.zero	52
	.size	a_con, 52

	.type	vc_cons,@object         # @vc_cons
	.data
	.globl	vc_cons
	.align	4
vc_cons:
	.int32	a_con
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.zero	4
	.size	vc_cons, 252

	.type	default_red,@object     # @default_red
	.bss
	.globl	default_red
	.align	4
default_red:
	.zero	64
	.size	default_red, 64

	.type	default_grn,@object     # @default_grn
	.globl	default_grn
	.align	4
default_grn:
	.zero	64
	.size	default_grn, 64

	.type	default_blu,@object     # @default_blu
	.globl	default_blu
	.align	4
default_blu:
	.zero	64
	.size	default_blu, 64


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
