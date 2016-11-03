	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001203-2.c"
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
	block   	
	i32.eqz 	$push52=, $0
	br_if   	0, $pop52       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, 1
	i32.store16	8($0), $pop0
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 3
	i32.mul 	$push3=, $pop1, $pop2
	i32.store	0($0), $pop3
	block   	
	i32.load	$push27=, 4($0)
	tee_local	$push26=, $1=, $pop27
	i32.eqz 	$push53=, $pop26
	br_if   	0, $pop53       # 0: down to label2
# BB#2:                                 # %cond.true
	i32.const	$push4=, 20
	i32.add 	$push5=, $1, $pop4
	i32.load	$push34=, 0($pop5)
	tee_local	$push33=, $2=, $pop34
	i32.const	$push32=, 16
	i32.add 	$push31=, $1, $pop32
	tee_local	$push30=, $4=, $pop31
	i32.load	$push29=, 0($pop30)
	tee_local	$push28=, $3=, $pop29
	i32.sub 	$push6=, $pop33, $pop28
	i32.const	$push7=, 15
	i32.le_s	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label0
# BB#3:                                 # %if.end9
	i32.const	$push41=, 16
	i32.add 	$push40=, $3, $pop41
	tee_local	$push39=, $3=, $pop40
	i32.store	0($4), $pop39
	block   	
	i32.const	$push9=, 12
	i32.add 	$push38=, $1, $pop9
	tee_local	$push37=, $4=, $pop38
	i32.load	$push36=, 0($pop37)
	tee_local	$push35=, $7=, $pop36
	i32.ne  	$push10=, $3, $pop35
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then16
	i32.const	$push11=, 28
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	0($pop12), $pop13
.LBB0_5:                                # %if.end17
	end_block                       # label3:
	i32.const	$push19=, 16
	i32.add 	$push51=, $1, $pop19
	tee_local	$push50=, $6=, $pop51
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.load	$push49=, 0($pop15)
	tee_local	$push48=, $5=, $pop49
	i32.add 	$push18=, $pop48, $3
	i32.const	$push16=, -1
	i32.xor 	$push17=, $5, $pop16
	i32.and 	$push47=, $pop18, $pop17
	tee_local	$push46=, $3=, $pop47
	i32.store	0($pop50), $pop46
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	i32.load	$push45=, 0($pop21)
	tee_local	$push44=, $1=, $pop45
	i32.sub 	$push22=, $3, $pop44
	i32.sub 	$push23=, $2, $1
	i32.gt_s	$push24=, $pop22, $pop23
	i32.select	$push43=, $2, $3, $pop24
	tee_local	$push42=, $1=, $pop43
	i32.store	0($6), $pop42
	i32.store	0($4), $1
	i32.store	12($0), $7
	return  	$0
.LBB0_6:
	end_block                       # label2:
	i32.const	$push25=, 0
	i32.store	12($0), $pop25
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.call	$drop=, alloc_type@FUNCTION
	unreachable
.LBB0_8:                                # %if.then8
	end_block                       # label0:
	call    	_obstack_newchunk@FUNCTION, $0, $0
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
	i64.store	0($0), $pop0
	i64.const	$push1=, 2
	i64.store	0($1), $pop1
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop0
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
