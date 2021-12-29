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
  title = "Galatians 4:6-7"
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
  c2 e:m a:m f c2 e:m a:m f
  c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f 
  c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f 
  c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f c2 e:m a:m f 
  c2 e:m a:m f c2 e:m f c |
}
melody = \relative c'{
	\set Staff.midiInstrument = #"piano"
	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key c  \major
	\clef treble
	\tempo 4 = 110
	%\set melismaBusyProperties = #'()
	%\unset melismaBusyProperties
  \slashOn r4 r r r | r r r r | r r r r | r r r r | \slashOff \bar "||" \break
  r4 e8 e e4 d8 d~d e~e2 r4 | r8 e e e e d d c | e4. e8 d4 c8 g~| g4 r2. | r4. e'8 d4 c8 g~ | g4 r2. |
  r4 c8 c c d e f | \bar "||" \break
   r4 g2. | e4 r8 c8 c d e f | r4 g2 (a4) | e4 r2.  \bar "||" \break
  r8 e8 e e e4 d8 d~( d e~e2) r4 | 
  r8 e e e e d d c | e4 r4 d4 c8 c | g4 r2. | r2 d'4 c8 c | g4 r2. |
  r4. c8 c d e f \bar "||" \break
  r4 g2.( | e4) r8 c8 c d e f | r4 g2 (a4 | e4) r8 c8 c d e f |
  r4 g2.( | e4) r8 c8 c d e d~ | d c~c4 r2 | r1 \bar "|."

}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
   Since you are God’s chil -- dren, 
   God sent the Spir -- it of his Son in -- to your hearts, 
  in -- to your hearts, 

   and the Spi -- rit cries out, “Fa -- ther.” 
   the Spi -- rit cries out, “Fa -- ther.” 

   So now you're not a slave; 
   You are God’s child, 
   and God will give you the bless -- ing 
   Which he pro -- mised, 
   Be -- cause you are his child
   Be -- cause you are his child
   Be -- cause you are his child
   Be -- cause you are his child.
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