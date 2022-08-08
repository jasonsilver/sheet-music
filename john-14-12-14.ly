\language "english"
%\version "2.18"
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
  title = "John 14:12-14"
  subtitle = "New King James Version"
  composer = "Jason Silver"
  poet = ""
  copyright = "Silver Ink. 2022"
  tagline = "Permission granted to share with attribution."
}
\paper {
  top-margin = #10
  bottom-margin = #4
  right-margin = #12
  left-margin = #12
  indent = #0
 %min-systems-per-page = 9 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . 5 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . 1) (stretchability . 0))
  % the distance between the last system of a score and the (title or top-level) markup that follows it:
  score-markup-spacing = #'((basic-distance . 0) (padding . 1) (stretchability . 0))
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
voltaTie = #(define-music-function (parser location further) (number?) #{
     \once \override LaissezVibrerTie  #'X-extent = #'(0 . 0)
     \once \override LaissezVibrerTie  #'details #'note-head-gap = #(/
further -2)
     \once \override LaissezVibrerTie  #'extra-offset = #(cons (/
further 2) 0)
#})

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
	%\set Staff.midiInstrument = #"string ensemble 1"
  \skip1 a1 cs4.:m d8~d2 b1:m  e
  a cs4.:m d8~d2 b1:m e
  e d b:m a e
  e
  a b:m d e a b:m d e
  a b:m d e a b:m d e
  

}
  melody = \relative c'{
  \time 4/4
  \key a  \major
  \clef treble
  \tempo 4 = 100 \override Score.MetronomeMark.padding = #3
  %\set melismaBusyProperties = #'()
  %\unset melismaBusyProperties
  skip2. cs8 e 
  \repeat volta 3{
  \bar ".|:" fs fs \tiny cs \normalsize e8~e4 r8 a gs4 cs,8 fs~fs4 r4 | fs8 fs4 fs8 e4 cs8 b~b2 r4 \tiny cs8 \normalsize e8 |
  fs8 fs cs e~e4 e8 a gs4 cs,8 fs~fs4  r8 e fs fs fs e8~e cs4 b8~
  }
  \alternative{
    { b2 r4 cs8 e  }
    { b2  r4. cs8 d4 a'8 gs~gs4 r8 d8~d d4 cs8 d (cs) cs4 r1 r2. cs8 e   }
    { r1  }
  }
  \break
  cs'4 cs cs r d8 cs d cs~cs a4 fs8~fs2 fs4 e e8 (b') b4 r2 
  cs4 cs cs r d8 cs d cs~cs a4 fs8~fs2 fs4 e cs8 (b) b4 r2 
  cs'4 cs cs r d8 cs d cs~cs a4 fs8~fs2 fs4 e e8 (b') b4 r2 
  cs4 cs cs r d8 cs d cs~cs a4 fs8~fs2 fs4 e cs8 (b) b4 r2 
  \improvisationOn a'1 \improvisationOff
  \bar "|."
  %\pageBreak


}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1.,2."
  “Most as -- sur -- ed _ -- ly, I say to you, he who be -- lieves in Me, 
  _ the works that I do he will al -- so do; and grea -- ter __ _ works than these, %he will do, 
  Most as-
  (these,) 
  be -- cause I go- go to My Fa -- ther.
  And what- 
 
}
versetwo = \lyricmode {
    \override LyricText #'font-size = \LyricFontSize
    _ _
    \set stanza = "3."
     -ev -- er you ask, ask in My name, and that __ _  I  will do, that the Fa -- ther may be 
     _ be glo -- ri -- fied _ glo -- ri -- fied in the Son.
     _ _ _ _ _ _ _ _ _ _ _ _ _ _  
    If you ask a -- ny -- thing in My name, I will do it.
    If you ask a -- ny -- thing in My name, I will do it.
    If you ask a -- ny -- thing in My name, I will do it.
    If you ask a -- ny -- thing in My name, I will do it.

}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize


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


