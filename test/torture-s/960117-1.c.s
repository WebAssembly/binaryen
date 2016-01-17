	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960117-1.c"
	.section	.text.get_id,"ax",@progbits
	.hidden	get_id
	.globl	get_id
	.type	get_id,@function
get_id:                                 # @get_id
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push1=, curval+2
	i32.const	$push0=, 2
	i32.add 	$push2=, $pop1, $pop0
	i32.load16_u	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.shl 	$push5=, $pop3, $pop4
	i32.load16_u	$push6=, curval+2($1)
	i32.or  	$push7=, $pop5, $pop6
	i32.store8	$discard=, 0($pop7), $0
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	get_id, .Lfunc_end0-get_id

	.section	.text.get_tok,"ax",@progbits
	.hidden	get_tok
	.globl	get_tok
	.type	get_tok,@function
get_tok:                                # @get_tok
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, id_space
	i32.store16	$1=, curval+2($0), $pop0
	i32.const	$push4=, curval+2
	i32.const	$push3=, 2
	i32.add 	$push5=, $pop4, $pop3
	i32.const	$push1=, 16
	i32.shr_u	$push2=, $1, $pop1
	i32.store16	$discard=, 0($pop5), $pop2
	i32.store16	$discard=, curval($0), $0
	i32.const	$push6=, 99
	i32.store8	$discard=, id_space($0), $pop6
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	get_tok, .Lfunc_end1-get_tok

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, id_space
	i32.store16	$1=, curval+2($0), $pop0
	i32.const	$push4=, curval+2
	i32.const	$push3=, 2
	i32.add 	$push5=, $pop4, $pop3
	i32.const	$push1=, 16
	i32.shr_u	$push2=, $1, $pop1
	i32.store16	$discard=, 0($pop5), $pop2
	i32.store16	$discard=, curval($0), $0
	i32.const	$push6=, 99
	i32.store8	$discard=, id_space($0), $pop6
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	curval                  # @curval
	.type	curval,@object
	.section	.bss.curval,"aw",@nobits
	.globl	curval
	.align	1
curval:
	.skip	6
	.size	curval, 6

	.type	id_space,@object        # @id_space
	.lcomm	id_space,66,4

	.ident	"clang version 3.9.0 "
