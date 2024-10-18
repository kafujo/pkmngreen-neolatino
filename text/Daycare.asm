_DaycareGentlemanIntroText::
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your #MON?"
	done

_DaycareGentlemanWhichMonText::
	text "Which #MON"
	line "should I raise?"
	prompt

_DaycareGentlemanWillLookAfterMonText::
	text "Fine, I'll look"
	line "after @"
	text_ram wcd6d
	text_start
	cont "for a while."
	prompt

_DaycareGentlemanComeSeeMeInAWhileText::
	text "Come see me in"
	line "a while."
	done

_DaycareGentlemanMonHasGrownText::
	text "Your @"
	text_ram wcd6d
	text_start
	line "has grown a lot!"

	para "By level, it's"
	line "grown by @"
	text_decimal wDayCareNumLevelsGrown, 1, 3
	text "!"

	para "Aren't I great?"
	prompt

_DaycareGentlemanOweMoneyText::
;	text "You owe me ¥@"
	text "You owe me @" ; we can't write @¥ to put the yen sign after the money sum as the @ is a calculated variable and the ¥ will disappear or glitch up the game
	text_bcd wDayCareTotalCost, 2 | LEADING_ZEROES | LEFT_ALIGN
	text "¥" ; the "text" command continues text on the SAME line as the previous one if there was one, so this prints ¥ directly after the monetary calculation @.
	line "for the return"
	cont "of this #MON."
	done

_DaycareGentlemanGotMonBackText::
	text "<PLAYER> got"
	line "@"
	text_ram wDayCareMonName
	text " back!"
	done

_DaycareGentlemanMonNeedsMoreTimeText::
	text "Back already?"
	line "Your @"
	text_ram wcd6d
	text_start
	cont "needs some more"
	cont "time with me."
	prompt
