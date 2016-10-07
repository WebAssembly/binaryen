	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991201-1.c"
	.section	.text.reset_palette,"ax",@progbits
	.hidden	reset_palette
	.globl	reset_palette
	.type	reset_palette,@function
reset_palette:                          # @reset_palette
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, vc_cons
	i32.add 	$1=, $pop1, $pop2
	i32.const	$0=, 6
	i32.const	$2=, -64
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.load	$push3=, 0($1)
	i32.add 	$push4=, $pop3, $0
	i32.const	$push25=, -2
	i32.add 	$push5=, $pop4, $pop25
	i32.const	$push24=, default_red+64
	i32.add 	$push6=, $2, $pop24
	i32.load	$push7=, 0($pop6)
	i32.store8	0($pop5), $pop7
	i32.load	$push8=, 0($1)
	i32.add 	$push9=, $pop8, $0
	i32.const	$push23=, -1
	i32.add 	$push10=, $pop9, $pop23
	i32.const	$push22=, default_grn+64
	i32.add 	$push11=, $2, $pop22
	i32.load	$push12=, 0($pop11)
	i32.store8	0($pop10), $pop12
	i32.load	$push13=, 0($1)
	i32.add 	$push14=, $pop13, $0
	i32.const	$push21=, default_blu+64
	i32.add 	$push15=, $2, $pop21
	i32.load	$push16=, 0($pop15)
	i32.store8	0($pop14), $pop16
	i32.const	$push20=, 3
	i32.add 	$0=, $0, $pop20
	i32.const	$push19=, 4
	i32.add 	$push18=, $2, $pop19
	tee_local	$push17=, $2=, $pop18
	br_if   	0, $pop17       # 0: up to label0
# BB#2:                                 # %bar.exit
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	reset_palette, .Lfunc_end0-reset_palette

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 48
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	reset_palette@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a_con                   # @a_con
	.type	a_con,@object
	.section	.bss.a_con,"aw",@nobits
	.globl	a_con
	.p2align	2
a_con:
	.skip	52
	.size	a_con, 52

	.hidden	vc_cons                 # @vc_cons
	.type	vc_cons,@object
	.section	.data.vc_cons,"aw",@progbits
	.globl	vc_cons
	.p2align	4
vc_cons:
	.int32	a_con
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.skip	4
	.size	vc_cons, 252

	.hidden	default_red             # @default_red
	.type	default_red,@object
	.section	.bss.default_red,"aw",@nobits
	.globl	default_red
	.p2align	4
default_red:
	.skip	64
	.size	default_red, 64

	.hidden	default_grn             # @default_grn
	.type	default_grn,@object
	.section	.bss.default_grn,"aw",@nobits
	.globl	default_grn
	.p2align	4
default_grn:
	.skip	64
	.size	default_grn, 64

	.hidden	default_blu             # @default_blu
	.type	default_blu,@object
	.section	.bss.default_blu,"aw",@nobits
	.globl	default_blu
	.p2align	4
default_blu:
	.skip	64
	.size	default_blu, 64


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
