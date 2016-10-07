	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/medce-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store8	ok($pop1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 1
	i32.ne  	$push0=, $0, $pop2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %sw.bb1
	i32.const	$push1=, 0
	i32.const	$push3=, 1
	i32.store8	ok($pop1), $pop3
.LBB1_2:                                # %sw.epilog
	end_block                       # label0:
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
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store8	ok($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	ok,@object              # @ok
	.section	.bss.ok,"aw",@nobits
	.p2align	2
ok:
	.int8	0                       # 0x0
	.size	ok, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
