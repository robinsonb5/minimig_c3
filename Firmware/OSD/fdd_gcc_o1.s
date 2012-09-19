#NO_APP
	.file	"fdd.c"
	.text
	.align	2
	.globl	SendSector
	.type	SendSector, @function
SendSector:
	movem.l #16160,-(%sp)
	move.l 32(%sp),%d6
	move.l 44(%sp),%d3
	move.l 48(%sp),%d1
	move.b 39(%sp),%d0
	move.b 43(%sp),%d2
	move.l #14606352,%a1
	move.w (%a1),%a0
	move.l #14303232,%a0
	move.b #-86,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b #-86,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b #-86,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b #-86,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b %d3,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b %d1,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d4
	move.b %d3,(%a0)
	move.b (%a0),%d3
	move.w (%a1),%d3
	move.b %d1,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	move.b #85,(%a0)
	move.b (%a0),%d1
	move.b %d2,%d4
	lsr.b #1,%d4
	and.b #85,%d4
	move.w (%a1),%d1
	move.b %d4,(%a0)
	move.b (%a0),%d1
	move.b %d0,%d3
	lsr.b #1,%d3
	and.b #85,%d3
	move.w (%a1),%d1
	move.b %d3,(%a0)
	move.b (%a0),%d1
	moveq #0,%d1
	move.b %d0,%d1
	moveq #11,%d5
	sub.l %d1,%d5
	move.l %d5,%d1
	asr.l #1,%d1
	and.b #85,%d1
	move.w (%a1),%d5
	move.b %d1,(%a0)
	move.b (%a0),%d5
	move.w (%a1),%d5
	move.b #85,(%a0)
	move.b (%a0),%d5
	and.b #85,%d2
	eor.b %d2,%d4
	move.w (%a1),%d5
	move.b %d2,(%a0)
	move.b (%a0),%d2
	move.b %d0,%d2
	and.b #85,%d2
	eor.b %d2,%d3
	move.w (%a1),%d5
	move.b %d2,(%a0)
	move.b (%a0),%d2
	moveq #11,%d2
	sub.b %d0,%d2
	move.b %d2,%d0
	and.b #85,%d0
	move.b %d1,%d2
	eor.b %d0,%d2
	move.w (%a1),%d1
	move.b %d0,(%a0)
	move.b (%a0),%d0
	moveq #32,%d0
.L2:
	move.w 14606352,%d1
	move.l #14303232,%a0
	move.b #-86,(%a0)
	move.b (%a0),%d1
	subq.w #1,%d0
	jne .L2
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.b #-86,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #-86,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #-86,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #-86,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #-86,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	or.b #-86,%d4
	move.b %d4,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	or.b #-86,%d3
	move.b %d3,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b %d2,%d1
	or.b #-86,%d1
	move.b %d1,(%a0)
	move.b (%a0),%d0
	move.l %d6,%d0
	add.l #512,%d0
	move.l %d6,%a0
	clr.b %d5
	clr.b %d4
	clr.b %d3
	clr.b %d2
.L3:
	move.b (%a0),%d1
	move.b %d1,%d7
	lsr.b #1,%d7
	eor.b %d7,%d1
	eor.b %d1,%d5
	move.b 1(%a0),%d1
	move.b %d1,%d7
	lsr.b #1,%d7
	eor.b %d7,%d1
	eor.b %d1,%d4
	move.b 2(%a0),%d1
	move.b %d1,%d7
	lsr.b #1,%d7
	eor.b %d7,%d1
	eor.b %d1,%d3
	move.b 3(%a0),%d1
	addq.l #4,%a0
	move.b %d1,%d7
	lsr.b #1,%d7
	eor.b %d7,%d1
	eor.b %d1,%d2
	cmp.l %a0,%d0
	jne .L3
	move.l #14606352,%a1
	move.w (%a1),%d1
	move.l #14303232,%a0
	move.b #-86,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	move.b #-86,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	move.b #-86,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	move.b #-86,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	or.b #-86,%d5
	move.b %d5,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	or.b #-86,%d4
	move.b %d4,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	or.b #-86,%d3
	move.b %d3,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	or.b #-86,%d2
	move.b %d2,(%a0)
	move.b (%a0),%d1
	move.l %d6,%a1
