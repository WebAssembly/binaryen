	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000731-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, 0x0p0
	return  	$pop0
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.do_sibcall,"ax",@progbits
	.hidden	do_sibcall
	.globl	do_sibcall
	.type	do_sibcall,@function
do_sibcall:                             # @do_sibcall
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	do_sibcall, .Lfunc_end1-do_sibcall

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
