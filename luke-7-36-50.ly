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
	%min-systems-per-page = 12 % this allows you to squish line spacing

	% the distance between two systems in the same score:
	system-system-spacing = #'((basic-distance . 17 ) (minimum-distance . 0) (padding . -.1 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -2) (stretchability . 0))
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
	\skip1 c2 c:1.2.3.5 c c:1.2.3.5 f:maj7 f:6 f:maj7 f:6
	c c:1.2.3.5 c c:1.2.3.5 f:maj7 f:6 f:maj7 f:6
	a1:m7 e:m7 a:m7 e:m7 d:m7 f:6
	% 2nd ending
	e:m7 d:m7 f d:m7 f2 e:m7 d1:m7 f d:m7 f f:/g g:7

	c1 e:m7 d:m f c e:m7 d:m7 f2:/g g:7
}
melody = \relative c'{

	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key c  \major
	\clef treble
	\tempo 4 = 98
	\override Score.MetronomeMark.padding = #3

}
verseone = \lyricmode {
	Now one of the Pha -- ri -- sees asked Je -- sus to have
	din -- ner with him, so he went in -- to the Pha -- ri -- see’s
	house and took his place at the ta -- ble. Then when a wo -- man
	of that town, who was a sin -- ner, learned that Je -- sus 
	was di -- ning at the Pha -- ri -- see’s house, she brought an
	a -- la -- ba -- ster jar of per -- fumed oil. As she stood 
	be -- hind him at his feet, weep -- ing, she be -- gan to wet
	his feet with her tears. She wiped them with her hair, kissed
	them, and a -- nointed them with the per -- fumed oil. 
	Now when the Pha -- ri-- see who had invited him saw this, he said to himself, “If this man were a prophet, he would know who and what kind of woman this is who is touching him, that she is a sinner.” So Jesus answered him, “Simon, I have something to say to you.” He replied, “Say it, Teacher.” “A certain creditor had two debtors; one owed him 500 silver coins, and the other fifty. When they could not pay, he canceled the debts of both. Now which of them will love him more?” Simon answered, “I suppose the one who had the bigger debt canceled.” Jesus said to him, “You have judged rightly.” Then, turning toward the woman, he said to Simon, “Do you see this woman? I entered your house. You gave me no water for my feet, but she has wet my feet with her tears and wiped them with her hair. You gave me no kiss of greeting, but from the time I entered she has not stopped kissing my feet. You did not anoint my head with oil, but she has anointed my feet with perfumed oil. Therefore I tell you, her sins, which were many, are forgiven, thus she loved much; but the one who is forgiven little loves little.” Then Jesus said to her, “Your sins are forgiven.” But those who were at the table with him began to say among themselves, “Who is this, who even forgives sins?” He said to the woman, “Your faith has saved you; go in peace.”

}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
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
