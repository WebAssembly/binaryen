	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push275=, 26
	i32.rem_s	$push0=, $4, $pop275
	i32.const	$push274=, 97
	i32.add 	$push1=, $pop0, $pop274
	i32.store8	$discard=, src($4), $pop1
	i32.const	$push273=, 1
	i32.add 	$4=, $4, $pop273
	i32.const	$push272=, 80
	i32.ne  	$push2=, $4, $pop272
	br_if   	$pop2, 0        # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.load16_u	$push3=, src($pop276):p2align=4
	i32.store16	$discard=, dst($pop277):p2align=4, $pop3
	block
	i32.const	$push4=, 1
	i32.const	$push676=, 0
	i32.eq  	$push677=, $pop4, $pop676
	br_if   	$pop677, 0      # 0: down to label3
# BB#3:                                 # %check.exit13
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i32.load8_u	$push5=, src+2($pop282):p2align=1
	i32.store8	$discard=, dst+2($pop283):p2align=1, $pop5
	i32.const	$push281=, 0
	i32.const	$push280=, 0
	i32.load16_u	$push6=, src($pop280):p2align=4
	i32.store16	$discard=, dst($pop281):p2align=4, $pop6
	block
	i32.const	$push279=, dst
	i32.const	$push278=, src
	i32.const	$push7=, 3
	i32.call	$push8=, memcmp@FUNCTION, $pop279, $pop278, $pop7
	br_if   	$pop8, 0        # 0: down to label4
# BB#4:                                 # %check.exit17
	i32.const	$push289=, 0
	i32.load	$4=, src($pop289):p2align=4
	i32.const	$push288=, 0
	i32.const	$push287=, 0
	i32.load8_u	$push9=, src+4($pop287):p2align=2
	i32.store8	$discard=, dst+4($pop288):p2align=2, $pop9
	i32.const	$push286=, 0
	i32.store	$discard=, dst($pop286):p2align=4, $4
	block
	i32.const	$push285=, dst
	i32.const	$push284=, src
	i32.const	$push10=, 5
	i32.call	$push11=, memcmp@FUNCTION, $pop285, $pop284, $pop10
	br_if   	$pop11, 0       # 0: down to label5
# BB#5:                                 # %check.exit25
	i32.const	$push295=, 0
	i32.const	$push294=, 0
	i32.load16_u	$push12=, src+4($pop294):p2align=2
	i32.store16	$discard=, dst+4($pop295):p2align=2, $pop12
	i32.const	$push293=, 0
	i32.const	$push292=, 0
	i32.load	$push13=, src($pop292):p2align=4
	i32.store	$discard=, dst($pop293):p2align=4, $pop13
	block
	i32.const	$push291=, dst
	i32.const	$push290=, src
	i32.const	$push14=, 6
	i32.call	$push15=, memcmp@FUNCTION, $pop291, $pop290, $pop14
	br_if   	$pop15, 0       # 0: down to label6
# BB#6:                                 # %check.exit29
	i32.const	$push303=, 0
	i32.load16_u	$4=, src+4($pop303):p2align=2
	i32.const	$push302=, 0
	i32.load	$0=, src($pop302):p2align=4
	i32.const	$push301=, 0
	i32.const	$push300=, 0
	i32.load8_u	$push16=, src+6($pop300):p2align=1
	i32.store8	$discard=, dst+6($pop301):p2align=1, $pop16
	i32.const	$push299=, 0
	i32.store16	$discard=, dst+4($pop299):p2align=2, $4
	i32.const	$push298=, 0
	i32.store	$discard=, dst($pop298):p2align=4, $0
	block
	i32.const	$push297=, dst
	i32.const	$push296=, src
	i32.const	$push17=, 7
	i32.call	$push18=, memcmp@FUNCTION, $pop297, $pop296, $pop17
	br_if   	$pop18, 0       # 0: down to label7
# BB#7:                                 # %check.exit33
	i32.const	$push309=, 0
	i32.const	$push308=, 0
	i32.load8_u	$push19=, src+8($pop308):p2align=3
	i32.store8	$discard=, dst+8($pop309):p2align=3, $pop19
	i32.const	$push307=, 0
	i32.const	$push306=, 0
	i64.load	$push20=, src($pop306):p2align=4
	i64.store	$discard=, dst($pop307):p2align=4, $pop20
	block
	i32.const	$push305=, dst
	i32.const	$push304=, src
	i32.const	$push21=, 9
	i32.call	$push22=, memcmp@FUNCTION, $pop305, $pop304, $pop21
	br_if   	$pop22, 0       # 0: down to label8
# BB#8:                                 # %check.exit41
	i32.const	$push315=, 0
	i64.load	$1=, src($pop315):p2align=4
	i32.const	$push314=, 0
	i32.const	$push313=, 0
	i32.load16_u	$push23=, src+8($pop313):p2align=3
	i32.store16	$discard=, dst+8($pop314):p2align=3, $pop23
	i32.const	$push312=, 0
	i64.store	$discard=, dst($pop312):p2align=4, $1
	block
	i32.const	$push311=, dst
	i32.const	$push310=, src
	i32.const	$push24=, 10
	i32.call	$push25=, memcmp@FUNCTION, $pop311, $pop310, $pop24
	br_if   	$pop25, 0       # 0: down to label9
# BB#9:                                 # %check.exit45
	i32.const	$push323=, 0
	i32.load16_u	$4=, src+8($pop323):p2align=3
	i32.const	$push322=, 0
	i32.const	$push321=, 0
	i32.load8_u	$push26=, src+10($pop321):p2align=1
	i32.store8	$discard=, dst+10($pop322):p2align=1, $pop26
	i32.const	$push320=, 0
	i32.store16	$discard=, dst+8($pop320):p2align=3, $4
	i32.const	$push319=, 0
	i32.const	$push318=, 0
	i64.load	$push27=, src($pop318):p2align=4
	i64.store	$discard=, dst($pop319):p2align=4, $pop27
	block
	i32.const	$push317=, dst
	i32.const	$push316=, src
	i32.const	$push28=, 11
	i32.call	$push29=, memcmp@FUNCTION, $pop317, $pop316, $pop28
	br_if   	$pop29, 0       # 0: down to label10
# BB#10:                                # %check.exit49
	i32.const	$push329=, 0
	i64.load	$1=, src($pop329):p2align=4
	i32.const	$push328=, 0
	i32.const	$push327=, 0
	i32.load	$push30=, src+8($pop327):p2align=3
	i32.store	$discard=, dst+8($pop328):p2align=3, $pop30
	i32.const	$push326=, 0
	i64.store	$discard=, dst($pop326):p2align=4, $1
	block
	i32.const	$push325=, dst
	i32.const	$push324=, src
	i32.const	$push31=, 12
	i32.call	$push32=, memcmp@FUNCTION, $pop325, $pop324, $pop31
	br_if   	$pop32, 0       # 0: down to label11
