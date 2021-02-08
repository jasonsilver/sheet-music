\language "english"
\version "2.18.3"
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
  title = "Galatians 1:11-16"
  subtitle = "New Century Version"
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
  system-system-spacing = #'((basic-distance . 16 ) (minimum-distance . .10) (padding . 1 ) (stretchability . 00))
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
  g1 b2:m7 e:m7 f1:maj7 g1 b2:m7 e:m7 f:maj7 d:7sus4 
  d2:/c g:/b a:m7 a:m9/f d2:/c g:/b a1:m7 d2 g:/b e1:m7 f:1.2.3.5 
  f:1.2.3.5
  a1:m g2:/b d a1:m g2:/b d c1 a:m9
  % chorus
  g2 b:m7 a:m7 f:maj9 g b:m a:m c:/d g d:/fs e:m g:/d c:6 d:11
  g2 b:m7 a:m7 f:maj9 g b:m a:m c:/d g d:/fs e:m c:m6/ef g:/d b:/ds e:m g:/d
  a1:7/cs c:/d g1
}
melody = \relative c'{
  \set Staff.midiInstrument = #"piano"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key g  \major
	\clef treble
	\tempo 4 = 85
  \override Score.MetronomeMark.padding = #3
  \repeat volta 2 {  
	b8. c16~c8 d fs4 g4 r4. b,8 b c d e~e4 r r d8 c 
  b8. c16~c8 d fs8 g16 g~g4 r4 d8 c b8 c d e~e d4 c8~c d4.  \bar "||"
  fs8 fs fs g~g fs d d~d e~e4 r4 d8 e fs fs fs g~g fs d e~e2 r4. d8
  fs4 d g r4 r2 d8 c b a~
  }
  \alternative{
    { a2 r4. b8 }
    { a2 r2 }
  }
  \bar "||"
  a'8. a16~a8 a~a16 b8.~b8 g b8 a g fs~fs4 r8 g
  a8.  a16~a8 a8 a8. b16~b4 | b8. (a16~a8) g8 fs4 g8 d d e e4 r2 | r2. r8 a
  % chorus
  \bar "||"
  b4 r d, r e8 g~g a~a4 g8 b~b4 r8  d,8~d4 r e8 g g a~a g a b~b4 d8 b~b4 a8 g~g4. a8~a b4 a8~a2 r4. a8
  b4 r d, r e8 g~g a~a4 g8 b~b4 r8  d,8~d4 r e8 g4 a8~a g a b~b4 d8 b~b4 a8 a~a g~g4 r4 a8 b~
  b4. b8~b4 a8 a~a g8~g4 b8 (c) b4 b8 (a) a2 r4 r1 | 
  \improvisationOn g1 \improvisationOff 
  \bar "|."
}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
	Bro -- thers and sis -- ters, 
	I want you to know 
	that the Good News I preached to you 
	was not made up by hu -- man be -- ings. 
	I did not get it from peo -- ple, 
	nor did a -- ny -- one teach it to me,
	but Je -- sus Christ showed it to me.
	
	You've 
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "2."
  heard of my past life 
	in the Jew -- ish faith. 
	_ I at -- tacked the church of God 
	and I tried to des -- troy __ _ it. __ _ 
	I was be -- com -- ing a lead -- er 
  in the Jew -- ish re -- li -- gion, I did 
	bet -- ter than most o -- thers my age. 
  _ _ 
	I tried hard -- er than a -- ny -- one else 
	to fol -- low the teach -- ings 
	hand -- ed down by our an -- ces -- tors.
	
	But God had spe -- cial plans for me 
	and set me a -- part for his work 
	e -- ven be -- fore I was born. 
	He called me through his grace 
	and showed his son to me 
	so that I might tell the Good News 
	a -- bout him to those who are not Jew -- ish. 
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
