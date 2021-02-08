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
  title = "Hebrews 4:8-13"
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
 	min-systems-per-page = 10 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 12 ) (minimum-distance . .10) (padding . 1 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . -5) (stretchability . 0))
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
  <c g d'>1-\markup {"5" \super "add9" } % 1.5.9
}
chExceptions = #(append (sequential-music-to-chord-exceptions chExceptionMusic #t) ignatzekExceptions)
chordNames = \chordmode {
	\set chordNameExceptions = #chExceptions
	\set chordChanges = ##t % ##t(true) or ##f(false)
	\set Staff.midiInstrument = #"string ensemble 1"
  c1:/e f:1.5.9 c2:/e e:m f:1.3.5.9 f:maj7
  c1:/e f:1.5.9 c2:/e e:m f:1.3.5.9 f:maj7
  c1:/e f:1.5.9 c2:/e e:m f:1.3.5.9 f:maj7
  c1:/e f:1.5.9 a2:m7 g f1:maj7

  d1:m7 g:sus4 f:/a e2:m7 g 
  d1:m7 g:sus4 f:/a g2:sus4 g

  c1 c d2:m f:maj7 g:sus4 g
  c1 c:/e f2 f:/a g:sus4 g
  f2 a:m g c:/e f a:m g g:sus4 c1 c

  c1:/e f:1.5.9 c2:/e e:m f:1.3.5.9 f:maj7
  c1:/e f:1.5.9 c2:/e e:m f:1.3.5.9 f:maj7


}
melody = \relative c'{
  % \set melismaBusyProperties = #'()
  \time 4/4
	\key c  \major
	\clef treble
	\tempo 4 = 90
  \override Score.MetronomeMark.padding = #3
  r4 g'8 f f e e4 r4. c8 d e f e~e2 r2 r2 r8 e d c~
  c g' g f f e e4 r4. c8 d e e f e2 r2 r2 r8 e d c~
  c g' f f e e~e4 r c8 c d e f e~e2 r2 r2 r8 e d c~
  c g' g f f e e4 r8 c c c d e f e~e4 c8 c d e (f) e~e2 r2
  \bar "||"
  a,4. f'8~f4 e d4. c8~c4 b a4. f'8~f4 e4 e8 d c d~d4 r
  a4. f'8~f4 e d4. e8 d c c b a4. f'8 f e e f e d d4 r4
  
  c8 c \bar ".|:-||"
  d e e c d e g d e4. g8 d e e4 f8 f f f f e4 d8~d2 r2 
  d8 e e c d e e g d e e c d e~e4 r4 f8 g f4 e8 d e d~d4 r
  c8  b  a4. e'8~e4  c8 b~b4 r2 c8  b  a4.  e'8~e4 c8 b~b2    c4  b8  c~c2 r2 r1
  \bar "||"
  r4 g'8 f f e e4 r2 d8 e f e~e2 r2 r2 r8 e d c~
  c g' g f f e e4 r8 c c c d e f e~e2 r2 r2. c8 c
  \bar ":|."
 
}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  For if Jo -- shu -- a had gi -- ven them rest,  God would not 
  have spo -- ken af -- ter -- ward  a -- bout a -- no -- ther day. And so a
  Sab -- bath rest re -- mains for the peo -- ple of God. For the one
  who en -- ters God’s own rest has al -- so rest -- ed from works, 
  just as God did too. 
  
  Thus we must make ev -- 'ry ef -- fort to
   en -- ter that rest, 
  so none may fall by fol -- low -- ing the 
   same pat -- tern of dis -- o -- be -- di -- ence. 

  \set stanza = "Chorus"

  For the word of God is liv -- ing and a -- ctive 
  and shar -- per than 
  a -- ny dou -- ble -- edg -- ed sword, 
  pierc -- ing e -- ven to the point: di -- vid -- ing soul from spir -- it,      and the joints from the mar -- row; 
  it is  a -- ble to judge
  the de -- sires and the thoughts 
  of the heart. 

  \set stanza = "2."
  And no crea -- ture is hid -- den from God, 
  but all is na -- ked, ex -- posed to him 
  to whom we must give ac -- count.

  For the
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
		\new ChordNames  {
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
