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
  title = "John 1:24-28"
  subtitle = "King James Version"
  poet = ""
  composer = "Jason Silver"
  arranger = ""
  copyright = "Silver Ink. 2020"
  tagline = "Permission granted to share with attribution."
}
\paper {
  top-margin = #10
  bottom-margin = #4
  right-margin = #12
  left-margin = #12
  indent = #0
  min-systems-per-page = 9 % this allows you t o squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 14 ) (minimum-distance . 0) (padding . 1 ) (stretchability . 0))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between the last system of a score and the (title or top-level) markup that follows it:
  score-markup-spacing = #'((basic-distance . 0) (padding . 0) (stretchability . 0))
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
  \set Staff.midiInstrument = #"string ensemble 1"
  f2 f8 a4:m bf8~bf2 d:m7 c1:sus4 c 
  f2 f8 f:/a f:/a bf~bf2 d:m7 c1:sus4 c:sus4 
  f2 f8 f4:/a bf8~bf2 d:m7 c1:sus4 c 
  bf1:maj7 g2:m d:m7 c1:sus4 c 
  bf1 g2:m f:/a bf1 g:m7 ef1:maj7 d:m9 c:m7 c:/e

  %chorus
  f1 bf2 d:m c1:sus4 c2 c:/e f1 bf d2:m f c:sus4 c

  f2 f8 f:/a f:/a bf~bf2 d:m7 c1:sus4 c:sus4 
  f2 f8 f4:/a bf8~bf2 d:m7 c1:sus4 c 

}
melody = \relative c''{
  %           \set melismaBusyProperties = #'()
  \time 4/4
  \key f  \major
  \clef treble
  \tempo 4 = 90
  \override Score.MetronomeMark.padding = #3

  %\set melismaBusyProperties = #'()
  %\unset melismaBusyProperties
	a4 a a c8 d~d a a a c4 a8 g~g2 r2 r1
	a4 a8 a~a c4 d8~d a4 c8~c a4 g8~g4 r4 g f8 g~g g4 f8 g4 r4
	a4 a8 a~a c4 d8~d a4 a8 c a4 g8~g4 r4 g8 f8 g4 g a r2
  \tiny a4 a a c8 d~d a a a c4 a8 g~g2 r2 r1 \normalsize
  \bar "||" \break
	bf4. a8~a f4 g8~g4 r4 g8 a~a4 bf4. a8~a g4 f8 f4 g4 r2
	bf4 bf a8 g f f~f g4 f8~f g4. bf4. a8~a f4 g8~g2 r2 
  \bar "||" \break
  \bar ".|:" f'4 e8 c~c4 r8 a f'8 e4 c8~c4 a8 c~c2 r2 r1 \break
  f4 e8 c~c4 a8 f'8~f e8 r4 a,4 bf c8 c c c c bf a g~g2 r2 \bar ":|."
  \break
  a4 r8 a~a c~c d~d a a4 c8 a~a g~g2 g8 f~f g~g a~a4 r2 
  a4 a8 a~a4 r4 d4. d8~d a~a a~a g~g4 r4 f8 g~g4 r2.
}
nothing = \lyricmode {}
verseone = \lyricmode {
    \override LyricText #'font-size = \LyricFontSize
    \set stanza = "1."
	
	And they which were sent were of the Pha -- ri -- sees.
	And they asked him, and said un -- to him, Why ba -- pti -- zest thou then,
	if thou be not that Christ, nor E -- li -- jah, nei -- ther that pro -- phet?
  _ _ _ _ _ _ _ _ _ _ _
	John an -- swered them,   say -- ing, I  bap -- tize with wa -- ter:  
	but there stan -- deth a -- mong you, one who you do not know;

  He it is, who com -- ing af -- ter me 
  is pre -- ferred be -- fore me, whose shoe bu -- ckle
 I'm un -- wor -- thy to loose.

	These things were done in Beth -- a -- ba -- ra be -- yond Jor -- dan, 
  This is where John was bap -- ti -- zing, and said,
}
versetwo = \lyricmode {
    \override LyricText #'font-size = \LyricFontSize
    \set stanza = "2."
}
versethree = \lyricmode {
    \override LyricText #'font-size = \LyricFontSize
    \set stanza = "3."

}
versefour = \lyricmode {
    \override LyricText #'font-size = \LyricFontSize
}
versefive = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
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
		\new ChordNames  \with {} {
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
