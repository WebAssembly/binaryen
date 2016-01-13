	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001203-2.c"
	.section	.text.create_array_type,"ax",@progbits
	.hidden	create_array_type
	.globl	create_array_type
	.type	create_array_type,@function
create_array_type:                      # @create_array_type
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_8
	i32.const	$push27=, 0
	i32.eq  	$push28=, $0, $pop27
	br_if   	$pop28, .LBB0_8
# BB#1:                                 # %if.end
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 3
	i32.mul 	$push3=, $pop1, $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.const	$push4=, 1
	i32.store16	$6=, 8($0), $pop4
	i32.load	$1=, 4($0)
	i32.const	$7=, 0
	block   	.LBB0_7
	i32.const	$push29=, 0
	i32.eq  	$push30=, $1, $pop29
	br_if   	$pop30, .LBB0_7
# BB#2:                                 # %cond.true
	i32.const	$push5=, 20
	i32.add 	$push6=, $1, $pop5
	i32.load	$2=, 0($pop6)
	i32.const	$7=, 16
	i32.add 	$4=, $1, $7
	i32.load	$3=, 0($4)
	block   	.LBB0_6
	i32.sub 	$push7=, $2, $3
	i32.const	$push8=, 15
	i32.le_s	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB0_6
# BB#3:                                 # %if.end9
	i32.add 	$push0=, $3, $7
	i32.store	$3=, 0($4), $pop0
	i32.const	$push10=, 12
	i32.add 	$5=, $1, $pop10
	i32.load	$7=, 0($5)
	block   	.LBB0_5
	i32.ne  	$push11=, $3, $7
	br_if   	$pop11, .LBB0_5
# BB#4:                                 # %if.then16
	i32.const	$push12=, 28
	i32.add 	$push13=, $1, $pop12
	i32.store	$discard=, 0($pop13), $6
.LBB0_5:                                # %if.end17
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.load	$6=, 0($pop15)
	i32.add 	$push16=, $6, $3
	i32.const	$push17=, -1
	i32.xor 	$push18=, $6, $pop17
	i32.and 	$push19=, $pop16, $pop18
	i32.store	$3=, 0($4), $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	i32.load	$1=, 0($pop21)
	i32.sub 	$push22=, $3, $1
	i32.sub 	$push23=, $2, $1
	i32.gt_s	$push24=, $pop22, $pop23
	i32.select	$push25=, $pop24, $2, $3
	i32.store	$push26=, 0($4), $pop25
	i32.store	$discard=, 0($5), $pop26
	br      	.LBB0_7
.LBB0_6:                                # %if.then8
	call    	_obstack_newchunk@FUNCTION, $0, $0
	unreachable
.LBB0_7:                                # %cond.end
	i32.store	$discard=, 12($0), $7
	return  	$0
.LBB0_8:                                # %if.then
	i32.call	$discard=, alloc_type@FUNCTION
	unreachable
.Lfunc_end0:
	.size	create_array_type, .Lfunc_end0-create_array_type

	.section	.text.alloc_type,"ax",@progbits
	.hidden	alloc_type
	.globl	alloc_type
	.type	alloc_type,@function
alloc_type:                             # @alloc_type
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	alloc_type, .Lfunc_end1-alloc_type

	.section	.text.get_discrete_bounds,"ax",@progbits
	.hidden	get_discrete_bounds
	.globl	get_discrete_bounds
	.type	get_discrete_bounds,@function
get_discrete_bounds:                    # @get_discrete_bounds
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$discard=, 0($0), $pop0
	i64.const	$push1=, 2
	i64.store	$discard=, 0($1), $pop1
	return
.Lfunc_end2:
	.size	get_discrete_bounds, .Lfunc_end2-get_discrete_bounds

	.section	.text._obstack_newchunk,"ax",@progbits
	.hidden	_obstack_newchunk
	.globl	_obstack_newchunk
	.type	_obstack_newchunk,@function
_obstack_newchunk:                      # @_obstack_newchunk
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	_obstack_newchunk, .Lfunc_end3-_obstack_newchunk

	.section	.text.xmalloc,"ax",@progbits
	.hidden	xmalloc
	.globl	xmalloc
	.type	xmalloc,@function
xmalloc:                                # @xmalloc
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end4:
	.size	xmalloc, .Lfunc_end4-xmalloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
