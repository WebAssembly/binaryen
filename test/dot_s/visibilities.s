	.text
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:
	return
func_end0:
	.size	foo, func_end0-foo

	.protected	bar
	.globl	bar
	.type	bar,@function
bar:
	return
func_end1:
	.size	bar, func_end1-bar

	.internal	qux
	.globl	qux
	.type	qux,@function
qux:
	return
func_end2:
	.size	qux, func_end2-qux
