	.text
	.file	"980223.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i64
# BB#0:                                 # %entry
	block   	
	i32.load	$push7=, 0($1)
	tee_local	$push6=, $1=, $pop7
	i32.load8_u	$push0=, 4($pop6)
	i32.const	$push5=, 64
	i32.and 	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry.if.end7_crit_edge
	i64.load	$push4=, 0($2):p2align=2
	i64.store	0($0):p2align=2, $pop4
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	i32.load	$push12=, 0($1)
	tee_local	$push11=, $1=, $pop12
	i64.load	$push10=, 8($pop11):p2align=2
	tee_local	$push9=, $3=, $pop10
	i64.store	0($2):p2align=2, $pop9
	block   	
	i32.load8_u	$push2=, 4($1)
	i32.const	$push8=, 64
	i32.and 	$push3=, $pop2, $pop8
	br_if   	0, $pop3        # 0: down to label1
# BB#3:                                 # %if.end7
	i64.store	0($0):p2align=2, $3
	return
.LBB1_4:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push6=, 0
	i32.load8_u	$push0=, cons2+4($pop6)
	i32.const	$push5=, 64
	i32.and 	$push1=, $pop0, $pop5
	i32.eqz 	$push10=, $pop1
	br_if   	0, $pop10       # 0: down to label3
# BB#1:                                 # %if.then.i
	i32.const	$push8=, 0
	i32.load	$push2=, cons2($pop8)
	i32.load8_u	$push3=, 4($pop2)
	i32.const	$push7=, 64
	i32.and 	$push4=, $pop3, $pop7
	br_if   	1, $pop4        # 1: down to label2
.LBB2_2:                                # %foo.exit
	end_block                       # label3:
	i32.const	$push9=, 0
	return  	$pop9
.LBB2_3:                                # %if.then6.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	nil                     # @nil
	.type	nil,@object
	.section	.bss.nil,"aw",@nobits
	.globl	nil
	.p2align	2
nil:
	.int32	0                       # 0x0
	.size	nil, 4

	.hidden	cons1                   # @cons1
	.type	cons1,@object
	.section	.data.cons1,"aw",@progbits
	.globl	cons1
	.p2align	4
cons1:
	.int32	nil
	.int32	0                       # 0x0
	.int32	nil
	.int32	0                       # 0x0
	.size	cons1, 16

	.hidden	cons2                   # @cons2
	.type	cons2,@object
	.section	.data.cons2,"aw",@progbits
	.globl	cons2
	.p2align	4
cons2:
	.int32	cons1
	.int32	64                      # 0x40
	.int32	nil
	.int32	0                       # 0x0
	.size	cons2, 16


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
