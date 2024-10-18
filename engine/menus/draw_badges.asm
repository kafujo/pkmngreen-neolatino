DrawBadges:
; Draw 4x2 gym leader faces, with the faces replaced by
; badges if they are owned. Used in the player status screen.

; In Japanese versions, names are displayed above faces.
; Instead of removing relevant code, the name graphics were erased.

; Tile ids for face/badge graphics.
	ld de, wBadgeOrFaceTiles
	ld hl, .FaceBadgeTiles
	ld bc, NUM_BADGES
	call CopyData

; Booleans for each badge.
	ld hl, wTempObtainedBadgesBooleans
	ld bc, NUM_BADGES
	xor a
	call FillMemory

; Alter these based on owned badges.
	ld de, wTempObtainedBadgesBooleans
	ld hl, wBadgeOrFaceTiles
	ld a, [wObtainedBadges]
	ld b, a
	ld c, NUM_BADGES
.CheckBadge
	srl b
	jr nc, .NextBadge
	ld a, [hl]
	add 4 ; Badge graphics are after each face
	ld [hl], a
	ld a, 1
	ld [de], a
.NextBadge
	inc hl
	inc de
	dec c
	jr nz, .CheckBadge

; Draw two rows of badges.
	ld hl, wBadgeNumberTile
	ld a, $d8 ; [1]
	ld [hli], a ;increments to cd3e which is wBadgeNameTile
;	ld [hl], $60 ; First name - not used when showing leader names
	ld [hl], $00

	hlcoord 2, 11
	ld de, wTempObtainedBadgesBooleans
	call .DrawBadgeRow

	hlcoord 2, 14
	ld de, wTempObtainedBadgesBooleans + 4
	; fallthrough

.DrawBadgeRow
; Draw 4 badges.

	ld c, 4
.DrawBadge
	push de
	push hl

; Badge no.
	ld a, [wBadgeNumberTile]
	ld [hli], a
	inc a
	ld [wBadgeNumberTile], a

; Names aren't printed if the badge is owned.
;joenote - restoring leader names, 
;so shuffled updating badge names around a bit since it now tracks badge number 
	ld a, [de]
	and a
;	ld a, [wBadgeNameTile]
	jr nz, .SkipName
	call .PlaceTilesName
	jr .PlaceBadge

.SkipName
;	inc a
	ld a, [wBadgeNameTile]
	ld [wBadgeNameTile], a
	inc hl

.PlaceBadge
;	ld [wBadgeNameTile], a
	ld de, SCREEN_WIDTH - 1
	add hl, de
	ld a, [wBadgeOrFaceTiles]
	call .PlaceTiles
	add hl, de
	call .PlaceTiles

; Shift badge array back one byte.
	push bc
	ld hl, wBadgeOrFaceTiles + 1
	ld de, wBadgeOrFaceTiles
	ld bc, NUM_BADGES
	call CopyData
	pop bc

	pop hl
	ld de, 4
	add hl, de

	pop de
	inc de
	dec c
	jr nz, .DrawBadge
	ret

.PlaceTilesName	;joenote - restoring leader names
	push bc
	push hl
	
	;get the correct tile list for the current leader
	ld hl, LeaderNameList
	ld bc, $0000
	ld a, [wBadgeNameTile]
	ld c, a
	inc a	;increment the badge number while we're at it
	ld [wBadgeNameTile], a
	add hl, bc
	add hl, bc
	ld a, [hli]
	push af
	ld a, [hl]
	ld b, a
	pop af
	ld c, a
	
	;BC now points to leader name tile list
	;so let's push & pop HL real quick for printing to the screen
	pop hl
	push hl
.nameloop
	ld a, [bc]
	and a
	jr z, .nameloop_end
	ld [hli], a
	inc bc
	jr .nameloop
.nameloop_end
	
	pop hl
	pop bc
	inc hl
	ret
	
.PlaceTiles
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	ret

.FaceBadgeTiles
	db $20, $28, $30, $38, $40, $48, $50, $58

LeaderNameList:	;joenote - for restoring leader names
	dw .brock
	dw .misty
	dw .surge
	dw .erika
	dw .koga
	dw .sabrina
	dw .blaine
	dw .giovanni
.brock ; takeshi
;	db $60,$61,$62,$00 if using 4 tiles per name as in shinpokered, delete the comma at the start of this row, and start the row below this with a comma
	db $60,$61,$00 ; if using 3 tiles per name as in the pokered-jp
.misty ; kasumi
;	db $63,$64,$65,$00
	db $62,$63,$00
.surge ; machisu
;	db $66,$67,$68,$00
	db $64,$65,$00
.erika
;	db $69,$6A,$00
	db $66,$67,$00
.koga ; kyou
;	db $6B,$6C,$00
	db $68,$69,$00
.sabrina ; natsume
;	db $6D,$6E,$6F,$00
	db $6A,$6B,$00
.blaine ; katsura
;	db $70,$71,$72,$00
	db $6C,$6D,$00
.giovanni ; sakaki
;	db $73,$74,$00
	db $6E,$6F,$00

GymLeaderFaceAndBadgeTileGraphics:
IF GEN_2_GRAPHICS
	INCBIN "gfx/gs/badges.2bpp"
ELSE
	INCBIN "gfx/trainer_card/badges.2bpp"
ENDC
