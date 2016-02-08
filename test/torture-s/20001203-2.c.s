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
	i32.const	$push46=, 0
	i32.eq  	$push47=, $0, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 3
	i32.mul 	$push6=, $pop4, $pop5
	i32.store	$discard=, 0($0), $pop6
	i32.load	$1=, 4($0)
	i32.const	$push7=, 1
	i32.store16	$discard=, 8($0):p2align=2, $pop7
	i32.const	$3=, 0
	block
	i32.const	$push48=, 0
	i32.eq  	$push49=, $1, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#2:                                 # %cond.true
	block
	i32.const	$push8=, 20
	i32.add 	$push9=, $1, $pop8
	i32.load	$push0=, 0($pop9)
	tee_local	$push40=, $4=, $pop0
	i32.const	$push39=, 16
	i32.add 	$push10=, $1, $pop39
	tee_local	$push38=, $2=, $pop10
	i32.load	$push1=, 0($pop38)
	tee_local	$push37=, $5=, $pop1
	i32.sub 	$push11=, $pop40, $pop37
	i32.const	$push12=, 15
	i32.le_s	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label2
# BB#3:                                 # %if.end9
	i32.const	$push15=, 12
	i32.add 	$push16=, $1, $pop15
	i32.load	$3=, 0($pop16)
	block
	i32.const	$push42=, 16
	i32.add 	$push2=, $5, $pop42
	i32.store	$push14=, 0($2), $pop2
	tee_local	$push41=, $5=, $pop14
	i32.ne  	$push17=, $3, $pop41
	br_if   	0, $pop17       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push18=, 28
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 1
	i32.store	$discard=, 0($pop19), $pop20
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push29=, 8
	i32.add 	$push30=, $1, $pop29
	i32.load	$2=, 0($pop30)
	block
	i32.const	$push27=, 16
	i32.add 	$push28=, $1, $pop27
	tee_local	$push45=, $7=, $pop28
	i32.const	$push21=, 24
	i32.add 	$push22=, $1, $pop21
	i32.load	$push23=, 0($pop22)
	tee_local	$push44=, $6=, $pop23
	i32.add 	$push24=, $5, $pop44
	i32.const	$push25=, -1
	i32.xor 	$push26=, $6, $pop25
	i32.and 	$push3=, $pop24, $pop26
	i32.store	$push36=, 0($pop45), $pop3
	tee_local	$push43=, $5=, $pop36
	i32.sub 	$push31=, $pop43, $2
	i32.sub 	$push32=, $4, $2
	i32.le_s	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label4
# BB#6:                                 # %if.then36
	i32.store	$discard=, 0($7), $4
	copy_local	$5=, $4
.LBB0_7:                                # %if.end39
	end_block                       # label4:
	i32.const	$push34=, 12
	i32.add 	$push35=, $1, $pop34
	i32.store	$discard=, 0($pop35), $5
	br      	1               # 1: down to label1
.LBB0_8:                                # %if.then8
	end_block                       # label2:
	call    	_obstack_newchunk@FUNCTION, $0, $0
	unreachable
.LBB0_9:                                # %cond.end
	end_block                       # label1:
	i32.store	$discard=, 12($0), $3
	return  	$0
.LBB0_10:                               # %if.then
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
