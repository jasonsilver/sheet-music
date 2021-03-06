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
  title = "Dance Divine"
  subtitle = ""
  composer = "Jason Silver"
  poet = ""
  copyright = "Silver Ink. 2020"
  tagline = ""
}
\paper {
  top-margin = #10
  bottom-margin = #4
  right-margin = #12
  left-margin = #12
  indent = #0
 	%min-systems-per-page = 10 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 2 ) (minimum-distance . .10) (padding . 1 ) (stretchability . 00))
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
  c2 d:m f1:maj7 c2 d:m f:maj7 g c d:m f:maj7 g a:m f:1.2.3.5   
  c2 d:m f1:maj7 c2 d:m f:maj7 g c d:m f:maj7 g a:m f:1.2.3.5 g1:sus4

  f2 c:/e g c:/e f c g:sus4 g 
  f2 c:/e g:/b c f1:maj7 g2:sus4 g 
  g2:sus4 g 
  f2 c:/e g c:/e f c g:sus4 g 
  f2 c:/e g:/b c f1:maj7 g2:sus4 g 
  
}
melody = \relative c'{
  \set Staff.midiInstrument = #"trumpet"
  % \set melismaBusyProperties = #'()
  \time 4/4
  \key c  \major
	\clef treble
	\tempo 4 = 98
  \override Score.MetronomeMark.padding = #3
  r4 e8 f~f4 f8 e~e2 r2 r4 e8 f~f4 f8 e~e4 e8 d~d4 r4 
  r4 e8 f~f4 f8 e~e4 e8 d~d c d e~e c4 g8~g2 
  \bar ".|:-||" \break
  \repeat volta 2 {  
  r4 e'8 f~f4 f8 e~e2 r2 r4 e8 f~f4 f8 e~e4 e8 d~d4 r4 
  r4 e8 f~f4 f8 e~e4 e8 d~d c d e~e c4 g8~g2 
  r2 r8 c'8 b  a8~
  \bar "||"  \break
  a8 g4 g8~g e4 e8 d d~d4 r8 c'8 b a8~a g4 g8~g e4 g8~g2 r8 c8 b a8~
  a8 g4 g8~g e4 e8 d d~d4 r8 c d e~e c~c g~g4 r4 |
  }
  \alternative{
    {
     r1
    }
    {
      r2 r8 c' b a~
    }
  }
  a g4 g8~g e4 e8 d d~d4 r8 c'8 b a8~a g4 g8~g e4 g8~g2 r8 c8 b a8~
  a8 g4 g8~g e4 e8 d d~d4 r8 c c d e c~c g~g4 r4 | r1 |
  
    r4 f'8 e~e d4 f8~f e4 d8~d c~c4
  r4 f8 e~e c4 f8~f e4 d8~d4 r4
  r4 f8 e~e d4 f8~f e~e d~d c c d e c4 g8~g4
}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  I close my eyes
  And see your lov -- ing smile
  Be -- fore the mem -- 'ry fades
  Or the mo -- ment dies

  My hands I fold
  Take in my breath and hold
  A fro -- zen point in time
  You em -- brace my soul

  From the per -- son who I used to be
  To the one I will be -- come
  It's your love that makes the best in me
  You're the ri -- sing Son

  When I fall you lift me up a -- gain
  Lo -- ving eyes that un -- der -- stand
  Though I'm sel -- dom who I want to be
  You lead me by the hand

  You're faith -- ful, lov -- ing, kind and
  We waltz this step through life
  I fol -- low as you lead me
  On the dance di -- vine
  
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  \set stanza = "3."
  A dance di -- vine
  A step, a turn in time
  We move in hope and love
  A for -- got -- ten rhyme

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
