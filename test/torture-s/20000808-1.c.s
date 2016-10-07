	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000808-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push1=, 4($0)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push4=, 0($1)
	i32.const	$push5=, -1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#3:                                 # %lor.lhs.false5
	i32.load	$push7=, 4($1)
	br_if   	0, $pop7        # 0: down to label0
# BB#4:                                 # %lor.lhs.false8
	i32.load	$push8=, 0($2)
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#5:                                 # %lor.lhs.false11
	i32.load	$push11=, 4($2)
	i32.const	$push26=, -1
	i32.ne  	$push12=, $pop11, $pop26
	br_if   	0, $pop12       # 0: down to label0
# BB#6:                                 # %lor.lhs.false14
	i32.load	$push13=, 0($3)
	i32.const	$push27=, -1
	i32.ne  	$push14=, $pop13, $pop27
	br_if   	0, $pop14       # 0: down to label0
# BB#7:                                 # %lor.lhs.false17
	i32.load	$push15=, 4($3)
	i32.const	$push16=, 1
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#8:                                 # %lor.lhs.false20
	i32.load	$push18=, 0($4)
	br_if   	0, $pop18       # 0: down to label0
# BB#9:                                 # %lor.lhs.false23
	i32.load	$push19=, 4($4)
	i32.const	$push20=, -1
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#10:                                # %lor.lhs.false26
	i32.load	$push22=, 0($5)
	i32.const	$push23=, 1
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#11:                                # %lor.lhs.false29
	i32.load	$push25=, 4($5)
	br_if   	0, $pop25       # 0: down to label0
# BB#12:                                # %if.end
	return
.LBB1_13:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %f.exit
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
