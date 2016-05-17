	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980223.c"
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
	.local  	i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$3=, 0($pop7), $pop13
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
	i64.load	$5=, 0($2):p2align=2
	br      	1               # 1: down to label1
.LBB1_2:                                # %if.then
	end_block                       # label2:
	i32.load	$push21=, 0($1)
	tee_local	$push20=, $1=, $pop21
	i32.load8_u	$4=, 4($pop20)
	i64.load	$push19=, 8($1):p2align=2
	tee_local	$push18=, $5=, $pop19
	i64.store	$discard=, 0($2):p2align=2, $pop18
	i32.const	$push17=, 64
	i32.and 	$push2=, $4, $pop17
	br_if   	1, $pop2        # 1: down to label0
.LBB1_3:                                # %if.end7
	end_block                       # label1:
	i64.store	$discard=, 0($0):p2align=2, $5
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $3, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	return
.LBB1_4:                                # %if.then6
	end_block                       # label0:
	i64.load	$push3=, 0($2):p2align=2
	i64.store	$discard=, 8($3):p2align=2, $pop3
	i32.const	$push11=, 8
	i32.add 	$push12=, $3, $pop11
	call    	bar@FUNCTION, $2, $pop12
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$0=, 0($pop8), $pop12
	i32.const	$push15=, 0
	i32.load8_u	$1=, cons2+4($pop15)
	i32.const	$push14=, 0
	i64.load	$push0=, .Lmain.y($pop14)
	i64.store	$discard=, 8($0), $pop0
	block
	block
	i32.const	$push13=, 64
	i32.and 	$push1=, $1, $pop13
	i32.eqz 	$push21=, $pop1
	br_if   	0, $pop21       # 0: down to label4
# BB#1:                                 # %if.then.i
	i32.const	$push19=, 0
	i32.load	$push18=, cons2($pop19)
	tee_local	$push17=, $1=, $pop18
	i32.load8_u	$2=, 4($pop17)
	i64.load	$push2=, 8($1):p2align=2
	i64.store	$discard=, 8($0), $pop2
	i32.const	$push16=, 64
	i32.and 	$push3=, $2, $pop16
	br_if   	1, $pop3        # 1: down to label3
.LBB2_2:                                # %foo.exit
	end_block                       # label4:
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$discard=, 0($pop11), $pop10
	i32.const	$push20=, 0
	return  	$pop20
.LBB2_3:                                # %if.then6.i
	end_block                       # label3:
	i64.load	$push4=, 8($0)
	i64.store	$discard=, 0($0):p2align=2, $pop4
	call    	bar@FUNCTION, $0, $0
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
	.section	.data.rel.ro..Lmain.y,"aw",@progbits
	.p2align	3
.Lmain.y:
	.int32	nil
	.int32	0                       # 0x0
	.size	.Lmain.y, 8


	.ident	"clang version 3.9.0 "