# BB#11:                                # %check.exit53
	i32.const	$push337=, 0
	i32.load	$4=, src+8($pop337):p2align=3
	i32.const	$push336=, 0
	i32.const	$push335=, 0
	i32.load8_u	$push33=, src+12($pop335):p2align=2
	i32.store8	$discard=, dst+12($pop336):p2align=2, $pop33
	i32.const	$push334=, 0
	i32.store	$discard=, dst+8($pop334):p2align=3, $4
	i32.const	$push333=, 0
	i32.const	$push332=, 0
	i64.load	$push34=, src($pop332):p2align=4
	i64.store	$discard=, dst($pop333):p2align=4, $pop34
	block
	i32.const	$push331=, dst
	i32.const	$push330=, src
	i32.const	$push35=, 13
	i32.call	$push36=, memcmp@FUNCTION, $pop331, $pop330, $pop35
	br_if   	$pop36, 0       # 0: down to label12
# BB#12:                                # %check.exit57
	i32.const	$push345=, 0
	i32.load	$4=, src+8($pop345):p2align=3
	i32.const	$push344=, 0
	i64.load	$1=, src($pop344):p2align=4
	i32.const	$push343=, 0
	i32.const	$push342=, 0
	i32.load16_u	$push37=, src+12($pop342):p2align=2
	i32.store16	$discard=, dst+12($pop343):p2align=2, $pop37
	i32.const	$push341=, 0
	i32.store	$discard=, dst+8($pop341):p2align=3, $4
	i32.const	$push340=, 0
	i64.store	$discard=, dst($pop340):p2align=4, $1
	block
	i32.const	$push339=, dst
	i32.const	$push338=, src
	i32.const	$push38=, 14
	i32.call	$push39=, memcmp@FUNCTION, $pop339, $pop338, $pop38
	br_if   	$pop39, 0       # 0: down to label13
# BB#13:                                # %check.exit61
	i32.const	$push355=, 0
	i32.load16_u	$4=, src+12($pop355):p2align=2
	i32.const	$push354=, 0
	i32.load	$0=, src+8($pop354):p2align=3
	i32.const	$push353=, 0
	i32.const	$push352=, 0
	i32.load8_u	$push40=, src+14($pop352):p2align=1
	i32.store8	$discard=, dst+14($pop353):p2align=1, $pop40
	i32.const	$push351=, 0
	i32.store16	$discard=, dst+12($pop351):p2align=2, $4
	i32.const	$push350=, 0
	i32.store	$discard=, dst+8($pop350):p2align=3, $0
	i32.const	$push349=, 0
	i32.const	$push348=, 0
	i64.load	$push41=, src($pop348):p2align=4
	i64.store	$discard=, dst($pop349):p2align=4, $pop41
	block
	i32.const	$push347=, dst
	i32.const	$push346=, src
	i32.const	$push42=, 15
	i32.call	$push43=, memcmp@FUNCTION, $pop347, $pop346, $pop42
	br_if   	$pop43, 0       # 0: down to label14
# BB#14:                                # %check.exit65
	i32.const	$push361=, 0
	i64.load	$1=, src($pop361):p2align=4
	i32.const	$push360=, 0
	i32.const	$push359=, 0
	i64.load	$push44=, src+8($pop359)
	i64.store	$discard=, dst+8($pop360), $pop44
	i32.const	$push358=, 0
	i64.store	$discard=, dst($pop358):p2align=4, $1
	block
	i32.const	$push357=, dst
	i32.const	$push356=, src
	i32.const	$push45=, 16
	i32.call	$push46=, memcmp@FUNCTION, $pop357, $pop356, $pop45
	br_if   	$pop46, 0       # 0: down to label15
# BB#15:                                # %check.exit69
	i32.const	$push369=, 0
	i64.load	$1=, src+8($pop369)
	i32.const	$push368=, 0
	i32.const	$push367=, 0
	i32.load8_u	$push47=, src+16($pop367):p2align=4
	i32.store8	$discard=, dst+16($pop368):p2align=4, $pop47
	i32.const	$push366=, 0
	i64.store	$discard=, dst+8($pop366), $1
	i32.const	$push365=, 0
	i32.const	$push364=, 0
	i64.load	$push48=, src($pop364):p2align=4
	i64.store	$discard=, dst($pop365):p2align=4, $pop48
	block
	i32.const	$push363=, dst
	i32.const	$push362=, src
	i32.const	$push49=, 17
	i32.call	$push50=, memcmp@FUNCTION, $pop363, $pop362, $pop49
	br_if   	$pop50, 0       # 0: down to label16
# BB#16:                                # %check.exit73
	i32.const	$push377=, 0
	i64.load	$1=, src+8($pop377)
	i32.const	$push376=, 0
	i64.load	$2=, src($pop376):p2align=4
	i32.const	$push375=, 0
	i32.const	$push374=, 0
	i32.load16_u	$push51=, src+16($pop374):p2align=4
	i32.store16	$discard=, dst+16($pop375):p2align=4, $pop51
	i32.const	$push373=, 0
	i64.store	$discard=, dst+8($pop373), $1
	i32.const	$push372=, 0
	i64.store	$discard=, dst($pop372):p2align=4, $2
	block
	i32.const	$push371=, dst
	i32.const	$push370=, src
	i32.const	$push52=, 18
	i32.call	$push53=, memcmp@FUNCTION, $pop371, $pop370, $pop52
	br_if   	$pop53, 0       # 0: down to label17
# BB#17:                                # %check.exit77
	i32.const	$push387=, 0
	i32.load16_u	$4=, src+16($pop387):p2align=4
	i32.const	$push386=, 0
	i64.load	$1=, src+8($pop386)
	i32.const	$push385=, 0
	i32.const	$push384=, 0
	i32.load8_u	$push54=, src+18($pop384):p2align=1
	i32.store8	$discard=, dst+18($pop385):p2align=1, $pop54
	i32.const	$push383=, 0
	i32.store16	$discard=, dst+16($pop383):p2align=4, $4
	i32.const	$push382=, 0
	i64.store	$discard=, dst+8($pop382), $1
	i32.const	$push381=, 0
	i32.const	$push380=, 0
	i64.load	$push55=, src($pop380):p2align=4
	i64.store	$discard=, dst($pop381):p2align=4, $pop55
	block
	i32.const	$push379=, dst
	i32.const	$push378=, src
	i32.const	$push56=, 19
	i32.call	$push57=, memcmp@FUNCTION, $pop379, $pop378, $pop56
	br_if   	$pop57, 0       # 0: down to label18
