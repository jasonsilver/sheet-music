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
  title = "Jonah 2:1b-9"
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
  c2:m7 ef:/g af:1.3.5.9 ef4 bf:/d  c2:m7 g:m7 af:1.3.5.9 ef4 bf:/d c2:m7 ef:/g af1

  ef2 bf:/d c:m af:6 ef bf:/d c:m g:m7 af1

  c2:m7 ef:/g af:1.3.5.9 ef4 bf:/d  c2:m7 g:m7 af:1.3.5.9 ef4 bf:/d  
  c2:m7 ef:/g af:1.3.5.9 ef4 bf:/d  c2:m7 ef:/g af1:1.3.5.9

  f2:m ef:/g a1:1.3.5.9 f2:m ef:/g bf4:1.5 bf:sus4 bf2 f:m ef:/g bf1

  c2:m7 ef:/g af:1.3.5.9 ef4 bf:/d  c2:m7 g:m7 af:1.3.5.9 ef4 bf:/d  
  c2:m7 ef:/g af:1.3.5.9 ef4 bf:/d  af2:/c bf  af:/ef ef
 
}
melody = \relative c'{
  \set Staff.midiInstrument = #"trumpet"
  % \set melismaBusyProperties = #'()
  \time 4/4
	\key ef  \major
	\clef treble
	\tempo 4 = 65
  \override Score.MetronomeMark.padding = #3
  \bar ".|:"
  r8 ef'16 ef~ef8 d16 d~d8 c16 c~c8 bf16 af bf4 r8 g16 af bf8 g f (ef)
  
  r8 ef'16 ef~ef8 d16 d d8 c16 c c8 bf16 bf~bf8 g16 f~f8 ef16 bf' bf g8. f8 ef16 ef~ef4
  r2. r1
  \bar ":|." \break
  ef4 ef ef8 f g bf g4 r4 f ef8 ef~ef ef ef4 ef8 f g bf~bf g16 f~f8 ef8 bf' g f8 ef~ef4 r2.
  \bar "||"
  r8 ef'16 ef~ef8 d16 d~d8 c16 c~c8 bf16 af bf4 r8 g16 af bf8 g f ef
  
  r8 ef'16 ef~ef8 d16 d~d8 c16 c~c8 bf16 bf~bf4 r2. |
  r8 ef16 ef ef8 d16 d d8 c16 c~c8 bf16 bf~bf4 r8 g16 af bf8 g f ef | 
    r8 ef16 ef~ef8 bf'16 bf~bf8 g f ef16 bf'16 bf g8. f8 ef16 ef~ef4 r4 
  \bar "||"
  r1 r2. f8 g af4 r8 af g f ef f~f4 r4. f16 g f ef ef c~c4 af'8 af g f ef f~f4 f8 ef f g f ef
  \bar "||"
  r8 ef'16 ef ef8 d16 d~d8 c16 c~c bf bf af bf4 r8 g16 af bf8 g f (ef)
  r8 ef'16 ef~ef8 d16 d~d8 c16 c~c8 bf16 (af) bf4 r8 g16 (af) bf8 g f ef
  ef8 ef'16 ef~ef8 d16 d~d8 c16 c~c8 bf16 (af) bf4 r8 g16 af bf8 g f ef
c2 d4. ef8 ef2. r4 \bar "|."

}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  In my dis -- tress I called to the Lord,
  and he an -- swered me.
  From deep in the realm of the dead I called for help,
  and you list -- ened to my cry.
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "2."
  You hur -- led me in -- to the __ _ depths,
  to the heart of the_seas,
  the cur -- rents swirled _ a -- bout me;
  your waves and break -- ers _
  swept __ _ ov -- er me.

  I said, ‘I have been ba -- nished from your sight;
  yet I will look ag -- ain to -- ward your ho -- ly tem -- ple.’

   En -- gulfi -- ng wa -- ters threat -- ened __ _ me,
  and the deep sur -- round -- ed;
  sea -- weed was wrapped a -- round my head.
 
  To the roots of the moun -- tains I sank down;
  and the earth barred me in.
  But you, O Lord my God,
  brought my life up from the pit.

  “When my life was eb -- bing a -- way,
  I re -- mem -- bered you, Lord,
  and my prayer rose to you,
  to your ho -- ly tem -- ple.

  “Those who cling to worth -- less i -- dols
  turn a -- way from God’s love for them.

  But I, with shouts of grate -- ful praise,
  will sa -- cri -- fice to you.
  What I have vowed I will make good.
  I will say, ‘Sal -- va -- tion comes from the Lord.’
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
