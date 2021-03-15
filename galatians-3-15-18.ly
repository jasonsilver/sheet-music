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
	title = "Galatians 3:15-18"
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
		min-systems-per-page = 12 % this allows you to squish line spacing

	% the distance between two systems in the same score:
	system-system-spacing = #'((basic-distance . 2 ) (minimum-distance . 0) (padding . -.59 ) (stretchability . 00))
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
	af1 af bf:m7 bf2:m7  df2:maj7
	af1 af bf:m7 bf2:m7 af:/c df1:maj7 ef2:sus4 ef bf1:m7 ef2:sus4 ef
	af1 af bf:m7 bf2:m7  df2:maj7
	af1 af bf:m7 bf2:m7 af:/c df1:maj7 ef2:sus4 ef bf1:m7 ef2:sus4 ef
	df1:maj7 df:maj7
	gf gf f:m7 f:m7 ef:m7 ef:m7 df ef:sus4 df:/f ef:sus4 ef

	af1 af bf:m7 df:maj7 af af bf:m7 df2:maj af:/c bf1:m7 ef:sus4 bf:m7 ef
	
}
melody = \relative c'{

	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key af  \major
	\clef treble
	\tempo 4 = 98
	\override Score.MetronomeMark.padding = #3
	c8 df ef g~g af~af4 c,8 df ef c g'4 af8 df,~df2 r2 r1
	c8 df ef c g'4 af c,8 df8 ef c ef g af df,~df2 r2 r2
	ef8 df c af | c4 df4 df4 c4 c8 bf af bf~bf4 c4
	df8 ef df4 df c8 af c bf bf af af bf~bf4
	\bar "||"
	c8 df ef g~g af~af c,~c4 r8 ef g4 af8 af~af df,~df4 r2 r1
	c8 df ef c g'4 af r4. ef8 g4 af8 af~af df,~df4 r2 r2
	ef8 df c (af) c4 df4 df4 c4 c8 (bf) af bf~(bf c~c4)
	df8 ef df4 df c c8 bf8 af af bf4 r4 r4. c8 c df ef af~af2 r2 
	\bar "||"

        bf8 af bf c bf4 r4 bf8 af bf c bf af ef ef f f~f4 r8 ef ef c ef f~f4 r4. af8
        bf8 af bf c bf af ef bf'~bf af bf (c) bf af af ef f2 f4 af8 af~af bf~bf4 
        af8 g ef f~f4. f8 f g af af~af bf bf2. r1
        \bar "||"
	af4. g8 ef4. c8 af'4 g ef8 c ef4 ef8 f8~f2 r4 r1
	af4. g8 ef4. c8 af'4 g ef ef8 c ef f~f2 r4 r4.
	ef8 ef df c4 c df8 df~df2 r4.
	ef8 ef df c af c4 df8 df~df c~c bf~bf4 r4
	c4 af8 f~f4 r4 df'	4 c bf af g af af2. r4 r1
	\bar "|."

}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize

	Bro -- thers and sis -- ters, let us think in hu -- man terms:
	E -- ven an a -- gree -- ment made be -- tween two per -- sons is firm.
	Af -- ter that a -- gree -- ment is ac -- cep -- ted by both, no --
	bo -- dy can stop it or add a -- ny -- thing to it.

	God pro -- mised A -- bra -- ham and his des -- cen -- dant. 
  	God did not say, “and to, to your des -- cen -- dants.”
	That would mean ma -- ny peo -- ple. But God said, 
	on -- ly one per -- son: “to your de -- scen -- dant.” 
	That per -- son is Christ.

	This is what I mean: God had an a -- gree -- ment with A -- bra -- ham;
	pro -- mised to keep it. 
	The law, which came four hun -- dred and thir -- ty years la -- ter,
	can -- not change that a -- gree -- ment and so
	des -- troy God’s pro -- mise to A -- bra -- ham.


	If the law could give us A -- bra -- ham’s bles -- sing,
	then the pro -- mise would not be ne -- ces -- sa -- ry.
	But that is not pos -- si -- ble,
	be -- cause God free -- ly gave his bles -- sings to
	A -- bra -- ham through the pro -- mise he had made.
  
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "3."

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
