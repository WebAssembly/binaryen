	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021024-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 511
	i32.and 	$2=, $0, $pop6
	i32.const	$push4=, 6
	i32.shr_u	$push5=, $0, $pop4
	i32.const	$push2=, 4088
	i32.and 	$push7=, $pop5, $pop2
	i32.add 	$4=, $1, $pop7
	i32.const	$push16=, 0
	i32.load	$3=, cp($pop16)
	i32.const	$push0=, 20
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push15=, 4088
	i32.and 	$push3=, $pop1, $pop15
	i32.add 	$0=, $1, $pop3
.LBB1_1:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.const	$push19=, 1
	i64.store	$discard=, 0($3), $pop19
	i32.const	$push18=, 0
	i64.load	$push9=, 0($0)
	i64.load	$push8=, 0($4)
	i64.add 	$push10=, $pop9, $pop8
	i64.store	$discard=, m($pop18), $pop10
	i64.const	$push17=, 2
	i64.store	$discard=, 0($3), $pop17
	i32.const	$push20=, 0
	i32.eq  	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push11=, 3
	i32.shl 	$push12=, $2, $pop11
	i32.add 	$push13=, $1, $pop12
	i64.const	$push14=, 1
	i64.store	$discard=, 0($pop13), $pop14
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 0
	i64.const	$push1=, 47
	i64.store	$discard=, main.r+32($pop0):p2align=4, $pop1
	i32.const	$push10=, 0
	i64.const	$push2=, 11
	i64.store	$discard=, main.r+64($pop10):p2align=4, $pop2
	i32.const	$push9=, 0
	i64.const	$push3=, 58
	i64.store	$discard=, m($pop9), $pop3
	i64.const	$push4=, 2
	i64.store	$discard=, 8($3), $pop4
	i32.const	$push8=, 0
	i64.const	$push5=, 1
	i64.store	$discard=, main.r+120($pop8), $pop5
	i32.const	$push7=, 0
	i32.const	$2=, 8
	i32.add 	$2=, $3, $2
	i32.store	$discard=, cp($pop7), $2
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	cp                      # @cp
	.type	cp,@object
	.section	.bss.cp,"aw",@nobits
	.globl	cp
	.p2align	2
cp:
	.int32	0
	.size	cp, 4

	.hidden	m                       # @m
	.type	m,@object
	.section	.bss.m,"aw",@nobits
	.globl	m
	.p2align	3
m:
	.int64	0                       # 0x0
	.size	m, 8

	.type	main.r,@object          # @main.r
	.lcomm	main.r,512,4

	.ident	"clang version 3.9.0 "