.L4:
	move.w 14606352,%d1
	move.b (%a1)+,%d1
	lsr.b #1,%d1
	or.b #-86,%d1
	move.l #14303232,%a2
	move.b %d1,(%a2)
	move.b (%a2),%d1
	cmp.l %a1,%d0
	jne .L4
	move.l %d6,%a0
.L5:
	move.w 14606352,%d1
	move.b (%a0)+,%d1
	or.b #-86,%d1
	move.l #14303232,%a1
	move.b %d1,(%a1)
	move.b (%a1),%d1
	cmp.l %a0,%d0
	jne .L5
	movem.l (%sp)+,#1276
	rts
	.size	SendSector, .-SendSector
	.align	2
	.globl	SendGap
	.type	SendGap, @function
SendGap:
	move.w #700,%d0
.L11:
	move.w 14606352,%d1
	move.l #14303232,%a0
	move.b #-86,(%a0)
	move.b (%a0),%d1
	subq.w #1,%d0
	jne .L11
	rts
	.size	SendGap, .-SendGap
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Illegal track read: %d\r"
.LC1:
	.string	"    Illegal track read!"
.LC2:
	.string	"*%u:"
.LC3:
	.string	"(%u)[%04X]:"
.LC4:
	.string	"%X:%04X"
.LC5:
	.string	"->"
.LC6:
	.string	":OK\r"
	.text
	.align	2
	.globl	ReadTrack
	.type	ReadTrack, @function
ReadTrack:
	movem.l #16190,-(%sp)
	move.l 48(%sp),%a2
	move.b 671(%a2),%d0
	cmp.b 1(%a2),%d0
	jcs .L14
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC0
	jsr printf
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,-(%sp)
	pea .LC1
	jsr ErrorMessage
	move.b 1(%a2),%d0
	subq.b #1,%d0
	move.b %d0,671(%a2)
	lea (16,%sp),%sp
.L14:
	tst.b DEBUG
	jeq .L15
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,-(%sp)
	pea .LC2
	jsr printf
	addq.l #8,%sp
.L15:
	move.b 671(%a2),%d0
	cmp.b 672(%a2),%d0
	jeq .L16
	move.b %d0,672(%a2)
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),%a0
	move.l %a0,file+28
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,file+20
	clr.b 670(%a2)
	move.l %a0,666(%a2)
	clr.b %d2
	jra .L17
.L16:
	move.b 670(%a2),%d2
	move.l 666(%a2),file+28
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	moveq #0,%d0
	move.b %d2,%d0
	add.l %d0,%d1
	move.l %d1,file+20
.L17:
	move.l #14303236,%a3
	move.w #16,(%a3)
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d3
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d4
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%a1
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.w #17,(%a3)
	tst.b DEBUG
	jeq .L33
	and.l #255,%d3
	lsl.l #8,%d3
	or.b %d1,%d3
	move.l %d3,-(%sp)
	lsr.b #6,%d0
	moveq #3,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	pea .LC3
	jsr printf
	lea (12,%sp),%sp
.L33:
	lea FileRead,%a4
	lea printf,%a6
	move.l #SendSector,%d6
	move.l #SendGap,%d7
	lea file+28,%a3
	lea file+20,%a5
.L35:
	pea sector_buffer
	pea file
	jsr (%a4)
	move.w #16,14303236
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d5
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d3
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	and.l #255,%d4
	lsl.l #8,%d4
	or.b %d0,%d4
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w %d0,%a0
	move.b 1(%a2),%d0
	addq.l #8,%sp
	cmp.b %d3,%d0
	jhi .L20
	move.b %d0,%d3
	subq.b #1,%d3
.L20:
	tst.w %d4
	jeq .L29
	cmp.w #-30444,%d4
	jeq .L30
	cmp.w #-24252,%d4
	jne .L21
	jra .L36
.L29:
	move.w #17545,%d4
	jra .L21
