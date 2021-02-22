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
  title = "Galatians 3:11-14"
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
  system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . -.59 ) (stretchability . 00))
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
  af1 f2.:m ef4 af1 f2:m ef2 af1 f2.:m ef4 af1 f2:m ef
  df1:1.3.5.9 df1:1.3.5.9 af1 f2.:m ef4 
  af1 f2.:m ef4 af1 f2:m ef2 af1 f2.:m ef4 af1 f2:m ef
  df1:1.3.5.9 df1:1.3.5.9 af1 f2.:m ef4 

  af1 ef bf:m7 df af ef bf:m7 df af f2.:m ef4

  af1 f2.:m ef4 af1 f2:m ef2 af1 f2.:m ef4 af1 f2:m ef
  df1:1.3.5.9 df1:1.3.5.9 af1 f2.:m ef4 

   
}
melody = \relative c'{
  
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key af  \major
	\clef treble
	\tempo 4 = 100
  \override Score.MetronomeMark.padding = #3
  r4 c8 ef~ef f4 c8~c2 r2 | r4 c8 ef~ef f4 c8~|c c c c~c bf4 c8~|
  c4 r8 ef~ef f4 c8~c2 r2 | r4 c8 ef~ef f4 c8~|c bf4 bf8~bf4 r4 |
  af'8 af af af~af g4 f8~f4 ef8 ef~ef bf4 c8~c2 r2 | r1 \bar "||"
  r4 c8 ef~ef f4 c8~c2 r2 | r8 c c ef~ef f4 c8~|c c c c~c bf4 c8~|
  c4 c8 ef~ef f4 c8~c2 r2 | r4 c8 ef~ef f4 c8~|c bf4 bf8~bf4 r4 |
  af'4 af8 af af g4 f8~~f4 ef8 ef ef bf4 c8~c2 r2 | r1
  \bar ".|:-||"
  af'4 af af8 ef af bf~bf4 r8 af bf af af4 df8 c bf af~af4 r4 df8 c bf af~af4 r 
  af4 af af8 ef ef af bf4. af8~af4 r4 df8 c c bf bf af f ef~ef ef ef ef~ef bf4 c8~c2 r2 | r1
  \bar "||"
  r4. ef8~ef f4 c8~c2 r2 | r4 c8 ef~ef f4 c8~|c c c c c bf bf c~|
  c4 r8 ef~ef f4 c8~c2 r2 | r4 c8 ef~ef f4 c8~|c bf4. r2 |
  af'8 af af af af g g f~f ef ef ef ef bf4 c8~c2 r2 | r1 \bar ":|."


}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  Now it is clear 
  that no one can be made right with God 
  by the law,
  be -- cause the Scrip -- tures say, 
  “Those who are right with God will live by faith.”
  The law's not based 
  based on faith. It says, “A person who o -- beys 
  O -- beys these things will 
  live be -- cause of them.”
  Christ took a -- way the curse the law put on us. 
  
  He changed plac -- es with us and put him -- self 
  un -- der the curse_– un -- der the curse. 
  It is writ -- ten in the Scrip -- tures, 
  “A -- ny -- one whose bo -- dy's dis -- played on a tree is cursed.” 

  Christ did this 
  so that God’s bless -- ing pro -- mised to A -- bra -- ham 
  might come through 
  Je -- sus to non -- Jews. 

  Dy -- ing so be -- liev -- ing we could re -- ceive the Ho -- ly Ghost.
  
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
		\new ChordNames {
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