# BB#18:                                # %check.exit81
	i32.const	$push395=, 0
	i64.load	$1=, src+8($pop395)
	i32.const	$push394=, 0
	i64.load	$2=, src($pop394):p2align=4
	i32.const	$push393=, 0
	i32.const	$push392=, 0
	i32.load	$push58=, src+16($pop392):p2align=4
	i32.store	$discard=, dst+16($pop393):p2align=4, $pop58
	i32.const	$push391=, 0
	i64.store	$discard=, dst+8($pop391), $1
	i32.const	$push390=, 0
	i64.store	$discard=, dst($pop390):p2align=4, $2
	block
	i32.const	$push389=, dst
	i32.const	$push388=, src
	i32.const	$push59=, 20
	i32.call	$push60=, memcmp@FUNCTION, $pop389, $pop388, $pop59
	br_if   	$pop60, 0       # 0: down to label19
# BB#19:                                # %check.exit85
	i32.const	$push405=, 0
	i32.load	$4=, src+16($pop405):p2align=4
	i32.const	$push404=, 0
	i64.load	$1=, src+8($pop404)
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i32.load8_u	$push61=, src+20($pop402):p2align=2
	i32.store8	$discard=, dst+20($pop403):p2align=2, $pop61
	i32.const	$push401=, 0
	i32.store	$discard=, dst+16($pop401):p2align=4, $4
	i32.const	$push400=, 0
	i64.store	$discard=, dst+8($pop400), $1
	i32.const	$push399=, 0
	i32.const	$push398=, 0
	i64.load	$push62=, src($pop398):p2align=4
	i64.store	$discard=, dst($pop399):p2align=4, $pop62
	block
	i32.const	$push397=, dst
	i32.const	$push396=, src
	i32.const	$push63=, 21
	i32.call	$push64=, memcmp@FUNCTION, $pop397, $pop396, $pop63
	br_if   	$pop64, 0       # 0: down to label20
# BB#20:                                # %check.exit89
	i32.const	$push415=, 0
	i32.load	$4=, src+16($pop415):p2align=4
	i32.const	$push414=, 0
	i64.load	$1=, src+8($pop414)
	i32.const	$push413=, 0
	i32.const	$push412=, 0
	i32.load16_u	$push65=, src+20($pop412):p2align=2
	i32.store16	$discard=, dst+20($pop413):p2align=2, $pop65
	i32.const	$push411=, 0
	i64.load	$2=, src($pop411):p2align=4
	i32.const	$push410=, 0
	i32.store	$discard=, dst+16($pop410):p2align=4, $4
	i32.const	$push409=, 0
	i64.store	$discard=, dst+8($pop409), $1
	i32.const	$push408=, 0
	i64.store	$discard=, dst($pop408):p2align=4, $2
	block
	i32.const	$push407=, dst
	i32.const	$push406=, src
	i32.const	$push66=, 22
	i32.call	$push67=, memcmp@FUNCTION, $pop407, $pop406, $pop66
	br_if   	$pop67, 0       # 0: down to label21
# BB#21:                                # %check.exit93
	i32.const	$push427=, 0
	i32.load16_u	$4=, src+20($pop427):p2align=2
	i32.const	$push426=, 0
	i32.load	$0=, src+16($pop426):p2align=4
	i32.const	$push425=, 0
	i64.load	$1=, src+8($pop425)
	i32.const	$push424=, 0
	i32.const	$push423=, 0
	i32.load8_u	$push68=, src+22($pop423):p2align=1
	i32.store8	$discard=, dst+22($pop424):p2align=1, $pop68
	i32.const	$push422=, 0
	i32.store16	$discard=, dst+20($pop422):p2align=2, $4
	i32.const	$push421=, 0
	i32.store	$discard=, dst+16($pop421):p2align=4, $0
	i32.const	$push420=, 0
	i64.store	$discard=, dst+8($pop420), $1
	i32.const	$push419=, 0
	i32.const	$push418=, 0
	i64.load	$push69=, src($pop418):p2align=4
	i64.store	$discard=, dst($pop419):p2align=4, $pop69
	block
	i32.const	$push417=, dst
	i32.const	$push416=, src
	i32.const	$push70=, 23
	i32.call	$push71=, memcmp@FUNCTION, $pop417, $pop416, $pop70
	br_if   	$pop71, 0       # 0: down to label22
# BB#22:                                # %check.exit97
	i32.const	$push435=, 0
	i64.load	$1=, src+8($pop435)
	i32.const	$push434=, 0
	i64.load	$2=, src($pop434):p2align=4
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i64.load	$push72=, src+16($pop432):p2align=4
	i64.store	$discard=, dst+16($pop433):p2align=4, $pop72
	i32.const	$push431=, 0
	i64.store	$discard=, dst+8($pop431), $1
	i32.const	$push430=, 0
	i64.store	$discard=, dst($pop430):p2align=4, $2
	block
	i32.const	$push429=, dst
	i32.const	$push428=, src
	i32.const	$push73=, 24
	i32.call	$push74=, memcmp@FUNCTION, $pop429, $pop428, $pop73
	br_if   	$pop74, 0       # 0: down to label23
# BB#23:                                # %check.exit101
	i32.const	$push445=, 0
	i64.load	$1=, src+16($pop445):p2align=4
	i32.const	$push444=, 0
	i64.load	$2=, src+8($pop444)
	i32.const	$push443=, 0
	i32.const	$push442=, 0
	i32.load8_u	$push75=, src+24($pop442):p2align=3
	i32.store8	$discard=, dst+24($pop443):p2align=3, $pop75
	i32.const	$push441=, 0
	i64.store	$discard=, dst+16($pop441):p2align=4, $1
	i32.const	$push440=, 0
	i64.store	$discard=, dst+8($pop440), $2
	i32.const	$push439=, 0
	i32.const	$push438=, 0
	i64.load	$push76=, src($pop438):p2align=4
	i64.store	$discard=, dst($pop439):p2align=4, $pop76
	block
	i32.const	$push437=, dst
	i32.const	$push436=, src
	i32.const	$push77=, 25
	i32.call	$push78=, memcmp@FUNCTION, $pop437, $pop436, $pop77
	br_if   	$pop78, 0       # 0: down to label24
# BB#24:                                # %check.exit105
	i32.const	$push455=, 0
	i64.load	$1=, src+16($pop455):p2align=4
	i32.const	$push454=, 0
	i64.load	$2=, src+8($pop454)
	i32.const	$push453=, 0
	i32.const	$push452=, 0
	i32.load16_u	$push79=, src+24($pop452):p2align=3
	i32.store16	$discard=, dst+24($pop453):p2align=3, $pop79
	i32.const	$push451=, 0
	i64.load	$3=, src($pop451):p2align=4
	i32.const	$push450=, 0
	i64.store	$discard=, dst+16($pop450):p2align=4, $1
	i32.const	$push449=, 0
	i64.store	$discard=, dst+8($pop449), $2
	i32.const	$push448=, 0
	i64.store	$discard=, dst($pop448):p2align=4, $3
	block
	i32.const	$push447=, dst
	i32.const	$push446=, src
	i32.const	$push80=, 26
	i32.call	$push81=, memcmp@FUNCTION, $pop447, $pop446, $pop80
	br_if   	$pop81, 0       # 0: down to label25