.L30:
	move.w #17545,%d4
	jra .L21
.L36:
	move.w #17545,%d4
.L21:
	tst.b DEBUG
	jeq .L22
	lsl.w #8,%d1
	and.l #16128,%d1
	move.w %a0,%d0
	or.b %d0,%d1
	move.l %d1,-(%sp)
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea .LC4
	jsr (%a6)
	lea (12,%sp),%sp
.L22:
	move.b 671(%a2),%d0
	cmp.b %d0,%d3
	jne .L23
	btst #0,%d5
	jeq .L23
	moveq #0,%d1
	move.b %d4,%d1
	move.l %d1,-(%sp)
	lsr.l #8,%d4
	moveq #0,%d1
	not.b %d1
	and.l %d4,%d1
	move.l %d1,-(%sp)
	and.l #255,%d0
	move.l %d0,-(%sp)
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea sector_buffer
	move.l %d6,%a0
	jsr (%a0)
	lea (20,%sp),%sp
	cmp.b #10,%d2
	jne .L23
	move.l %d7,%a0
	jsr (%a0)
.L23:
	move.w #17,14303236
	move.b 671(%a2),%d0
	cmp.b %d0,%d3
	jne .L24
	btst #0,%d5
	jeq .L24
	addq.b #1,%d2
	cmp.b #10,%d2
	jhi .L25
	pea file
	jsr FileNextSector
	addq.l #4,%sp
	jra .L26
.L25:
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),(%a3)
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,(%a5)
	clr.b %d2
.L26:
	move.b %d2,670(%a2)
	move.l (%a3),666(%a2)
	tst.b DEBUG
	jeq .L35
	pea .LC5
	jsr (%a6)
	addq.l #4,%sp
	jra .L35
.L24:
	tst.b DEBUG
	jeq .L13
	pea .LC6
	jsr printf
	addq.l #4,%sp
.L13:
	movem.l (%sp)+,#31996
	rts
	.size	ReadTrack, .-ReadTrack
	.section	.rodata.str1.1
.LC7:
	.string	"#SYNC:"
	.text
	.align	2
	.globl	FindSync
	.type	FindSync, @function
FindSync:
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%sp),%a2
	move.w #16,14303236
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	btst #1,%d1
	jeq .L38
	cmp.b 671(%a2),%d0
	jeq .L47
	jra .L38
.L45:
	cmp.b 671(%a2),%d1
	jne .L38
.L47:
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	and.b #-65,%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	tst.b %d0
	jne .L40
	tst.b %d1
	jeq .L38
.L40:
	and.w #63,%d0
	lsl.w #8,%d0
	and.w #255,%d1
	add.w %d1,%d0
	jra .L41
.L44:
	move.l #14606352,%a1
	move.w (%a1),%d1
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w (%a1),%a1
	move.b #0,(%a0)
	move.b (%a0),%d2
	cmp.b #68,%d1
	jne .L42
	cmp.b #-119,%d2
	jne .L42
	move.w #17,14303236
	tst.b DEBUG
	jeq .L46
	pea .LC7
	jsr printf
	addq.l #4,%sp
	moveq #1,%d0
	jra .L43
.L42:
	subq.w #1,%d0
.L41:
	tst.w %d0
	jne .L44
	move.l #14303236,%a0
	move.w #17,(%a0)
	move.w #16,(%a0)
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	btst #1,%d0
	jne .L45
.L38:
	move.w #17,14303236
	clr.b %d0
	jra .L43
.L46:
	moveq #1,%d0
.L43:
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	rts
	.size	FindSync, .-FindSync
	.section	.rodata.str1.1
.LC8:
	.string	"\rSecond sync word missing...\r"
.LC9:
	.string	"\rWrong header: %u.%u.%u.%u\r"
.LC10:
	.string	"T%uS%u\r"
	.text
	.align	2
	.globl	GetHeader
	.type	GetHeader, @function
GetHeader:
	movem.l #16190,-(%sp)
	clr.b Error
	move.w #16,14303236
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	btst #1,%d0
	jeq .L49
