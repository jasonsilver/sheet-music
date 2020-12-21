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
  title = "John 1:29-34"
  subtitle = "King James Version"
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
 min-systems-per-page = 9 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 8 ) (minimum-distance . 0) (padding . .09 ) (stretchability . 00))
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
	\set Staff.midiInstrument = #"string ensemble 1"
  g2 a g:/b a:/cs g:/b a4 d:/fs g2 a

  d2 g:/d d2. a4:/cs b2:m7 g d:/a a d2 g:/d d2. a4:/cs b2:m7 g d:/a a
 
  g2 a g:/b a:/cs g:/b a4 d:/fs g2 fs:m7 g2 a g:/b a:/cs g:/b a4 d:/fs g2 a

  e1:m7 d2:/a a

  g4:maj7 b:m7 a fs:m7 g1:maj7 g2:maj7 a4 fs:m7 g2:maj7 fs:m7
  g4:maj7 b:m7 a fs:m7 g2.:maj7 d4:/fs g2:maj7 a4 fs:m7 g2:maj7 fs:m7 e1:m7 a:7sus4

  e1:m7  g2:/b a e1:m7 g a:sus4
}
melody = \relative c'{
	\set Staff.midiInstrument = #"piano"
	\time 4/4
	\key d  \major
	\clef treble
	\tempo 4 = 80 \override Score.MetronomeMark.padding = #3

	\set melismaBusyProperties = #'()
	%\unset melismaBusyProperties
	r8 b b cs~cs4 r4 r8 b b d cs4 b8 (a) r8 b16 b b8 cs cs4 d b4. cs8~cs4  r8
	
	fs \bar ".|:-||" fs4. g8 g4. fs8 fs2
	r4. fs8 fs8. e16~e8 fs8 g4. fs8 fs4 e8 d e4 r8 fs
  fs4. g8 g4. fs8 fs2
	r4. fs8 fs8. e16~e8 fs8 g4. fs8 fs4 e8 d e4 r4 
  \bar "||" 
  r8 b16 b b8 cs cs4 r4 r8 b b d cs4 b8 (a) r8 b16 b b8 cs cs4 d b4. (cs8~cs4) r4
  r8 b b cs cs4 r4 r8 b b d cs4 b8 (a) r8 b16 b b8 cs cs4 d b4. cs8~cs4  r8 fs
  \bar ":|."
  g4. fs8 g4. fs8 fs2 e4 r4
  \bar ":|."
  b'4 d cs a b2. r8 a8 | b8 b b d cs b b a b4. a8~a4 r8 a
  b4 d cs a b2. r8 a8 | b8 b b d cs b b16 a8 fs16 b4. a8~a4  a8 fs
  b4. a8~a4 fs e2 r4
  r8 fs8 g d' cs2 e,8 fs g fs g d' cs b cs4 g8 d' cs2 e,8 fs g fs g fs g fs e d e2 r4 r8 fs 
  \bar ":|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
	The next day _ John see -- th Je -- sus _ com -- ing un -- to him, and sa -- ith, _ 

	Be -- -hold the Lamb of God, 
	which tak -- eth _ a -- way   the sin of the world.
  Be -- -hold the Lamb of God, 
	which tak -- eth _ a -- way  the sin of the world.

  \set stanza = "2."
	This is he of whom 
  Of whom I said, __ _ _ 
  Af -- ter me there comes a man __ _ _
  which is pre -- ferred 
  _ be -- fore me: __ _ _  
  for he was be -- fore __ _ me. __ _ _ Be-

	
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	\set stanza = "3."
  And I knew him not: 
  but that he should be _
  made _ ma -- ni -- fest to Is -- ra -- el, 
  there -- fore I come bap -- tize with wa -- ter. _
	%And John bare re -- cord, say -- ing, I
  Saw the Spir -- it des -- cend %ing from hea -- ven 
  like a dove, 
  
  and it a -- bode u -- pon him.

	And I knew him not: 
  but he that sent me to bap -- tize with wa -- ter, _ 
  the same said un -- to me, 
  Up -- on whom thou shalt see the Spi -- rit des -- cen -- ding, _
  and re -- ain -- ing _ on him, 
  the same is he which ba -- pti -- zes with the Ho -- ly Ghost.
	And I saw, and bare re -- cord that this is the Son of God.
  Be-
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


