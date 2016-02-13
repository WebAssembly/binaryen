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
	block
	i32.const	$push45=, 0
	i32.eq  	$push46=, $0, $pop45
	br_if   	0, $pop46       # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 3
	i32.mul 	$push5=, $pop3, $pop4
	i32.store	$discard=, 0($0), $pop5
	i32.load	$1=, 4($0)
	i32.const	$push6=, 1
	i32.store16	$discard=, 8($0):p2align=2, $pop6
	i32.const	$3=, 0
	block
	i32.const	$push47=, 0
	i32.eq  	$push48=, $1, $pop47
	br_if   	0, $pop48       # 0: down to label1
# BB#2:                                 # %cond.true
	block
	i32.const	$push7=, 20
	i32.add 	$push8=, $1, $pop7
	i32.load	$push0=, 0($pop8)
	tee_local	$push39=, $5=, $pop0
	i32.const	$push38=, 16
	i32.add 	$push9=, $1, $pop38
	tee_local	$push37=, $2=, $pop9
	i32.load	$push1=, 0($pop37)
	tee_local	$push36=, $4=, $pop1
	i32.sub 	$push10=, $pop39, $pop36
	i32.const	$push11=, 15
	i32.le_s	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label2
# BB#3:                                 # %if.end9
	i32.const	$push14=, 12
	i32.add 	$push15=, $1, $pop14
	tee_local	$push42=, $6=, $pop15
	i32.load	$3=, 0($pop42)
	block
	i32.const	$push41=, 16
	i32.add 	$push2=, $4, $pop41
	i32.store	$push13=, 0($2), $pop2
	tee_local	$push40=, $4=, $pop13
	i32.ne  	$push16=, $3, $pop40
	br_if   	0, $pop16       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push17=, 28
	i32.add 	$push18=, $1, $pop17
	i32.const	$push19=, 1
	i32.store	$discard=, 0($pop18), $pop19
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push29=, 8
	i32.add 	$push30=, $1, $pop29
	i32.load	$2=, 0($pop30)
	i32.const	$push27=, 16
	i32.add 	$push28=, $1, $pop27
	tee_local	$push44=, $7=, $pop28
	i32.const	$push20=, 24
	i32.add 	$push21=, $1, $pop20
	i32.load	$push22=, 0($pop21)
	tee_local	$push43=, $1=, $pop22
	i32.add 	$push23=, $pop43, $4
	i32.const	$push24=, -1
	i32.xor 	$push25=, $1, $pop24
	i32.and 	$push26=, $pop23, $pop25
	i32.store	$1=, 0($pop44), $pop26
	i32.sub 	$push31=, $1, $2
	i32.sub 	$push32=, $5, $2
	i32.gt_s	$push33=, $pop31, $pop32
	i32.select	$push34=, $5, $1, $pop33
	i32.store	$push35=, 0($7), $pop34
	i32.store	$discard=, 0($6), $pop35
	br      	1               # 1: down to label1
.LBB0_6:                                # %if.then8
	end_block                       # label2:
	call    	_obstack_newchunk@FUNCTION, $0, $0
	unreachable
.LBB0_7:                                # %cond.end
	end_block                       # label1:
	i32.store	$discard=, 12($0), $3
	return  	$0
.LBB0_8:                                # %if.then
	end_block                       # label0:
	i32.call	$discard=, alloc_type@FUNCTION
	unreachable
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
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
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 3.9.0 "