.L68:
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d2
	moveq #63,%d1
	and.l %d0,%d1
	jne .L50
	cmp.b #24,%d2
	jls .L51
.L50:
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	cmp.b #68,%d0
	jne .L52
	cmp.b #-119,%d1
	jeq .L53
.L52:
	move.b #21,Error
	pea .LC8
	jsr printf
	addq.l #4,%sp
	jra .L49
.L53:
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d7
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d5
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d3
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w %d0,%a3
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w %d1,%a2
	move.b %d7,%d1
	and.b #85,%d1
	add.b %d1,%d1
	move.w %a2,%d0
	and.b #85,%d0
	or.b %d0,%d1
	move.w %d1,%a6
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d6
	move.b %d5,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d6,%d2
	and.b #85,%d2
	or.b %d2,%d0
	move.w %d0,%a4
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.b %d3,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d4,%d2
	and.b #85,%d2
	or.b %d2,%d0
	move.w %d0,%a5
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d2
	move.w %a3,%d0
	and.b #85,%d0
	add.b %d0,%d0
	move.w %d0,%a0
	move.b %d2,%d0
	and.b #85,%d0
	move.w %a0,%d1
	or.b %d1,%d0
	move.w %d0,%a1
	move.w %a6,%d0
	cmp.b #-1,%d0
	jeq .L54
	move.b #22,Error
	jra .L67
.L54:
	move.w %a4,%d1
	cmp.b #-97,%d1
	jls .L56
	move.b #23,Error
	jra .L67
.L56:
	move.w %a5,%d0
	cmp.b #10,%d0
	jls .L57
	move.b #24,Error
	jra .L67
.L57:
	move.w %a1,%d1
	subq.b #1,%d1
	cmp.b #10,%d1
	jls .L58
	move.b #25,Error
	jra .L67
.L58:
	tst.b Error
	jeq .L59
.L67:
	move.w %a1,%d2
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	move.w %a5,%d4
	moveq #0,%d0
	move.b %d4,%d0
	move.l %d0,-(%sp)
	move.w %a4,%d1
	moveq #0,%d0
	move.b %d1,%d0
	move.l %d0,-(%sp)
	move.w %a6,%d2
	moveq #0,%d1
	move.b %d2,%d1
	move.l %d1,-(%sp)
	pea .LC9
	jsr printf
	lea (20,%sp),%sp
	jra .L49
.L59:
	tst.b DEBUG
	jeq .L60
	move.w %a5,%d1
	moveq #0,%d0
	move.b %d1,%d0
	move.l %d0,-(%sp)
	move.w %a4,%d1
	moveq #0,%d0
	move.b %d1,%d0
	move.l %d0,-(%sp)
	pea .LC10
	jsr printf
	lea (12,%sp),%sp
.L60:
	move.w %a2,%d0
	eor.b %d0,%d7
	eor.b %d6,%d5
	eor.b %d4,%d3
	move.w %a3,%d1
	eor.b %d1,%d2
	move.l 48(%sp),%a0
	move.w %a4,%d4
	move.b %d4,(%a0)
	move.l 52(%sp),%a0
	move.w %a5,%d0
	move.b %d0,(%a0)
	moveq #8,%d0
.L61:
	move.l #14606352,%a1
	move.w (%a1),%d1
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d1
	eor.b %d1,%d7
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	eor.b %d1,%d5
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	eor.b %d1,%d3
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	eor.b %d1,%d2
	subq.b #1,%d0
	jne .L61
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w %d1,%a2
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d6
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.w %d4,%a5
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	moveq #85,%d4
	and.l %d4,%d0
	add.l %d0,%d0
	and.l %d4,%d1
	or.l %d1,%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w %d1,%a4
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d4
	move.w %d4,%a3
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	and.b #85,%d7
	cmp.b %d7,%d0
	jne .L62
	move.l %a2,%d0
	moveq #85,%d4
	and.l %d4,%d0
	add.l %d0,%d0
	move.l %a4,%d7
	and.l %d4,%d7
	or.l %d7,%d0
	and.b #85,%d5
	cmp.b %d5,%d0
	jne .L62
	and.l %d4,%d6
	add.l %d6,%d6
	move.l %a3,%d0
	and.l %d4,%d0
	or.l %d6,%d0
	and.b #85,%d3
	cmp.b %d3,%d0
	jne .L62
	move.l %a5,%d4
	moveq #85,%d0
	and.l %d0,%d4
	add.l %d4,%d4
	and.l %d0,%d1
	move.l %d4,%d0
	or.l %d1,%d0
	and.b #85,%d2
	cmp.b %d2,%d0
	jeq .L63
