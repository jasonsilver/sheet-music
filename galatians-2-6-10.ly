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
  title = "Galatians 2:6-10"
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
  system-system-spacing = #'((basic-distance . 14 ) (minimum-distance . 0) (padding . 0 ) (stretchability . 00))
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
melody = \relative c''{
  \set Staff.midiInstrument = #"piano"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key d  \major
	\clef treble
	\tempo 4 = 100
  \override Score.MetronomeMark.padding = #3
  g2 g8 e fs g~g4 r2. fs4 fs8 fs~fs4 d8 e~e fs~fs4 r2 
  g4 a g r4 g4 a g e8 fs~fs2. r4 r2. r8 fs8
  g4 g g8 e fs g~g4 r2. fs4 fs8 fs~fs4 d8 e~e fs4 g8 fs4 r 
  g4 a g r4 g4 a g e8 fs~fs2. r4 r1
  \bar "||" \break
  g2 g8 e fs g~g4 r2 r8 e fs4 fs8 fs~fs d e fs~fs4 r2.
  g8 g a g~g e~e4 g8 g a g~g e~e4 e8 fs~fs2 r4 r1 
  g4 a4 g8 e e fs g4 g4 g8 fs e fs~fs2 r2 r1 
  \bar "||" \break
  b4 b b8 b4 b8 b a a a~a e e fs 
  g fs4 fs8~fs4 r8 fs g fs4 e8~e d d d  
  b'4 b  b8 b4 b8 b a a a~a e e fs g fs4 fs8~fs4 r
  g fs8 e~e d4 b8~b2 r2  r1 | r1 | r1 |
  \bar "||" \break
  

}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize

  Those lead -- ers who seemed 
  seemed to be im -- por -- tant 
  did not change the Good News I preach. 

  (It does not mat -- ter to me 
  if they are “im -- por -- tant” or not. 
  For to God e -- v'ry -- one's the same.)

  But these lea -- ders saw that 
  I'd been gi -- ven the work
  tell -- ing the Good News 
  to those who are not Jew -- ish, 
  just as Pet -- er had the work of tell -- ing the Jews. 

  God gave Pet -- er the po -- wer to work 
  as an a -- pos -- tle for 
  the Jew -- ish peo -- ple. 
  But he al -- so gave me the pow -- er to work 
  as an a -- pos -- tle for 
  those who are not Jews. 

  James, Pe -- ter, and John, 
  who seemed to be the lead -- ers, 
  un -- der -- stood that God 
  had gi -- ven me this spe -- cial grace, 
  so they ac -- cept -- ed Bar -- na -- bas and me. 

  They agreed that they would 
  go to the Jewish people 
  and that we should 
  go to those who're not Jewish. 

  The only thing they asked us 
  was to remember to help the poor—
  something I really wanted to do.

}
versetwo = \lyricmode {
_ _ _ _ _ _ _ _ _ _ _ _ _ _
	\override LyricText #'font-size = \LyricFontSize
  _ _ \set stanza = "2."
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