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
	title = "Galatians 3:23-29"
	subtitle = "New Century Version"
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
	system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . -.8 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -6) (stretchability . 0))
	% the distance between the last system of a score and the (title or top-level) markup that follows it:
	score-markup-spacing = #'((basic-distance . 0) (padding . -5) (stretchability . 0))
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

}
melody = \relative c'{

	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key c  \major
	\clef treble
	\tempo 4 = 98
	\override Score.MetronomeMark.padding = #3
	r2 r8 c c d 
	\repeat volta 2{
		e e e d d4 c8 d e e e d d4 e8 c a2 r2 r2 r8 
		c c d e e e d d4 c8 d e e e d d d e c a2 r2 

		r2. e'8 g a4 a8 g a4 b8 g~g2 r4 e8 g a4 a8 g a4 b8 g~
	}
	\alternative{
		{ g4 r4 g4 c,8 d~d2 e4. a,8~a2 r4 c8 d}
		{ g4\repeatTie r4 g4 c,8 d~d2 e4 c8 a8~ }
	}
	a2 g'4 c,8 d~d2 e4 c8 a 
}
=verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	Be -- fore the com -- ing of this faith, 
	we were held in cus -- to -- dy 
	un -- der law, 
	locked up un -- til the faith that was-
	'til the faith that was to come 
	would be re -- vealed. 
	So the law was our guard -- i -- an un -- til Christ came that we might be jus -- ti -- fied by faith. 
	Now that
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	_ _ _
	 this __ _ faith has come, we're no long -- er un -- der a guard -- i -- an.

	_ So in Christ __ _ Je -- sus you are all child -- ren __ _ of God __ _ through your faith, 

	for all you __ _ who were bap -- tized in -- to Christ clothed your -- selves with Christ. 

	_ _ _ _ _ _ _ _ There is no long -- er Jew nor Gen -- tile, nei -- ther slave nor free, nor is there male and fe -- male, 
	for you are all one in Christ Je -- sus. 

	If you be -- long to Christ, then you are A -- bra -- ham’s seed, and heirs acc -- ord -- ing to 
	the pro -- mise.
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