.L62:
	move.b #26,Error
	jra .L49
.L63:
	move.w #17,14303236
	moveq #1,%d0
	jra .L64
.L51:
	tst.b %d0
	jlt .L65
	move.b #20,Error
	jra .L49
.L65:
	move.l #14303236,%a0
	move.w #17,(%a0)
	move.w #16,(%a0)
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	btst #1,%d0
	jne .L68
.L49:
	move.w #17,14303236
	clr.b %d0
.L64:
	movem.l (%sp)+,#31996
	rts
	.size	GetHeader, .-GetHeader
	.align	2
	.globl	GetData
	.type	GetData, @function
GetData:
	subq.l #4,%sp
	movem.l #16190,-(%sp)
	clr.b Error
	move.w #16,14303236
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	btst #1,%d0
	jeq .L72
.L81:
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d2
	move.w %d0,%d1
	and.w #63,%d1
	lsl.w #8,%d1
	and.w #255,%d2
	add.w %d2,%d1
	cmp.w #515,%d1
	jls .L73
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d7
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	move.w %d1,%a4
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d3
	move.w %d3,%a2
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d5
	moveq #85,%d4
	and.l %d4,%d0
	add.l %d0,%d0
	and.l %d4,%d5
	or.b %d0,%d5
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d6
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w %d0,%a3
	move.w (%a1),%d0
	move.b #0,(%a0)
	move.b (%a0),47(%sp)
	move.l #sector_buffer+512,%d4
	clr.b %d2
	clr.b %d3
	clr.b %d1
	lea sector_buffer,%a1
	move.w %d5,%a6
	move.b %d2,%d5
.L74:
	move.l #14606352,%a5
	move.w (%a5),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	eor.b %d0,%d1
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d0,(%a1)
	move.w (%a5),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	eor.b %d0,%d2
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d0,1(%a1)
	move.w (%a5),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	eor.b %d0,%d3
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d0,2(%a1)
	move.w (%a5),%d0
	move.b #0,(%a0)
	move.b (%a0),%d0
	eor.b %d0,%d5
	and.b #85,%d0
	add.b %d0,%d0
	move.b %d0,3(%a1)
	addq.l #4,%a1
	cmp.l %d4,%a1
	jne .L74
	move.b %d1,%d0
	move.b %d2,%d1
	move.b %d5,%d2
	lea sector_buffer,%a0
	move.b %d2,%d5
	move.b %d1,%d2
	move.b %d0,%d1
.L75:
	move.l #14606352,%a5
	move.w (%a5),%d0
	move.l #14303232,%a1
	move.b #0,(%a1)
	move.b (%a1),%d0
	eor.b %d0,%d1
	and.b #85,%d0
	or.b %d0,(%a0)
	move.w (%a5),%d0
	move.b #0,(%a1)
	move.b (%a1),%d0
	eor.b %d0,%d2
	and.b #85,%d0
	or.b %d0,1(%a0)
	move.w (%a5),%d0
	move.b #0,(%a1)
	move.b (%a1),%d0
	eor.b %d0,%d3
	and.b #85,%d0
	or.b %d0,2(%a0)
	move.w (%a5),%d0
	move.b #0,(%a1)
	move.b (%a1),%d0
	eor.b %d0,%d5
	and.b #85,%d0
	or.b %d0,3(%a0)
	addq.l #4,%a0
	cmp.l %d4,%a0
	jne .L75
	move.b %d1,%d0
	move.b %d2,%d1
	move.b %d5,%d2
	move.w %a6,%d5
	and.b #85,%d0
	cmp.b %d5,%d0
	jne .L76
	moveq #85,%d4
	and.l %d4,%d7
	add.l %d7,%d7
	and.l %d4,%d6
	or.l %d7,%d6
	and.b #85,%d1
	cmp.b %d1,%d6
	jne .L76
	move.l %a4,%d0
	and.l %d4,%d0
	add.l %d0,%d0
	move.l %a3,%d1
	and.l %d4,%d1
	or.l %d1,%d0
	and.b #85,%d3
	cmp.b %d3,%d0
	jne .L76
	move.l %a2,%d0
	and.l %d4,%d0
	add.l %d0,%d0
	move.b 47(%sp),%d1
	and.l %d4,%d1
	or.l %d1,%d0
	and.b #85,%d2
	cmp.b %d2,%d0
	jeq .L77
