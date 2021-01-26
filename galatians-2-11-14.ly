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
  title = "Galatians 2:11-14"
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
 	%min-systems-per-page = 11 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 12 ) (minimum-distance . 0) (padding . -.59 ) (stretchability . 00))
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
	\set Staff.midiInstrument = #"string ensemble 1"
  
}
melody = \relative c'{
  \set Staff.midiInstrument = #"acoustic grand"
  %           \set melismaBusyProperties = #'()
  \time 3/4
	\key d  \major
	\clef treble
	\tempo 4 = 100
  \override Score.MetronomeMark.padding = #3
  \skip2 r8 a8 | fs' g fs4 r8 d fs g fs4 r8 d fs g a4 g8 fs e4 d d8 b a2 r4 r2.
  fs'8 g fs4 r8 d fs g fs4 r8 d fs g a4 g8 fs e4 d8 d d b a2 r4 r2 r8 d
  \bar "||" \break
  b' cs d2 d8 cs8 b2 a4 a fs b a fs fs e d8 d 
  b' cs d4 d8 d d cs b4 r a a fs b a fs e2. r2 r8 a,
  \bar "||" \break
  fs' g fs4 r8 d fs g fs4 r8 d fs g a4 g8 fs e4 d d8 b b4 a2 r2 a8 a
  fs'8 g fs4 r8 d fs g fs4 r8 d fs g a4 g8 fs e4 d r a2 r4 | r2.
  \bar "||" \break
  b'8 cs d2 d8 cs8 b2 a4 a fs b a8 a fs4 e2 r8 d 
  b' cs d4 d8 d d cs b4 b8 a a4 a r b a fs e2 r4 r2 d4 a' a fs b8 b a4 fs e2 r4 r2.
  a8 a a a fs4 b a fs fs e2 r2 r8 a8
  \bar "||" \break
  fs' g fs4 r8 d fs g fs4 r8 d fs g a4 g8 fs e4 d d8 b a2 r4 r2.
}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  When Pe -- ter came to An -- ti -- och, 
  I chal -- lenged him to his face, 
  for he was wrong. 
  Pet -- er ate with the non -- Jews %people 
  un -- til some Jews %peo -- ple 
  sent from James came to An -- ti -- och. 

  When they ar -- rived, Pe -- ter stopped 
  eat -- ing with those who weren’t Jew -- ish, 
  and he sep -- ar -- a -- ted him -- self from them. 
  He was a -- fraid of the Jews. 

  So Pe -- ter was a hy -- po -- crite, 
  as were the %o -- ther 
  Jew -- ish be -- lie -- vers who joined with him. 
  E -- ven Bar -- na -- bas was in -- flu -- enced 
  by what these Jew -- ish be -- lie-v -- ers did.

  When I saw they were not foll -- 'wing the truth of the Good News, 
  I spoke to Pe -- ter in front of them, %all. 
  I said, “Pe -- ter, you are a Jew, but you are not liv -- ing like a Jew. 
  You are liv -- ing like those who aren't Jew -- ish. 

  So why do you 
  now try to force 
  those who are not Jew -- ish to live like Jews?”
  
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
		\new ChordNames  \with {midiInstrument = #"acoustic grand"} {
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