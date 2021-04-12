\language "english"
\version "2.18.2"
#(define (line-break-every-nth-engraver bars-per-line)
  (lambda (context)
     (make-engraver
       (acknowledgers ((paper-column-interface engraver grob source-engraver)
         (let ((current-bar (ly:context-property context 'currentBarNumber)))
           (if (= (remainder current-bar bars-per-line) 1)
               (if (eq? #t (ly:grob-property grob 'non-musical))
                   (set! (ly:grob-property grob 'line-break-permission) 'force)
                   (set! (ly:grob-property grob 'line-break-permission)
'())))))))))

\header {
	title = "Isaiah 53"
	subtitle = ""
	composer = "Jason Silver"
	poet = ""
	copyright = "Silver Ink. 2021"
	tagline = "Permission granted to share with attribution."
}
\paper {
	top-margin = #10
	bottom-margin = #4
	right-margin = #12
	left-margin = #12
	indent = #0
	%min-systems-per-page = 12 % this allows you to squish line spacing

	% the distance between two systems in the same score:
	system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . -.5 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -6) (stretchability . 0))
	% the distance between the last system of a score and the (title or top-level) markup that follows it:
	score-markup-spacing = #'((basic-distance . 0) (padding . -4) (stretchability . 0))
	% the distance between two (title or top-level) markups:
	markup-markup-spacing = #'((basic-distance . 0) (padding . 0))
	% the distance from the top of the printable area (i.e. the bottom of the top margin) to the first system on a page, when there is no (title or top-level) markup between the two:
	top-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
	% the distance from the top of the printable area (i.e. the bottom of the top margin) to the first (title or top-level) markup on a page, when there is no system between the two:
	top-markup-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
	% the distance from the last system or top-level markup on a page to the bottom of the printable area (i.e. the top of the bottom margin):
	last-bottom-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . 0) (stretchability . 0))

	paper-width = 21.59\cm
	paper-height = 27.94\cm
}
slashOn = {
	\override Rest #'stencil = #ly:percent-repeat-item-interface::beat-slash
	\override Rest #'thickness = #'0.48
	\override Rest #'slope = #'1.2
	\override Rest #'Y-offset = #'-.0
}
slashOff = {
	\revert Rest #'stencil
}
LyricFontSize = #.5
lyricNote = {
	% use \once \set melismaBusyProperties = #'(tieMelismaBusy) on the tie where the note sits
	\once \override Lyrics.LyricText.font-shape = #'italic
	\once \override Lyrics.LyricText.font-size = #.2
	\once \override LyricText.self-alignment-X = #LEFT
}
lyricNotePlacement = {
	\once \override NoteHead.stencil = #ly:text-interface::print
	\once \override NoteHead.text = \markup \musicglyph #"rests.2"
	\once  \hide Stem
}
sectionTitle = #(define-music-function
	(parser location theTitle)
	(string?)
	#{
	\mark \markup { \large \bold \concat { "            " #theTitle } }
	#}
)
textRepeats  = #(define-music-function
	(parser location theTitle)
	(string?)
	#{
	\once \override Score.RehearsalMark #'break-visibility = #'#(#t #t #f)
	\mark \markup { \right-align \small #theTitle }
	#}
)
GotoCoda = {
	\once \override Score.RehearsalMark #'break-visibility = #'#(#t #t #f)
	\mark \markup { \small \musicglyph #"scripts.coda" }
}
Coda = {
	\once \override Score.RehearsalMark #'break-visibility = #'#(#f #t #t)
	\mark \markup { \small \musicglyph #"scripts.coda" }
}
Segno = {
	\once \override Score.RehearsalMark #'break-visibility = #'#(#f #t #t)
	\mark \markup { \small \musicglyph #"scripts.segno" }
}
chExceptionMusic = {
	<c d e g>1-\markup { "2" } % notate as 1.2.3.5
	<c f g>1-\markup {"sus"}
	<c a d g>1-\markup { "m2" } % 1.6.2.
	<c e g d'>1-\markup { \super "add9" } % 1.3.5.9
	<c ef g d'>1-\markup { "m" \super "add9" } % 1.3.5.9
}
chExceptions = #(append (sequential-music-to-chord-exceptions chExceptionMusic #t) ignatzekExceptions)
chordNames = \chordmode {
	\set chordNameExceptions = #chExceptions
	\set chordChanges = ##t % ##t(true) or ##f(false)
	\skip1 ef1 f:m7 af:1.2.3.5 bf:/af ef:/g af:1.2.3.5 f:m bf:/d
	ef1 f:m7 af:1.2.3.5 bf:/af ef:/g af:1.2.3.5 f:m bf2:/d ef:/g af1:1.3.5.9
	bf2:/d ef:/g af1:1.3.5.9 f2:m ef:/g af1:1.3.5.9 ef:/g f:m f:m
	f:m

	ef1 f:m7 af af ef f:m7 af f2:m ef:/g af1 af:1.2.3.5

	df af:/c ef:/bf bf df af:/c ef:/bf bf
	df af:/c ef:/bf bf df af:/c ef:/bf bf1

	af ef:/g af c:m af ef:/g af c:m f:m

}
melody = \relative c'{

	%\set melismaBusyProperties = #'()
	\time 4/4
	\key ef  \major
	\clef treble
	\tempo 4 = 90
	\override Score.MetronomeMark.padding = #3
	\sectionTitle ""
	r4. bf8 c ef c af'~ \bar ".|:-||"
	\repeat volta 2 {
		af g4 ef8~ef bf4 c8~c4 r8 bf c ef c af'~af g f ef~ef c4 f8~f4
		r8 bf, c ef c af'~af g4 ef8~ef  c8 ef af~af g4 ef8~ef c4 f8~f2 r2 | r2 c8 ef c af'~|
		af g4 ef8~ef bf4 c8~c4 r4 c8 ef c af'~af g f ef~ef c4 f8~f4
		r4 c8 ef c af'~af g4 f8~f ef4 c8 af' g f ef~ef c4 f8~f2 r2 | r2 g8 af bf bf~ \bar "||"
		\break
		bf af g f~f ef~ef4 r4. ef8 g af4 bf8~bf af4 g8 g f ef f~f2 g8 af4 bf8~bf4 g8 f~f ef4 ef8
		bf' af g f~f ef~ef4 | f4 r2. | 
	}
	\alternative{
		{ r2 c8 ef4  af8  }
		{ f4 r4 \sectionTitle "Chorus" g8 af bf ef~  }
	}
	\bar "||" \break
	ef4 r4 g,8 af bf f'~ | f ef~ef4 g,8 af bf ef~ | ef4 r bf8 af g af~af4 r4 g8 af bf ef~
	ef4 r4 g,8 af bf f'~ | f ef~ef4 g,8 af bf ef~ | ef8 bf4 bf8 bf af g af~af g af bf af g f ef~
	ef2. r4 | r1 |
	\bar "||" \break
	\sectionTitle "Bridge"
	af8 g af g af g f8 g af4 af8 bf af4 g8 g~g2 r2 r1 
	af8 g af g af4 f8 g af af4 bf8 af4 g8 g~g4. g8 g f~f4 f8 ef f g f ef ef4
	af8 g af g af4 af8 g af af4. af4 g8 g~g2 r2 r1 
	af8 g af g af4. g8 af af4. af4 g8 g~(g2~g8 f ef f~f4) r4 r8 g f ef
	c2 c4 bf8 bf~bf4 bf8 bf~bf4 g8 bf c4 c8 c~c4 bf8 bf~bf bf~bf4 r4 g8 bf
	c4 c8 c~c4 bf8 bf~bf bf~bf4 g bf c c8 c~c c c bf bf4 ef4 r2 r2 g8 af bf ef~
	\bar ":|."

}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "1."
	Who would have be -- lieved what we just heard?
	To whom has the arm of the Lord been shown?
  	He grew like a ten -- der shoot,
    like a root out of dry ground.
	He had no form or ma -- je -- sty
	To make us take spe -- cial note of him,
	No -- thing in his ap -- pea -- rance that we should de -- si -- re him.
 
	He was des -- pised and re -- ject -- ed,
	A man of sor -- rows, ac -- quaint -- ed with grief.
	peo -- ple hid their fac -- es; and we don't es -- teem him.
	_
	Sure -- ly he 
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "2."
	_ (Sure -- ly _ he) has borne our grief
	and sure -- ly he's car -- ried our suf -- fer -- ing,
	Yet we saw his suf -- fer -- ing
    and thought God had strick -- en him.
	But he was pierced for wrong we did,
	And he was bruised be -- cause of our sins;
	He en -- dured pun -- ish -- ment and
	Be -- cause of his wounds we're healed. 

	We all, like sheep, we have wan -- dered
	Each of us turned off, to his __ _ own way,
	The Lord laid on him
    the in -- i -- qui -- ty of us all.
	_ _ _ _ 
	He was op -- pressed, he was af -- flict -- ed,
	yet he did not o -- pen his mouth: 
	Brought as a lamb led to the slaught -- er, 
	or as a sheep for her shear -- ers is dumb, he id not o -- pen his mouth.
}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "3."
	Op -- pres -- sion and judg -- ment was_led  a -- way.
	And none of his gen -- er -- a -- tion com -- plained
	Cut off from the land of liv -- ing;
	for us he took our sin.

	He was as -- signed a sin -- ner's grave,
    Yet with the rich was his bo -- dy laid,
	He had done noth -- ing wrong and
    There was no de -- ceit in him.

	It was the Lord’s will to crush him and cause him suf -- f'ring
	an off -- 'ring for sin,
	%he will see his off -- spring and prolong his days,
    and the will of the Lord will pro -- sper in his hand.

	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
	He shall see the an -- guish of his soul and be sat -- is -- fied.
	By his know -- ledge My righ -- teous ser -- vant shall jus -- ti -- fy the ma -- ny,
    bear -- ing their in -- i -- qui -- ties.

	There -- fore, I'll di -- vide him a por -- tion with the great,
    and he shall di -- vide the spoi -- l with the strong,
	be -- cause he poured out his soul to death,
    and was num -- bered with the sin -- ners,
	thus he bore the sin of ma -- ny and made in -- ter -- ces -- sion for trans -- gres -- sors.

	He was op -- pres-
}
versefour = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "3."
}
versefive = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "4."
}
versesix = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
}
verseseven = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
}
verseeight = \lyricmode {
}
\score {
	<<
		\new ChordNames {
			\chordNames
		}
		\new Staff
		<<
			\new Voice = "one" {
				\melody
			}
			\addlyrics {
				\verseone
			}
			\addlyrics {
				\versetwo
			}
			\addlyrics {
				\versethree
			}
			\addlyrics {
				\versefour
			}
			\addlyrics {
				\versefive
			}
			\addlyrics {
				\versesix
			}
			\addlyrics {
				\verseseven
			}
			\addlyrics {
				\verseeight
			}
			>>
	>>
	\layout {
		#(layout-set-staff-size 20)
		\context {
			\Score
			% \override NonMusicalPaperColumn #'line-break-permission = ##f
			%\consists #(line-break-every-nth-engraver 4)
		}
	}
	\midi { }
}