# BB#25:                                # %check.exit109
	i32.const	$push467=, 0
	i32.load16_u	$4=, src+24($pop467):p2align=3
	i32.const	$push466=, 0
	i64.load	$1=, src+16($pop466):p2align=4
	i32.const	$push465=, 0
	i64.load	$2=, src+8($pop465)
	i32.const	$push464=, 0
	i32.const	$push463=, 0
	i32.load8_u	$push82=, src+26($pop463):p2align=1
	i32.store8	$discard=, dst+26($pop464):p2align=1, $pop82
	i32.const	$push462=, 0
	i32.store16	$discard=, dst+24($pop462):p2align=3, $4
	i32.const	$push461=, 0
	i64.store	$discard=, dst+16($pop461):p2align=4, $1
	i32.const	$push460=, 0
	i64.store	$discard=, dst+8($pop460), $2
	i32.const	$push459=, 0
	i32.const	$push458=, 0
	i64.load	$push83=, src($pop458):p2align=4
	i64.store	$discard=, dst($pop459):p2align=4, $pop83
	block
	i32.const	$push457=, dst
	i32.const	$push456=, src
	i32.const	$push84=, 27
	i32.call	$push85=, memcmp@FUNCTION, $pop457, $pop456, $pop84
	br_if   	$pop85, 0       # 0: down to label26
# BB#26:                                # %check.exit113
	i32.const	$push477=, 0
	i64.load	$1=, src+16($pop477):p2align=4
	i32.const	$push476=, 0
	i64.load	$2=, src+8($pop476)
	i32.const	$push475=, 0
	i32.const	$push474=, 0
	i32.load	$push86=, src+24($pop474):p2align=3
	i32.store	$discard=, dst+24($pop475):p2align=3, $pop86
	i32.const	$push473=, 0
	i64.load	$3=, src($pop473):p2align=4
	i32.const	$push472=, 0
	i64.store	$discard=, dst+16($pop472):p2align=4, $1
	i32.const	$push471=, 0
	i64.store	$discard=, dst+8($pop471), $2
	i32.const	$push470=, 0
	i64.store	$discard=, dst($pop470):p2align=4, $3
	block
	i32.const	$push469=, dst
	i32.const	$push468=, src
	i32.const	$push87=, 28
	i32.call	$push88=, memcmp@FUNCTION, $pop469, $pop468, $pop87
	br_if   	$pop88, 0       # 0: down to label27
# BB#27:                                # %check.exit117
	i32.const	$push489=, 0
	i32.load	$4=, src+24($pop489):p2align=3
	i32.const	$push488=, 0
	i64.load	$1=, src+16($pop488):p2align=4
	i32.const	$push487=, 0
	i64.load	$2=, src+8($pop487)
	i32.const	$push486=, 0
	i32.const	$push485=, 0
	i32.load8_u	$push89=, src+28($pop485):p2align=2
	i32.store8	$discard=, dst+28($pop486):p2align=2, $pop89
	i32.const	$push484=, 0
	i32.store	$discard=, dst+24($pop484):p2align=3, $4
	i32.const	$push483=, 0
	i64.store	$discard=, dst+16($pop483):p2align=4, $1
	i32.const	$push482=, 0
	i64.store	$discard=, dst+8($pop482), $2
	i32.const	$push481=, 0
	i32.const	$push480=, 0
	i64.load	$push90=, src($pop480):p2align=4
	i64.store	$discard=, dst($pop481):p2align=4, $pop90
	block
	i32.const	$push479=, dst
	i32.const	$push478=, src
	i32.const	$push91=, 29
	i32.call	$push92=, memcmp@FUNCTION, $pop479, $pop478, $pop91
	br_if   	$pop92, 0       # 0: down to label28
# BB#28:                                # %check.exit121
	i32.const	$push93=, 0
	i32.load	$4=, src+24($pop93):p2align=3
	i32.const	$push500=, 0
	i32.const	$push499=, 0
	i32.load16_u	$push94=, src+28($pop499):p2align=2
	i32.store16	$discard=, dst+28($pop500):p2align=2, $pop94
	i32.const	$push498=, 0
	i64.load	$1=, src+16($pop498):p2align=4
	i32.const	$push497=, 0
	i64.load	$2=, src+8($pop497)
	i32.const	$push496=, 0
	i32.store	$discard=, dst+24($pop496):p2align=3, $4
	i32.const	$push495=, 0
	i64.load	$3=, src($pop495):p2align=4
	i32.const	$push494=, 0
	i64.store	$discard=, dst+16($pop494):p2align=4, $1
	i32.const	$push493=, 0
	i64.store	$discard=, dst+8($pop493), $2
	i32.const	$push492=, 0
	i64.store	$discard=, dst($pop492):p2align=4, $3
	block
	i32.const	$push491=, dst
	i32.const	$push490=, src
	i32.const	$push95=, 30
	i32.call	$push96=, memcmp@FUNCTION, $pop491, $pop490, $pop95
	br_if   	$pop96, 0       # 0: down to label29
# BB#29:                                # %check.exit125
	block
	i32.const	$push97=, dst
	i32.const	$push504=, src
	i32.const	$push98=, 31
	i32.call	$push99=, memcpy@FUNCTION, $pop97, $pop504, $pop98
	tee_local	$push503=, $4=, $pop99
	i32.const	$push502=, src
	i32.const	$push501=, 31
	i32.call	$push100=, memcmp@FUNCTION, $pop503, $pop502, $pop501
	br_if   	$pop100, 0      # 0: down to label30
# BB#30:                                # %check.exit129
	i32.const	$push101=, 0
	i64.load	$1=, src+16($pop101):p2align=4
	i32.const	$push512=, 0
	i64.load	$2=, src+8($pop512)
	i32.const	$push511=, 0
	i32.const	$push510=, 0
	i64.load	$push102=, src+24($pop510)
	i64.store	$discard=, dst+24($pop511), $pop102
	i32.const	$push509=, 0
	i64.load	$3=, src($pop509):p2align=4
	i32.const	$push508=, 0
	i64.store	$discard=, dst+16($pop508):p2align=4, $1
	i32.const	$push507=, 0
	i64.store	$discard=, dst+8($pop507), $2
	i32.const	$push506=, 0
	i64.store	$discard=, dst($pop506):p2align=4, $3
	block
	i32.const	$push505=, src
	i32.const	$push103=, 32
	i32.call	$push104=, memcmp@FUNCTION, $4, $pop505, $pop103
	br_if   	$pop104, 0      # 0: down to label31
