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
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$5=, $pop12, $pop13
	i32.const	$push14=, __stack_pointer
	i32.store	$discard=, 0($pop14), $5
	block
	block
	block
	i32.load	$push7=, 0($1)
	tee_local	$push6=, $1=, $pop7
	i32.load8_u	$push1=, 4($pop6)
	i32.const	$push5=, 64
	i32.and 	$push2=, $pop1, $pop5
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %entry.if.end7_crit_edge
	i64.load	$4=, 0($2):p2align=2
	br      	1               # 1: down to label1
.LBB1_2:                                # %if.then
	end_block                       # label2:
	i32.load	$push10=, 0($1)
	tee_local	$push9=, $1=, $pop10
	i32.load8_u	$3=, 4($pop9)
	i64.load	$push0=, 8($1):p2align=2
	i64.store	$4=, 0($2):p2align=2, $pop0
	i32.const	$push8=, 64
	i32.and 	$push3=, $3, $pop8
	br_if   	1, $pop3        # 1: down to label0
.LBB1_3:                                # %if.end7
	end_block                       # label1:
	i64.store	$discard=, 0($0):p2align=2, $4
	i32.const	$push17=, __stack_pointer
	i32.const	$push15=, 16
	i32.add 	$push16=, $5, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	return
.LBB1_4:                                # %if.then6
	end_block                       # label0:
	i64.load	$push4=, 0($2):p2align=2
	i64.store	$discard=, 8($5):p2align=2, $pop4
	i32.const	$push18=, 8
	i32.add 	$push19=, $5, $pop18
	call    	bar@FUNCTION, $2, $pop19
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
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$2=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $2
	i32.const	$push7=, 0
	i32.load8_u	$0=, cons2+4($pop7)
	i32.const	$push6=, 0
	i64.load	$push0=, .Lmain.y($pop6)
	i64.store	$discard=, 8($2), $pop0
	block
	block
	i32.const	$push5=, 64
	i32.and 	$push1=, $0, $pop5
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop1, $pop20
	br_if   	0, $pop21       # 0: down to label4
# BB#1:                                 # %if.then.i
	i32.const	$push11=, 0
	i32.load	$push10=, cons2($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.load8_u	$1=, 4($pop9)
	i64.load	$push2=, 8($0):p2align=2
	i64.store	$discard=, 8($2), $pop2
	i32.const	$push8=, 64
	i32.and 	$push3=, $1, $pop8
	br_if   	1, $pop3        # 1: down to label3
.LBB2_2:                                # %foo.exit
	end_block                       # label4:
	i32.const	$push12=, 0
	i32.const	$push19=, __stack_pointer
	i32.const	$push17=, 16
	i32.add 	$push18=, $2, $pop17
	i32.store	$discard=, 0($pop19), $pop18
	return  	$pop12
.LBB2_3:                                # %if.then6.i
	end_block                       # label3:
	i64.load	$push4=, 8($2)
	i64.store	$discard=, 0($2):p2align=2, $pop4
	call    	bar@FUNCTION, $0, $2
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
