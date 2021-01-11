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
  title = "Galatians 2:1-5"
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
 	min-systems-per-page = 11 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . 0 ) (stretchability . 00))
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
  d1 a:/cs b:m a g a2:sus4 a  d1 a:/cs b:m a g a g:/b a:/cs
  d fs:m g:maj9 e2:m a:sus4
  d1 a:/cs b:m a g a2:sus4 a  d1 a:/cs b:m a g a g:/b a:/cs
  d1 fs:m7 g g:/a d fs:m7 g:maj7 g:maj7
  d fs:m7 g g:/a d a2:sus4 a g1:/d d

}
melody = \relative c'{
  \set Staff.midiInstrument = #"piano"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key d  \major
	\clef treble
	\tempo 4 = 100
  \override Score.MetronomeMark.padding = #3
  
  r4 fs8 fs fs fs4 e8~e e e e e fs e d~d d d4 d8 d d cs~cs d cs4 r2
  r8 b b b b cs b b~b a~a4 r2 
  r8 fs' fs fs fs fs4 e8~e e4 e8 e e4 d8~d d d d d e d cs~cs4 cs8 cs cs d cs b~b4 
  r8 b b cs b b~b a~a4 r2 r4 b8 b b cs d d~d e~e4 r2
  \bar "||"
  a4 fs d a a' fs d d8 e a4 fs d8 a~a a'~a g fs d~d e~e4 \fermata
  \bar "||"
  r4 fs8 fs fs fs4 e8~e e e e e e4 d8~d4 d8 d d4 d8 d cs cs d cs~cs4 r4
  r8 b b b b b4 b8~b a~a4 r2
  r8 fs' fs fs fs fs4 e8~e e4 e8 e fs e d~d4 d8 d d4 r8 d cs cs d cs~cs4 r
  r4. b8 b b b b~b a~a4 r2 r8 b b b~b cs d d~d e~e4 r4 a8 d~
  \bar "||"
  d4. a8~a4 a8 e'~e4. a,8~a4. d8~d2 r2 r2 r8 a8 a d~| 
  d4. a8~a4 a8 e'~e4. a,8~a4 a8 fs'~fs4 g8 fs~fs d~d4 fs4 g8 fs~fs d r a
  d4. a8~a4 a8 e'~e4. a,8~a a a d8~d2 r2 r2 r8 a a d~| d4. a8~a2 
  g4(fs8 e~e4.) d8~d2. r4 | r1 \bar "|." 
  

}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  Af -- ter four -- teen years 
  I went to Je -- ru -- sa -- lem 
  a -- gain, this time with Bar -- na -- bas. 
  I al -- so took Ti -- tus with me. 

  I went be -- cause God showed 
  me that I should go.
  I met with be -- lie -- vers there, 
  and in pri -- vate I told 
  their lea -- ders the Good News 
  that I preach to the non -- Jews. 

  I did not want my past work 
  and the work I'm now do -- ing to be wast -- ed.
  
  Ti -- tus was with me, 
  but was not forced to be 
  cir -- cum -- cised, ev -- en though he was Greek. 
  We talked a -- bout this pro -- blem 
  be -- cause some false be -- lie -- vers 
  had come to our group 
  se -- cret -- ly. They came in like spies 
  to o -- ver -- turn free -- dom 
  that we have in Christ Je -- sus. 

  They want -- ed to make us slaves. 
  But we did not give in to 
  those false be -- liev -- ers for a min -- ute. 

  We want -- ed the truth of the Good News 
  to con -- ti -- nue 
  for you.
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