.L76:
	move.b #29,Error
	jra .L72
.L77:
	move.w #17,14303236
	moveq #1,%d0
	jra .L78
.L73:
	tst.b %d0
	jlt .L79
	move.b #28,Error
	jra .L72
.L79:
	move.l #14303236,%a0
	move.w #17,(%a0)
	move.w #16,(%a0)
	move.l #14606352,%a1
	move.w (%a1),%d0
	move.l #14303232,%a0
	move.b #0,(%a0)
	move.b (%a0),%d0
	move.w (%a1),%d1
	move.b #0,(%a0)
	move.b (%a0),%d1
	btst #1,%d0
	jne .L81
.L72:
	move.w #17,14303236
	clr.b %d0
.L78:
	movem.l (%sp)+,#31996
	addq.l #4,%sp
	rts
	.size	GetData, .-GetData
	.section	.rodata.str1.1
.LC11:
	.string	"*%u:\r"
.LC12:
	.string	"Write attempt to protected disk!\r"
.LC13:
	.string	"WriteTrack: error %u\r"
.LC14:
	.string	"  WriteTrack"
	.text
	.align	2
	.globl	WriteTrack
	.type	WriteTrack, @function
WriteTrack:
	subq.l #4,%sp
	movem.l #16190,-(%sp)
	move.l 52(%sp),%a2
	move.b 671(%a2),%d2
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),file+28
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,file+20
	addq.b #1,%d2
	move.b %d2,672(%a2)
	tst.b DEBUG
	jeq .L86
	move.l %d0,-(%sp)
	pea .LC11
	jsr printf
	addq.l #8,%sp
.L86:
	clr.b %d2
	lea FindSync,%a3
	moveq #46,%d3
	add.l %sp,%d3
	moveq #47,%d4
	add.l %sp,%d4
	lea GetHeader,%a6
	move.l #printf,%d6
	move.l #ErrorMessage,%d7
	jra .L102
.L97:
	move.l %d3,-(%sp)
	move.l %d4,-(%sp)
	jsr (%a6)
	addq.l #8,%sp
	tst.b %d0
	jeq .L88
	move.b 671(%a2),%d0
	cmp.b 47(%sp),%d0
	jne .L103
	jra .L105
.L93:
	cmp.b %d2,%d0
	jls .L91
	pea file
	move.l %d5,%a0
	jsr (%a0)
	addq.b #1,%d2
	addq.l #4,%sp
	jra .L104
.L91:
	moveq #0,%d0
	move.b 671(%a2),%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d1,%a0
	move.l 2(%a2,%a0.l),(%a5)
	add.l %d0,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	sub.l %d0,%d1
	move.l %d1,(%a4)
	clr.b %d2
	jra .L104
.L105:
	lea file+28,%a5
	lea file+20,%a4
	move.l #FileNextSector,%d5
.L104:
	move.b 46(%sp),%d0
	cmp.b %d2,%d0
	jne .L93
	jsr GetData
	tst.b %d0
	jeq .L88
	btst #4,(%a2)
	jeq .L94
	pea sector_buffer
	pea file
	jsr FileWrite
	addq.l #8,%sp
	jra .L88
.L94:
	move.b #30,Error
	pea .LC12
	move.l %d6,%a0
	jsr (%a0)
	addq.l #4,%sp
	jra .L88