# BB#31:                                # %check.exit133
	block
	i32.const	$push105=, dst
	i32.const	$push516=, src
	i32.const	$push106=, 33
	i32.call	$push107=, memcpy@FUNCTION, $pop105, $pop516, $pop106
	tee_local	$push515=, $4=, $pop107
	i32.const	$push514=, src
	i32.const	$push513=, 33
	i32.call	$push108=, memcmp@FUNCTION, $pop515, $pop514, $pop513
	br_if   	$pop108, 0      # 0: down to label32
# BB#32:                                # %check.exit137
	block
	i32.const	$push519=, src
	i32.const	$push109=, 34
	i32.call	$push110=, memcpy@FUNCTION, $4, $pop519, $pop109
	i32.const	$push518=, src
	i32.const	$push517=, 34
	i32.call	$push111=, memcmp@FUNCTION, $pop110, $pop518, $pop517
	br_if   	$pop111, 0      # 0: down to label33
# BB#33:                                # %check.exit141
	block
	i32.const	$push112=, dst
	i32.const	$push523=, src
	i32.const	$push113=, 35
	i32.call	$push114=, memcpy@FUNCTION, $pop112, $pop523, $pop113
	tee_local	$push522=, $4=, $pop114
	i32.const	$push521=, src
	i32.const	$push520=, 35
	i32.call	$push115=, memcmp@FUNCTION, $pop522, $pop521, $pop520
	br_if   	$pop115, 0      # 0: down to label34
# BB#34:                                # %check.exit145
	block
	i32.const	$push526=, src
	i32.const	$push116=, 36
	i32.call	$push117=, memcpy@FUNCTION, $4, $pop526, $pop116
	i32.const	$push525=, src
	i32.const	$push524=, 36
	i32.call	$push118=, memcmp@FUNCTION, $pop117, $pop525, $pop524
	br_if   	$pop118, 0      # 0: down to label35
# BB#35:                                # %check.exit149
	block
	i32.const	$push119=, dst
	i32.const	$push530=, src
	i32.const	$push120=, 37
	i32.call	$push121=, memcpy@FUNCTION, $pop119, $pop530, $pop120
	tee_local	$push529=, $4=, $pop121
	i32.const	$push528=, src
	i32.const	$push527=, 37
	i32.call	$push122=, memcmp@FUNCTION, $pop529, $pop528, $pop527
	br_if   	$pop122, 0      # 0: down to label36
# BB#36:                                # %check.exit153
	block
	i32.const	$push533=, src
	i32.const	$push123=, 38
	i32.call	$push124=, memcpy@FUNCTION, $4, $pop533, $pop123
	i32.const	$push532=, src
	i32.const	$push531=, 38
	i32.call	$push125=, memcmp@FUNCTION, $pop124, $pop532, $pop531
	br_if   	$pop125, 0      # 0: down to label37
# BB#37:                                # %check.exit157
	block
	i32.const	$push126=, dst
	i32.const	$push537=, src
	i32.const	$push127=, 39
	i32.call	$push128=, memcpy@FUNCTION, $pop126, $pop537, $pop127
	tee_local	$push536=, $4=, $pop128
	i32.const	$push535=, src
	i32.const	$push534=, 39
	i32.call	$push129=, memcmp@FUNCTION, $pop536, $pop535, $pop534
	br_if   	$pop129, 0      # 0: down to label38
# BB#38:                                # %check.exit161
	block
	i32.const	$push540=, src
	i32.const	$push130=, 40
	i32.call	$push131=, memcpy@FUNCTION, $4, $pop540, $pop130
	i32.const	$push539=, src
	i32.const	$push538=, 40
	i32.call	$push132=, memcmp@FUNCTION, $pop131, $pop539, $pop538
	br_if   	$pop132, 0      # 0: down to label39
# BB#39:                                # %check.exit165
	block
	i32.const	$push133=, dst
	i32.const	$push544=, src
	i32.const	$push134=, 41
	i32.call	$push135=, memcpy@FUNCTION, $pop133, $pop544, $pop134
	tee_local	$push543=, $4=, $pop135
	i32.const	$push542=, src
	i32.const	$push541=, 41
	i32.call	$push136=, memcmp@FUNCTION, $pop543, $pop542, $pop541
	br_if   	$pop136, 0      # 0: down to label40
# BB#40:                                # %check.exit169
	block
	i32.const	$push547=, src
	i32.const	$push137=, 42
	i32.call	$push138=, memcpy@FUNCTION, $4, $pop547, $pop137
	i32.const	$push546=, src
	i32.const	$push545=, 42
	i32.call	$push139=, memcmp@FUNCTION, $pop138, $pop546, $pop545
	br_if   	$pop139, 0      # 0: down to label41
# BB#41:                                # %check.exit173
	block
	i32.const	$push140=, dst
	i32.const	$push551=, src
	i32.const	$push141=, 43
	i32.call	$push142=, memcpy@FUNCTION, $pop140, $pop551, $pop141
	tee_local	$push550=, $4=, $pop142
	i32.const	$push549=, src
	i32.const	$push548=, 43
	i32.call	$push143=, memcmp@FUNCTION, $pop550, $pop549, $pop548
	br_if   	$pop143, 0      # 0: down to label42
# BB#42:                                # %check.exit177
	block
	i32.const	$push554=, src
	i32.const	$push144=, 44
	i32.call	$push145=, memcpy@FUNCTION, $4, $pop554, $pop144
	i32.const	$push553=, src
	i32.const	$push552=, 44
	i32.call	$push146=, memcmp@FUNCTION, $pop145, $pop553, $pop552
	br_if   	$pop146, 0      # 0: down to label43
# BB#43:                                # %check.exit181
	block
	i32.const	$push147=, dst
	i32.const	$push558=, src
	i32.const	$push148=, 45
	i32.call	$push149=, memcpy@FUNCTION, $pop147, $pop558, $pop148
	tee_local	$push557=, $4=, $pop149
	i32.const	$push556=, src
	i32.const	$push555=, 45
	i32.call	$push150=, memcmp@FUNCTION, $pop557, $pop556, $pop555
	br_if   	$pop150, 0      # 0: down to label44
# BB#44:                                # %check.exit185
	block
	i32.const	$push561=, src
	i32.const	$push151=, 46
	i32.call	$push152=, memcpy@FUNCTION, $4, $pop561, $pop151
	i32.const	$push560=, src
	i32.const	$push559=, 46
	i32.call	$push153=, memcmp@FUNCTION, $pop152, $pop560, $pop559
	br_if   	$pop153, 0      # 0: down to label45
# BB#45:                                # %check.exit189
	block
	i32.const	$push154=, dst
	i32.const	$push565=, src
	i32.const	$push155=, 47
	i32.call	$push156=, memcpy@FUNCTION, $pop154, $pop565, $pop155
	tee_local	$push564=, $4=, $pop156
	i32.const	$push563=, src
	i32.const	$push562=, 47
	i32.call	$push157=, memcmp@FUNCTION, $pop564, $pop563, $pop562
	br_if   	$pop157, 0      # 0: down to label46
