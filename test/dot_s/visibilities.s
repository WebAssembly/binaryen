	.text
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.protected	bar
	.globl	bar
	.type	bar,@function
bar:
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.internal	qux
	.globl	qux
	.type	qux,@function
qux:
	return
	.endfunc
.Lfunc_end2:
	.size	qux, .Lfunc_end2-qux
