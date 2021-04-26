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
	title = "Luke 7:36-50"
	subtitle = "New English Translation"
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
	%min-systems-per-page = 10 % this allows you to squish line spacing

	% the distance between two systems in the same score:
	system-system-spacing = #'((basic-distance . 12 ) (minimum-distance . 0) (padding . -.1 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . -5) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -2.2) (stretchability . 0))
	% the distance between the last system of a score and the (title or top-level) markup that follows it:
	score-markup-spacing = #'((basic-distance . 0) (padding . -10) (stretchability . 0))
	% the distance between two (title or top-level) markups:
	markup-markup-spacing = #'((basic-distance . 0) (padding . 0))
	% the distance from the top of the printable area (i.e. the bottom of the top margin) to the first system on a page, when there is no (title or top-level) markup between the two:
	top-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
	% the distance from the top of the printable area (i.e. the bottom of the top margin) to the first (title or top-level) markup on a page, when there is no system between the two:
	top-markup-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
	% the distance from the last system or top-level markup on a page to the bottom of the printable area (i.e. the top of the bottom margin):
	last-bottom-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . -20) (stretchability . 0))

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
LyricFontSize = #.4
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
	\skip1 
	f4. c4:/e f4. | g:m bf4 bf4.:6 | f4. c4:/e f4. | ef4.:maj7 d8:m7~d2:m7 | 
	f4. c4:/e f4. | g:m bf4 bf4.:6 | f4. c4:/e f4. | ef4.:maj7 d8:m7~d2:m7 | 
	f4. c4:/e f4. | g:m bf4 bf4.:6 | f4. c4:/e f4. | ef4.:maj7 d8:m7~d2:m7 | 
	f4. c4:/e f4. | g:m bf4 bf4.:6 | f4. c4:/e f4. | ef4.:maj7 d8:m7~d2:m7 | 
	ef1:maj7 g:m7 d:m7 a:m7 ef:maj7 g:m c:sus4 c
	ef1:maj7 g:m7 d:m7 a:m7 ef:maj7 g:m c:sus4 c2 f:/a  bf1 c:sus24 c 
}
melody = \relative c'{
	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key f  \major
	\clef treble
	\tempo 4 = 98
	\override Score.MetronomeMark.padding = #3
	r2. r8 c \bar "||" c f f g f f4 g8 bf a g f f d c c~c4 r2. r2. r8 c 
	c f f g g f f g bf a g g f4 r r1 r2. 
	c8 c c f f g g f f g bf a g f f d c c~c4 r2. r2. c8 c
	c f f g g f f g bf a g f g f~f4 g8 f~f4 r2 r2. r8 a
	
	bf8 a bf a bf a g a bf a bf a bf c4 a8~a2 r2 r2. r8 a
	bf8 a bf a bf a g4 r4 bf8 a g f4 g8~g2 r2 \bar ":|." r2. r8 a

	bf8 a bf a bf a g a bf a bf a bf c4 a8~a2 r2 | r1
	bf8 a bf a bf a g a | bf a bf a bf a4 g8~g2 r2 | r4 a8 a g4 f d4. d8 f4 d | d c~c2 | r1 \bar "||"
	\time 2/2
	r4 a'4 a8 bf a g~g4 r8 g g a g g f2 f4 d d8 d f f f4 d c8 a' a a~a2 | r4. c,8 c4 c c8 a' a a~a2 r1
	r4 a a8 bf a g~g4. g8 a g~g g g4 f8 f~f4. f8 f d4 d8 f4 d c8 a' a a~a2 r1 | r1 | r1 |
	r4 a' a8 bf a g~g4. g8 a4 g g8 f~f  

}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize

	Now one of the Pha -- ri -- sees asked Je -- sus to have din -- ner with him,
	so he went in his house and took his place at the ta -- ble.
	Then a wo -- man of that town, who was a sin -- ner, learned that Je -- sus was there
	Brought an a -- la -- ba -- ster jar of per -- fumed oil, and stood be -- hind him weep -- ing. 
	
	_ She be -- gan to wet his feet with tears then wiped them with her hair,
	_ Kissed them, and a -- noint -- ed them 
	With the per -- fumed oil. 
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	Now when the Pha -- ri-- see who'd in -- vit -- ed Je -- sus saw this, he thought:
	“If this man were a pro -- phet, he'd know that she's a sin -- ner.” 
	_ So Je -- sus an -- swered him, and said, _ “Si -- mon, I have some -- thing to say.” 
	_ So Si -- mon an -- swered Je -- sus, __ _ _ “Go a -- head and say it, Teach -- er.” 

	“A bank -- er had two debt -- ors, and one owed five hun -- dred sil -- ver coins,
	The oth -- er owed him fif -- ty, and they both could not pay.

	He can -- celed both their debts, so tell me, which of them will love him more?” 
	Si -- mon an -- swered, 
	“I sup -- pose the one who had the big -- ger debt.” 
	Je -- sus said to him, “You have judged right -- ly.” 

	“I en -- tered your house. You gave me no wa -- ter for my feet, but she has wet 
		my feet with her tears and wiped my feet with her hair.
	You gave me no kiss of greet -- ing, but from the time I en -- tered she's not 
		stopped kis -- sing my feet. 
	You did not a -- noint my head with oil, but she has a -- nointed my feet with 
		per -- fumed oil. 

	There -- fore I tell you, her sins, which were ma -- ny, are for -- given, 
		thus she loved much; 
	but the one who is for -- gi -- ven lit -- tle loves lit -- tle.” 
	
	Then Je -- sus said to her, “Your sins are for -- gi -- ven.” 
	
	But those who were at the ta -- ble with him be -- gan to say a -- mong 
	them -- selves, “Who is this, who even for -- gives sins?”

	He said to the wo -- man, “Your faith has saved you; go in peace.”
}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "3."
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
