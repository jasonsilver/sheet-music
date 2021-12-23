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
  title = "Galatians 4:1-5"
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
 %min-systems-per-page = 8 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . -.5 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between the last system of a score and the (title or top-level) markup that follows it:
  score-markup-spacing = #'((basic-distance . 5) (padding . 0) (stretchability . 0))
  % the distance between two (title or top-level) markups:
  markup-markup-spacing = #'((basic-distance . 0) (padding . 0))
  % the distance from the top of the printable area (i.e. the bottom of the top margin) to the first system on a page, when there is no (title or top-level) markup between the two:
  top-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
  % the distance from the top of the printable area (i.e. the bottom of the top margin) to the first (title or top-level) markup on a page, when there is no system between the two:
  top-markup-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0))
  % the distance from the last system or top-level markup on a page to the bottom of the printable area (i.e. the top of the bottom margin):
  last-bottom-spacing = #'((basic-distance . 10 ) (minimum-distance . 0) (padding . 0) (stretchability . 0))

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
	\set Staff.midiInstrument = #"piano"
  \skip1 cs1:m e a gs:m cs:m e fs:m7 gs:m cs1:m e a gs:m cs:m e fs:m7 gs:m7 a:1.3.5.9 e fs:m7 d:1.2.3.5
  a:1.3.5.9 e fs:m b2:/ds r2  
  e4. a8~a2 cs4.:m b8~b2 e4. a8~a2 cs4.:m b8~b2 e4. a8~a2 cs4.:m b8~b2 e4. a8~a2 cs4.:m b8~b2
}
melody = \relative c'{
	\set Staff.midiInstrument = #"piano"
	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key e  \major
	\clef treble
	\tempo 4 = 110
	%\set melismaBusyProperties = #'()
	%\unset melismaBusyProperties
  r8 e e e e8. ds16~ds8 cs8~ \bar "||" cs2 r2 | r8 e e e e8. ds16~ds8 cs8 cs cs cs cs cs8. b16~b8 gs8~gs8 
  e' e e e8. ds16~ds8 cs8~cs2 r2 | r8 e e e e fs gs a~a2 r2 
  r8 e e e e8. ds16~ds8 cs8~ \bar "||" cs2 r2 | r8 e e e e8. ds16~ds8 cs8~cs cs cs cs cs cs b8 gs8~gs8 
  e' e e e8. ds16~ds8 cs8~cs2 r2 | r8 e e e e fs gs a~a a a4 a8. gs16~gs8 fs8~fs2 r8 e e e \bar "||"
  b'8 b b b b4 r4 b8 a gs fs~fs gs gs b, cs2 r8 e e cs e fs fs4 r4 e8 e
  b'8. b16~b8 b8~b4 e, b'8 a gs fs~fs gs4 a8~a2 a4 b b2 


  r8 cs, e fs \bar "||" gs8. b,16~b8 cs8~cs4 r4 | gs'8 a gs fs~fs4 e8 fs | gs8 a gs fs e e fs gs~gs a gs fs r4 e8 fs
  gs8. b,16~b8 cs8~cs4 e8 fs | gs8 a gs fs~fs4 e8 fs | gs8 a gs fs(e) e e fs gs a gs a gs fs8~fs4
	\bar "|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
    I want to tell you this:
    While those who will in -- her -- it their fa -- thers’ pro -- per -- ty 
    while they are chil -- dren still,
    they are no diff -- 'rent from slaves.
    It does not mat -- ter if
    It does not mat -- ter if the chil -- dren own ev -- ery -- thing.
    While they are chil -- dren, they, 
    they must o -- bey those are cho -- sen to care for them.

    But when the chil -- dren reach the age set by their fa -- thers, they are free.
    It is the same for us.
    We were once like chil -- dren, slaves to the use -- less rules of this world.

    But when the right time came,
    God sent his Son
    who was born of a wo -- man and lived un -- der the law.
    God did this so he
    could buy free -- dom for those
    who were un -- der the law
    and so we could be -- come his chil -- dren.

}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize

}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	%\set stanza = "3."
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