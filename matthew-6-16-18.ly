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
  title = "Matthew 6:16-18"
  subtitle = "New International Version"
  composer = "Jason Silver"
  poet = ""
  copyright = "Silver Ink. 2020"
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
  system-system-spacing = #'((basic-distance . 20 ) (minimum-distance . .10) (padding . 3 ) (stretchability . 00))
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
  ef4 ef:/g af2 f:m9 af:/bf ef4 ef:/g af2 f:m9 af:/bf
  af g:m7 f:m7 af:/bf
  ef4 ef:/g af2 f:m9 af:/bf ef4 ef:/g af2 f:m9 af:/bf

  c2:m bf g:m7 c:m7 af:maj7 g:m7 f:m7 ef c:m bf g:m7 c:m df1 af:/bf
  
  ef4 ef:/g af2 f:m9 af:/bf ef4 ef:/g af2 f:m9 af:/bf ef
}
melody = \relative c''{
  \set Staff.midiInstrument = #"piano"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key ef \major
	\clef treble
	\tempo 4 = 63 \override Score.MetronomeMark.padding = #3
  g4 ef8. c16~c4 r4 | r8 g' g g g f ef f16 g~ | g8 g16 ef~ef8 c8~c4 r4 | r2 r8 ef ef ef |
  c'8 c4 c8 bf g g f ef f g16 af8. g8 f~f4
  g ef8 ef16 d~d c8. r4 | r8 g' g g g (f) ef f | g4 ef8. c16~c4 r4 | r2 r8 ef ef ef |

  ef'4. ef8 d (c) bf af bf2 r8 ef, ef ef | ef'4. ef8 d c bf af bf2 r8 ef, ef ef
  ef'8 ef16 ef~ef8 ef d c bf af af bf4 bf8 bf af g ef ef f~f4 r4 ef8 ef ef f~f2 r4
  \bar "||" \break
  g4 ef8. d16~d c8. r4 | r8 g' g g g f ef f g4 ef8. d16~d c8.~c4 |
  \slashOn r4  r4 r4 r4 \slashOff \improvisationOn | bf'1 |
  \bar "|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  “When you fast, 
  do not look som -- ber as the hyp -- o -- crites do, 
  for they dis -- fi -- gure their fa -- es 
  to show o -- thers they are fast -- ing. 
  Tru -- ly I tell you, 
  they have re -- ceived their re -- ward in full. 
  But when you fast, 
  put oil on your head and wash your face, 
  so that it won't be seen- 
  and not be o -- bvi -- ous to o -- thers you are fast -- ing, 
  but on -- ly to your Fa -- ther, 
  who is un -- seen;
  and your Fa -- ther, 
  who sees what's done in se -- cret, 
  will re -- ward you.
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
		\new ChordNames  \with {midiInstrument = #"piano"} {
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