# BB#46:                                # %check.exit193
	block
	i32.const	$push568=, src
	i32.const	$push158=, 48
	i32.call	$push159=, memcpy@FUNCTION, $4, $pop568, $pop158
	i32.const	$push567=, src
	i32.const	$push566=, 48
	i32.call	$push160=, memcmp@FUNCTION, $pop159, $pop567, $pop566
	br_if   	$pop160, 0      # 0: down to label47
# BB#47:                                # %check.exit197
	block
	i32.const	$push161=, dst
	i32.const	$push572=, src
	i32.const	$push162=, 49
	i32.call	$push163=, memcpy@FUNCTION, $pop161, $pop572, $pop162
	tee_local	$push571=, $4=, $pop163
	i32.const	$push570=, src
	i32.const	$push569=, 49
	i32.call	$push164=, memcmp@FUNCTION, $pop571, $pop570, $pop569
	br_if   	$pop164, 0      # 0: down to label48
# BB#48:                                # %check.exit201
	block
	i32.const	$push575=, src
	i32.const	$push165=, 50
	i32.call	$push166=, memcpy@FUNCTION, $4, $pop575, $pop165
	i32.const	$push574=, src
	i32.const	$push573=, 50
	i32.call	$push167=, memcmp@FUNCTION, $pop166, $pop574, $pop573
	br_if   	$pop167, 0      # 0: down to label49
# BB#49:                                # %check.exit205
	block
	i32.const	$push168=, dst
	i32.const	$push579=, src
	i32.const	$push169=, 51
	i32.call	$push170=, memcpy@FUNCTION, $pop168, $pop579, $pop169
	tee_local	$push578=, $4=, $pop170
	i32.const	$push577=, src
	i32.const	$push576=, 51
	i32.call	$push171=, memcmp@FUNCTION, $pop578, $pop577, $pop576
	br_if   	$pop171, 0      # 0: down to label50
# BB#50:                                # %check.exit209
	block
	i32.const	$push582=, src
	i32.const	$push172=, 52
	i32.call	$push173=, memcpy@FUNCTION, $4, $pop582, $pop172
	i32.const	$push581=, src
	i32.const	$push580=, 52
	i32.call	$push174=, memcmp@FUNCTION, $pop173, $pop581, $pop580
	br_if   	$pop174, 0      # 0: down to label51
# BB#51:                                # %check.exit213
	block
	i32.const	$push175=, dst
	i32.const	$push586=, src
	i32.const	$push176=, 53
	i32.call	$push177=, memcpy@FUNCTION, $pop175, $pop586, $pop176
	tee_local	$push585=, $4=, $pop177
	i32.const	$push584=, src
	i32.const	$push583=, 53
	i32.call	$push178=, memcmp@FUNCTION, $pop585, $pop584, $pop583
	br_if   	$pop178, 0      # 0: down to label52
# BB#52:                                # %check.exit217
	block
	i32.const	$push589=, src
	i32.const	$push179=, 54
	i32.call	$push180=, memcpy@FUNCTION, $4, $pop589, $pop179
	i32.const	$push588=, src
	i32.const	$push587=, 54
	i32.call	$push181=, memcmp@FUNCTION, $pop180, $pop588, $pop587
	br_if   	$pop181, 0      # 0: down to label53
# BB#53:                                # %check.exit221
	block
	i32.const	$push182=, dst
	i32.const	$push593=, src
	i32.const	$push183=, 55
	i32.call	$push184=, memcpy@FUNCTION, $pop182, $pop593, $pop183
	tee_local	$push592=, $4=, $pop184
	i32.const	$push591=, src
	i32.const	$push590=, 55
	i32.call	$push185=, memcmp@FUNCTION, $pop592, $pop591, $pop590
	br_if   	$pop185, 0      # 0: down to label54
# BB#54:                                # %check.exit225
	block
	i32.const	$push596=, src
	i32.const	$push186=, 56
	i32.call	$push187=, memcpy@FUNCTION, $4, $pop596, $pop186
	i32.const	$push595=, src
	i32.const	$push594=, 56
	i32.call	$push188=, memcmp@FUNCTION, $pop187, $pop595, $pop594
	br_if   	$pop188, 0      # 0: down to label55
# BB#55:                                # %check.exit229
	block
	i32.const	$push189=, dst
	i32.const	$push600=, src
	i32.const	$push190=, 57
	i32.call	$push191=, memcpy@FUNCTION, $pop189, $pop600, $pop190
	tee_local	$push599=, $4=, $pop191
	i32.const	$push598=, src
	i32.const	$push597=, 57
	i32.call	$push192=, memcmp@FUNCTION, $pop599, $pop598, $pop597
	br_if   	$pop192, 0      # 0: down to label56
# BB#56:                                # %check.exit233
	block
	i32.const	$push603=, src
	i32.const	$push193=, 58
	i32.call	$push194=, memcpy@FUNCTION, $4, $pop603, $pop193
	i32.const	$push602=, src
	i32.const	$push601=, 58
	i32.call	$push195=, memcmp@FUNCTION, $pop194, $pop602, $pop601
	br_if   	$pop195, 0      # 0: down to label57
# BB#57:                                # %check.exit237
	block
	i32.const	$push196=, dst
	i32.const	$push607=, src
	i32.const	$push197=, 59
	i32.call	$push198=, memcpy@FUNCTION, $pop196, $pop607, $pop197
	tee_local	$push606=, $4=, $pop198
	i32.const	$push605=, src
	i32.const	$push604=, 59
	i32.call	$push199=, memcmp@FUNCTION, $pop606, $pop605, $pop604
	br_if   	$pop199, 0      # 0: down to label58
# BB#58:                                # %check.exit241
	block
	i32.const	$push610=, src
	i32.const	$push200=, 60
	i32.call	$push201=, memcpy@FUNCTION, $4, $pop610, $pop200
	i32.const	$push609=, src
	i32.const	$push608=, 60
	i32.call	$push202=, memcmp@FUNCTION, $pop201, $pop609, $pop608
	br_if   	$pop202, 0      # 0: down to label59
# BB#59:                                # %check.exit245
	block
	i32.const	$push203=, dst
	i32.const	$push614=, src
	i32.const	$push204=, 61
	i32.call	$push205=, memcpy@FUNCTION, $pop203, $pop614, $pop204
	tee_local	$push613=, $4=, $pop205
	i32.const	$push612=, src
	i32.const	$push611=, 61
	i32.call	$push206=, memcmp@FUNCTION, $pop613, $pop612, $pop611
	br_if   	$pop206, 0      # 0: down to label60
# BB#60:                                # %check.exit249
	block
	i32.const	$push617=, src
	i32.const	$push207=, 62
	i32.call	$push208=, memcpy@FUNCTION, $4, $pop617, $pop207
	i32.const	$push616=, src
	i32.const	$push615=, 62
	i32.call	$push209=, memcmp@FUNCTION, $pop208, $pop616, $pop615
	br_if   	$pop209, 0      # 0: down to label61
