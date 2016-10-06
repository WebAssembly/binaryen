	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980223.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
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

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push18=, $pop6, $pop7
	tee_local	$push17=, $4=, $pop18
	i32.store	__stack_pointer($pop8), $pop17
	block   	
	block   	
	block   	
	i32.load	$push16=, 0($1)
	tee_local	$push15=, $1=, $pop16
	i32.load8_u	$push0=, 4($pop15)
	i32.const	$push14=, 64
	i32.and 	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry.if.end7_crit_edge
	i64.load	$3=, 0($2):p2align=2
	br      	1               # 1: down to label1
.LBB1_2:                                # %if.then
	end_block                       # label2:
	i32.load	$push23=, 0($1)
	tee_local	$push22=, $1=, $pop23
	i64.load	$push21=, 8($pop22):p2align=2
	tee_local	$push20=, $3=, $pop21
	i64.store	0($2):p2align=2, $pop20
	i32.load8_u	$push2=, 4($1)
	i32.const	$push19=, 64
	i32.and 	$push3=, $pop2, $pop19
	br_if   	1, $pop3        # 1: down to label0
.LBB1_3:                                # %if.end7
	end_block                       # label1:
	i64.store	0($0):p2align=2, $3
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $4, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	return
.LBB1_4:                                # %if.then6
	end_block                       # label0:
	i64.load	$push4=, 0($2):p2align=2
	i64.store	8($4):p2align=2, $pop4
	i32.const	$push12=, 8
	i32.add 	$push13=, $4, $pop12
	call    	bar@FUNCTION, $2, $pop13
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push18=, $pop8, $pop9
	tee_local	$push17=, $1=, $pop18
	i32.store	__stack_pointer($pop10), $pop17
	i32.const	$push16=, 0
	i64.load	$push0=, .Lmain.y($pop16)
	i64.store	8($1), $pop0
	block   	
	block   	
	i32.const	$push15=, 0
	i32.load8_u	$push1=, cons2+4($pop15)
	i32.const	$push14=, 64
	i32.and 	$push2=, $pop1, $pop14
	i32.eqz 	$push24=, $pop2
	br_if   	0, $pop24       # 0: down to label4
# BB#1:                                 # %if.then.i
	i32.const	$push22=, 0
	i32.load	$push21=, cons2($pop22)
	tee_local	$push20=, $0=, $pop21
	i64.load	$push3=, 8($pop20):p2align=2
	i64.store	8($1), $pop3
	i32.load8_u	$push4=, 4($0)
	i32.const	$push19=, 64
	i32.and 	$push5=, $pop4, $pop19
	br_if   	1, $pop5        # 1: down to label3
.LBB2_2:                                # %foo.exit
	end_block                       # label4:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push23=, 0
	return  	$pop23
.LBB2_3:                                # %if.then6.i
	end_block                       # label3:
	i64.load	$push6=, 8($1)
	i64.store	0($1):p2align=2, $pop6
	call    	bar@FUNCTION, $1, $1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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

	.type	.Lmain.y,@object        # @main.y
	.section	.rodata..Lmain.y,"a",@progbits
	.p2align	3
.Lmain.y:
	.int32	nil
	.int32	0                       # 0x0
	.size	.Lmain.y, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
