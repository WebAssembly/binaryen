.text
.macosx_version_min 10, 10
.file	"test.ll"
.globl	main
.type	main,@function
main:                                   # @main
.param  	i32, i32
.result 	i32
# BB#0:                                 # %entry
i32.const	$push0=, .Lstr
i32.call	$drop=, puts@FUNCTION, $pop0
i32.const	$push1=, 0
return  	$pop1
.endfunc
.Lfunc_end0:
.size	main, .Lfunc_end0-main

.type	.Lstr,@object           # @str
.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
.asciz	"Hello, World!"
.size	.Lstr, 14


.ident	"clang version 3.9.0 (trunk 258659)"