# BB#61:                                # %check.exit253
	block
	i32.const	$push210=, dst
	i32.const	$push621=, src
	i32.const	$push211=, 63
	i32.call	$push212=, memcpy@FUNCTION, $pop210, $pop621, $pop211
	tee_local	$push620=, $4=, $pop212
	i32.const	$push619=, src
	i32.const	$push618=, 63
	i32.call	$push213=, memcmp@FUNCTION, $pop620, $pop619, $pop618
	br_if   	$pop213, 0      # 0: down to label62
# BB#62:                                # %check.exit257
	block
	i32.const	$push624=, src
	i32.const	$push214=, 64
	i32.call	$push215=, memcpy@FUNCTION, $4, $pop624, $pop214
	i32.const	$push623=, src
	i32.const	$push622=, 64
	i32.call	$push216=, memcmp@FUNCTION, $pop215, $pop623, $pop622
	br_if   	$pop216, 0      # 0: down to label63
# BB#63:                                # %check.exit261
	block
	i32.const	$push217=, dst
	i32.const	$push628=, src
	i32.const	$push218=, 65
	i32.call	$push219=, memcpy@FUNCTION, $pop217, $pop628, $pop218
	tee_local	$push627=, $4=, $pop219
	i32.const	$push626=, src
	i32.const	$push625=, 65
	i32.call	$push220=, memcmp@FUNCTION, $pop627, $pop626, $pop625
	br_if   	$pop220, 0      # 0: down to label64
# BB#64:                                # %check.exit265
	block
	i32.const	$push631=, src
	i32.const	$push221=, 66
	i32.call	$push222=, memcpy@FUNCTION, $4, $pop631, $pop221
	i32.const	$push630=, src
	i32.const	$push629=, 66
	i32.call	$push223=, memcmp@FUNCTION, $pop222, $pop630, $pop629
	br_if   	$pop223, 0      # 0: down to label65
# BB#65:                                # %check.exit269
	block
	i32.const	$push224=, dst
	i32.const	$push635=, src
	i32.const	$push225=, 67
	i32.call	$push226=, memcpy@FUNCTION, $pop224, $pop635, $pop225
	tee_local	$push634=, $4=, $pop226
	i32.const	$push633=, src
	i32.const	$push632=, 67
	i32.call	$push227=, memcmp@FUNCTION, $pop634, $pop633, $pop632
	br_if   	$pop227, 0      # 0: down to label66
# BB#66:                                # %check.exit273
	block
	i32.const	$push638=, src
	i32.const	$push228=, 68
	i32.call	$push229=, memcpy@FUNCTION, $4, $pop638, $pop228
	i32.const	$push637=, src
	i32.const	$push636=, 68
	i32.call	$push230=, memcmp@FUNCTION, $pop229, $pop637, $pop636
	br_if   	$pop230, 0      # 0: down to label67
# BB#67:                                # %check.exit277
	block
	i32.const	$push231=, dst
	i32.const	$push642=, src
	i32.const	$push232=, 69
	i32.call	$push233=, memcpy@FUNCTION, $pop231, $pop642, $pop232
	tee_local	$push641=, $4=, $pop233
	i32.const	$push640=, src
	i32.const	$push639=, 69
	i32.call	$push234=, memcmp@FUNCTION, $pop641, $pop640, $pop639
	br_if   	$pop234, 0      # 0: down to label68
# BB#68:                                # %check.exit281
	block
	i32.const	$push645=, src
	i32.const	$push235=, 70
	i32.call	$push236=, memcpy@FUNCTION, $4, $pop645, $pop235
	i32.const	$push644=, src
	i32.const	$push643=, 70
	i32.call	$push237=, memcmp@FUNCTION, $pop236, $pop644, $pop643
	br_if   	$pop237, 0      # 0: down to label69
# BB#69:                                # %check.exit285
	block
	i32.const	$push238=, dst
	i32.const	$push649=, src
	i32.const	$push239=, 71
	i32.call	$push240=, memcpy@FUNCTION, $pop238, $pop649, $pop239
	tee_local	$push648=, $4=, $pop240
	i32.const	$push647=, src
	i32.const	$push646=, 71
	i32.call	$push241=, memcmp@FUNCTION, $pop648, $pop647, $pop646
	br_if   	$pop241, 0      # 0: down to label70
# BB#70:                                # %check.exit289
	block
	i32.const	$push652=, src
	i32.const	$push242=, 72
	i32.call	$push243=, memcpy@FUNCTION, $4, $pop652, $pop242
	i32.const	$push651=, src
	i32.const	$push650=, 72
	i32.call	$push244=, memcmp@FUNCTION, $pop243, $pop651, $pop650
	br_if   	$pop244, 0      # 0: down to label71
# BB#71:                                # %check.exit293
	block
	i32.const	$push245=, dst
	i32.const	$push656=, src
	i32.const	$push246=, 73
	i32.call	$push247=, memcpy@FUNCTION, $pop245, $pop656, $pop246
	tee_local	$push655=, $4=, $pop247
	i32.const	$push654=, src
	i32.const	$push653=, 73
	i32.call	$push248=, memcmp@FUNCTION, $pop655, $pop654, $pop653
	br_if   	$pop248, 0      # 0: down to label72
# BB#72:                                # %check.exit297
	block
	i32.const	$push659=, src
	i32.const	$push249=, 74
	i32.call	$push250=, memcpy@FUNCTION, $4, $pop659, $pop249
	i32.const	$push658=, src
	i32.const	$push657=, 74
	i32.call	$push251=, memcmp@FUNCTION, $pop250, $pop658, $pop657
	br_if   	$pop251, 0      # 0: down to label73
# BB#73:                                # %check.exit301
	block
	i32.const	$push252=, dst
	i32.const	$push663=, src
	i32.const	$push253=, 75
	i32.call	$push254=, memcpy@FUNCTION, $pop252, $pop663, $pop253
	tee_local	$push662=, $4=, $pop254
	i32.const	$push661=, src
	i32.const	$push660=, 75
	i32.call	$push255=, memcmp@FUNCTION, $pop662, $pop661, $pop660
	br_if   	$pop255, 0      # 0: down to label74
# BB#74:                                # %check.exit305
	block
	i32.const	$push666=, src
	i32.const	$push256=, 76
	i32.call	$push257=, memcpy@FUNCTION, $4, $pop666, $pop256
	i32.const	$push665=, src
	i32.const	$push664=, 76
	i32.call	$push258=, memcmp@FUNCTION, $pop257, $pop665, $pop664
	br_if   	$pop258, 0      # 0: down to label75
