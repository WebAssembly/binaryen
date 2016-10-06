	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021024-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
                                        # fallthrough-return
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
	i32.const	$push0=, 511
	i32.and 	$2=, $0, $pop0
	i32.const	$push1=, 20
	i32.shr_u	$push2=, $0, $pop1
	i32.const	$push3=, 4088
	i32.and 	$push4=, $pop2, $pop3
	i32.add 	$4=, $1, $pop4
	i32.const	$push5=, 6
	i32.shr_u	$push6=, $0, $pop5
	i32.const	$push16=, 4088
	i32.and 	$push7=, $pop6, $pop16
	i32.add 	$3=, $1, $pop7
	i32.const	$push15=, 0
	i32.load	$0=, cp($pop15)
.LBB1_1:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i64.const	$push19=, 1
	i64.store	0($0), $pop19
	i32.const	$push18=, 0
	i64.load	$push9=, 0($4)
	i64.load	$push8=, 0($3)
	i64.add 	$push10=, $pop9, $pop8
	i64.store	m($pop18), $pop10
	i64.const	$push17=, 2
	i64.store	0($0), $pop17
	i32.eqz 	$push20=, $2
	br_if   	0, $pop20       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop
	i32.const	$push11=, 3
	i32.shl 	$push12=, $2, $pop11
	i32.add 	$push13=, $1, $pop12
	i64.const	$push14=, 1
	i64.store	0($pop13), $pop14
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push18=, $pop7, $pop8
	tee_local	$push17=, $0=, $pop18
	i32.store	__stack_pointer($pop9), $pop17
	i32.const	$push1=, 0
	i64.const	$push0=, 47
	i64.store	main.r+32($pop1), $pop0
	i32.const	$push16=, 0
	i64.const	$push2=, 11
	i64.store	main.r+64($pop16), $pop2
	i32.const	$push15=, 0
	i64.const	$push3=, 58
	i64.store	m($pop15), $pop3
	i32.const	$push14=, 0
	i64.const	$push4=, 1
	i64.store	main.r+120($pop14), $pop4
	i32.const	$push13=, 0
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.store	cp($pop13), $pop11
	i64.const	$push5=, 2
	i64.store	8($0), $pop5
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
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
	.section	.bss.main.r,"aw",@nobits
	.p2align	4
main.r:
	.skip	512
	.size	main.r, 512


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
