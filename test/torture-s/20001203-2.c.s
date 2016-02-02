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
	i32.const	$push49=, 0
	i32.eq  	$push50=, $0, $pop49
	br_if   	$pop50, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 3
	i32.mul 	$push6=, $pop4, $pop5
	i32.store	$discard=, 0($0), $pop6
	i32.const	$push7=, 1
	i32.store16	$discard=, 8($0):p2align=2, $pop7
	i32.const	$3=, 0
	block
	i32.load	$push0=, 4($0)
	tee_local	$push38=, $1=, $pop0
	i32.const	$push51=, 0
	i32.eq  	$push52=, $pop38, $pop51
	br_if   	$pop52, 0       # 0: down to label1
# BB#2:                                 # %cond.true
	block
	i32.const	$push8=, 20
	i32.add 	$push9=, $1, $pop8
	i32.load	$push1=, 0($pop9)
	tee_local	$push42=, $5=, $pop1
	i32.const	$push41=, 16
	i32.add 	$push10=, $1, $pop41
	tee_local	$push40=, $2=, $pop10
	i32.load	$push2=, 0($pop40)
	tee_local	$push39=, $4=, $pop2
	i32.sub 	$push11=, $pop42, $pop39
	i32.const	$push12=, 15
	i32.le_s	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label2
# BB#3:                                 # %if.end9
	i32.const	$push15=, 12
	i32.add 	$push16=, $1, $pop15
	tee_local	$push45=, $6=, $pop16
	i32.load	$3=, 0($pop45)
	block
	i32.const	$push44=, 16
	i32.add 	$push3=, $4, $pop44
	i32.store	$push14=, 0($2), $pop3
	tee_local	$push43=, $4=, $pop14
	i32.ne  	$push17=, $pop43, $3
	br_if   	$pop17, 0       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push18=, 28
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 1
	i32.store	$discard=, 0($pop19), $pop20
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push28=, 16
	i32.add 	$2=, $1, $pop28
	i32.const	$push21=, 24
	i32.add 	$push22=, $1, $pop21
	i32.load	$push23=, 0($pop22)
	tee_local	$push48=, $7=, $pop23
	i32.add 	$push24=, $pop48, $4
	i32.const	$push25=, -1
	i32.xor 	$push26=, $7, $pop25
	i32.and 	$push27=, $pop24, $pop26
	i32.store	$push29=, 0($2), $pop27
	tee_local	$push47=, $4=, $pop29
	i32.const	$push30=, 8
	i32.add 	$push31=, $1, $pop30
	i32.load	$push32=, 0($pop31)
	tee_local	$push46=, $1=, $pop32
	i32.sub 	$push33=, $pop47, $pop46
	i32.sub 	$push34=, $5, $1
	i32.gt_s	$push35=, $pop33, $pop34
	i32.select	$push36=, $pop35, $5, $4
	i32.store	$push37=, 0($2), $pop36
	i32.store	$discard=, 0($6), $pop37
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