# BB#75:                                # %check.exit309
	block
	i32.const	$push259=, dst
	i32.const	$push670=, src
	i32.const	$push260=, 77
	i32.call	$push261=, memcpy@FUNCTION, $pop259, $pop670, $pop260
	tee_local	$push669=, $4=, $pop261
	i32.const	$push668=, src
	i32.const	$push667=, 77
	i32.call	$push262=, memcmp@FUNCTION, $pop669, $pop668, $pop667
	br_if   	$pop262, 0      # 0: down to label76
# BB#76:                                # %check.exit313
	block
	i32.const	$push673=, src
	i32.const	$push263=, 78
	i32.call	$push264=, memcpy@FUNCTION, $4, $pop673, $pop263
	i32.const	$push672=, src
	i32.const	$push671=, 78
	i32.call	$push265=, memcmp@FUNCTION, $pop264, $pop672, $pop671
	br_if   	$pop265, 0      # 0: down to label77
# BB#77:                                # %check.exit317
	block
	i32.const	$push267=, dst
	i32.const	$push266=, src
	i32.const	$push268=, 79
	i32.call	$push269=, memcpy@FUNCTION, $pop267, $pop266, $pop268
	i32.const	$push675=, src
	i32.const	$push674=, 79
	i32.call	$push270=, memcmp@FUNCTION, $pop269, $pop675, $pop674
	br_if   	$pop270, 0      # 0: down to label78
# BB#78:                                # %check.exit321
	i32.const	$push271=, 0
	return  	$pop271
.LBB1_79:                               # %if.then.i320
	end_block                       # label78:
	call    	abort@FUNCTION
	unreachable
.LBB1_80:                               # %if.then.i316
	end_block                       # label77:
	call    	abort@FUNCTION
	unreachable
.LBB1_81:                               # %if.then.i312
	end_block                       # label76:
	call    	abort@FUNCTION
	unreachable
.LBB1_82:                               # %if.then.i308
	end_block                       # label75:
	call    	abort@FUNCTION
	unreachable
.LBB1_83:                               # %if.then.i304
	end_block                       # label74:
	call    	abort@FUNCTION
	unreachable
.LBB1_84:                               # %if.then.i300
	end_block                       # label73:
	call    	abort@FUNCTION
	unreachable
.LBB1_85:                               # %if.then.i296
	end_block                       # label72:
	call    	abort@FUNCTION
	unreachable
.LBB1_86:                               # %if.then.i292
	end_block                       # label71:
	call    	abort@FUNCTION
	unreachable
.LBB1_87:                               # %if.then.i288
	end_block                       # label70:
	call    	abort@FUNCTION
	unreachable
.LBB1_88:                               # %if.then.i284
	end_block                       # label69:
	call    	abort@FUNCTION
	unreachable
.LBB1_89:                               # %if.then.i280
	end_block                       # label68:
	call    	abort@FUNCTION
	unreachable
.LBB1_90:                               # %if.then.i276
	end_block                       # label67:
	call    	abort@FUNCTION
	unreachable
.LBB1_91:                               # %if.then.i272
	end_block                       # label66:
	call    	abort@FUNCTION
	unreachable
.LBB1_92:                               # %if.then.i268
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
.LBB1_93:                               # %if.then.i264
	end_block                       # label64:
	call    	abort@FUNCTION
	unreachable
.LBB1_94:                               # %if.then.i260
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB1_95:                               # %if.then.i256
	end_block                       # label62:
	call    	abort@FUNCTION
	unreachable
.LBB1_96:                               # %if.then.i252
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
.LBB1_97:                               # %if.then.i248
	end_block                       # label60:
	call    	abort@FUNCTION
	unreachable
.LBB1_98:                               # %if.then.i244
	end_block                       # label59:
	call    	abort@FUNCTION
	unreachable
.LBB1_99:                               # %if.then.i240
	end_block                       # label58:
	call    	abort@FUNCTION
	unreachable
.LBB1_100:                              # %if.then.i236
	end_block                       # label57:
	call    	abort@FUNCTION
	unreachable
.LBB1_101:                              # %if.then.i232
	end_block                       # label56:
	call    	abort@FUNCTION
	unreachable
.LBB1_102:                              # %if.then.i228
	end_block                       # label55:
	call    	abort@FUNCTION
	unreachable
.LBB1_103:                              # %if.then.i224
	end_block                       # label54:
	call    	abort@FUNCTION
	unreachable
.LBB1_104:                              # %if.then.i220
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB1_105:                              # %if.then.i216
	end_block                       # label52:
	call    	abort@FUNCTION
	unreachable
.LBB1_106:                              # %if.then.i212
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB1_107:                              # %if.then.i208
	end_block                       # label50:
	call    	abort@FUNCTION
	unreachable
.LBB1_108:                              # %if.then.i204
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
.LBB1_109:                              # %if.then.i200
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB1_110:                              # %if.then.i196
	end_block                       # label47:
	call    	abort@FUNCTION
	unreachable
.LBB1_111:                              # %if.then.i192
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
.LBB1_112:                              # %if.then.i188
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
.LBB1_113:                              # %if.then.i184
	end_block                       # label44:
	call    	abort@FUNCTION
	unreachable
.LBB1_114:                              # %if.then.i180
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB1_115:                              # %if.then.i176
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB1_116:                              # %if.then.i172
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB1_117:                              # %if.then.i168
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB1_118:                              # %if.then.i164
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB1_119:                              # %if.then.i160
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB1_120:                              # %if.then.i156
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB1_121:                              # %if.then.i152
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB1_122:                              # %if.then.i148
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB1_123:                              # %if.then.i144
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB1_124:                              # %if.then.i140
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_125:                              # %if.then.i136
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_126:                              # %if.then.i132
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_127:                              # %if.then.i128
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_128:                              # %if.then.i124
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_129:                              # %if.then.i120
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_130:                              # %if.then.i116
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_131:                              # %if.then.i112
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_132:                              # %if.then.i108
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_133:                              # %if.then.i104
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_134:                              # %if.then.i100
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_135:                              # %if.then.i96
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_136:                              # %if.then.i92
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_137:                              # %if.then.i88
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_138:                              # %if.then.i84
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_139:                              # %if.then.i80
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_140:                              # %if.then.i76
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_141:                              # %if.then.i72
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_142:                              # %if.then.i68
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_143:                              # %if.then.i64
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_144:                              # %if.then.i60
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_145:                              # %if.then.i56
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_146:                              # %if.then.i52
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_147:                              # %if.then.i48
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_148:                              # %if.then.i44
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_149:                              # %if.then.i40
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_150:                              # %if.then.i32
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_151:                              # %if.then.i28
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_152:                              # %if.then.i24
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_153:                              # %if.then.i16
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_154:                              # %if.then.i12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.p2align	4
src:
	.skip	80
	.size	src, 80

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.p2align	4
dst:
	.skip	80
	.size	dst, 80


	.ident	"clang version 3.9.0 "
