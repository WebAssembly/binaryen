	.text
	.section	.text.foo,"ax",@progbits
	.globl	foo
	.type	foo,@function
foo:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.globl	bar
	.type	bar,@function
bar:
	.param  	i32
	.result 	i32
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.qux,"ax",@progbits
	.globl	qux
	.type	qux,@function
qux:
	.param  	f64, f64
	.result 	f64
	f64.add 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	qux, .Lfunc_end2-qux

	.type	aaa,@object
	.section	.bss.aaa,"aw",@nobits
	.globl	aaa
	.align	2
aaa:
	.int32	0
	.size	aaa, 4

	.type	bbb,@object
	.section	.data.bbb,"aw",@progbits
	.globl	bbb
	.align	2
bbb:
	.int32	1
	.size	bbb, 4

	.type	ccc,@object
	.section	.data.ccc,"aw",@progbits
	.globl	ccc
	.align	2
ccc:
	.int32	1075000115
	.size	ccc, 4