.L103:
	move.b #27,Error
	moveq #27,%d0
	jra .L95
.L88:
	move.b Error,%d0
	jeq .L102
.L95:
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea .LC13
	move.l %d6,%a0
	jsr (%a0)
	moveq #0,%d0
	move.b Error,%d0
	move.l %d0,-(%sp)
	pea .LC14
	move.l %d7,%a0
	jsr (%a0)
	lea (16,%sp),%sp
.L102:
	move.l %a2,-(%sp)
	jsr (%a3)
	addq.l #4,%sp
	tst.b %d0
	jne .L97
	movem.l (%sp)+,#31996
	addq.l #4,%sp
	rts
	.size	WriteTrack, .-WriteTrack
	.align	2
	.globl	UpdateDriveStatus
	.type	UpdateDriveStatus, @function
UpdateDriveStatus:
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l #14303236,%a1
	move.w #16,(%a1)
	move.l #14606352,%a2
	move.w (%a2),%d0
	move.l #14303232,%a0
	move.b #16,(%a0)
	move.b (%a0),%d0
	move.w (%a2),%d0
	moveq #0,%d0
	move.b df+696,%d0
	move.l %d0,%d2
	add.l %d0,%d2
	moveq #0,%d0
	move.b df+1392,%d0
	add.l %d0,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.b %d2,%d0
	or.b %d1,%d0
	or.b df,%d0
	moveq #0,%d1
	move.b df+2088,%d1
	lsl.l #3,%d1
	or.b %d1,%d0
	move.b %d0,(%a0)
	move.b (%a0),%d0
	move.w #17,(%a1)
	move.l (%sp)+,%d2
	move.l (%sp)+,%a2
	rts
	.size	UpdateDriveStatus, .-UpdateDriveStatus
	.align	2
	.globl	HandleFDD
	.type	HandleFDD, @function
HandleFDD:
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.b 15(%sp),%d0
	move.b 19(%sp),%d2
	move.b %d0,%d1
	lsr.b #4,%d1
	and.b #3,%d1
	move.b %d1,drives
	moveq #0,%d1
	move.b %d0,%d1
	btst #0,%d1
	jeq .L108
	lsr.b #6,%d0
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d0,%a0
	add.l %a0,%a0
	move.l %a0,%d3
	add.l %a0,%d3
	sub.l %d0,%d3
	lsl.l #3,%d3
	sub.l %d0,%d3
	lsl.l #3,%d3
	lea df+670,%a1
	move.b %d2,1(%a1,%d3.l)
	move.l %d3,%d1
	add.l #df,%d1
	move.l %d1,-(%sp)
	jsr ReadTrack
	addq.l #4,%sp
	jra .L107
.L108:
	btst #1,%d1
	jeq .L107
	lsr.b #6,%d0
	and.l #255,%d0
	move.l %d0,%d1
	add.l %d0,%d1
	move.l %d1,%a0
	add.l %d0,%a0
	add.l %a0,%a0
	move.l %a0,%d3
	add.l %a0,%d3
	sub.l %d0,%d3
	lsl.l #3,%d3
	sub.l %d0,%d3
	lsl.l #3,%d3
	lea df+670,%a1
	move.b %d2,1(%a1,%d3.l)
	move.l %d3,%d1
	add.l #df,%d1
	move.l %d1,-(%sp)
	jsr WriteTrack
	addq.l #4,%sp
.L107:
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	rts
	.size	HandleFDD, .-HandleFDD
	.globl	df
	.section	.bss
	.align	2
	.type	df, @object
	.size	df, 2784
df:
	.zero	2784
	.globl	pdfx
	.align	2
	.type	pdfx, @object
	.size	pdfx, 4
pdfx:
	.zero	4
	.globl	drives
	.type	drives, @object
	.size	drives, 1
drives:
	.zero	1
	.globl	DEBUG
	.type	DEBUG, @object
	.size	DEBUG, 1
DEBUG:
	.zero	1
	.ident	"GCC: (GNU) 4.6.2"
