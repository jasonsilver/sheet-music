\language "english"
\version "2.18.1"
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
  title = "John 17"
  subtitle = "King James Version"
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
 %min-systems-per-page = 9 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . .09 ) (stretchability . 00))
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
  c2 e:m f e:m f a:m g:sus4 g c e:m f e:m f a:m
}
  melody = \relative c'{
  \time 4/4
  \key c  \major
  \clef treble
  \tempo 4 = 80 \override Score.MetronomeMark.padding = #3

  %\set melismaBusyProperties = #'()
  %\unset melismaBusyProperties
  \bar ".|:"
  e8 g4 e8 g g b a~a4 r g8 g16 g~g b8. a4 a8 b c c b a a g g e g4 r4
  e8 g g4 g8 g g b a4 r8. f16 g8 g g b a4 b c8 c16 c b b a8 a g g16 e8. g4 r4
  \bar "||"
  r4 e'8 d8~d4 f,8 e~e4 c'8 c~c b~b4 r4 e8 d8~d4 f,8 e~ \time 2/4 e e g c~ \time 4/4 c b a b~b2 
  r4 e8 d8~d4 f,8 e~e4 c'8 c~c b4 b8~ \time 2/4 b2 
  \bar ":|." \time 4/4 r4 e8 d8~d4 f,8 e~ \time 2/4 e4 c'8 b~ \time 4/4 b2 r2 
  
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  Fa -- ther, the ho -- ur is come; glo -- ri -- fy thy Son, that thy Son may al -- so glo -- ri -- fy __ _ thee: 
  as thou hast giv'n him pow'r o'er flesh, that he should give e -- ter -- nal life to as ma -- ny as thou hast gi -- ven him. 

  And this is life e -- ter -- nal, that they might know thee the on -- ly true God,
   and Je -- sus Christ, whom thou hast sent.
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
 	\set stanza = "2."
  Thee, have I glor-i -- fied on earth: fin -- ished all the work- all the work which thou __ _ ga -- vest me to do. 
  Now, Fa -- ther, glo -- ri -- fy thou me with thine own self with glo -- ry which I _ had with thee 
  be -- fore the world was.

  I have made known thy name to the men which thou ga -- vest me of the world: 
  they're thine, and thou ga -- vest them me; and they have kept thy word.

  Now they've known that all things what -- so -- ever thou hast gi -- ven me are of thee. 
  For I have gi -- ven un -- to them the words which thou ga -- vest me; and they have re -- ceived them, 
  and have known sure -- ly that I came out from thee, and they have be -- lieved that thou didst send me.
  I pray for them: I pray not for the world, but for them which thou hast gi -- ven me; for they are thine.
  And all mine are thine, and thine are mine; and I am glo -- ri -- fied in them.

  And now I am no more in the world, but these are in the world, and I come to thee. Ho -- ly Father, keep 
  through thine own name those whom thou hast gi -- ven me, that they may be one, as we are.
  While I was with them in the world, I kept them in thy name: those that thou ga -- vest me I have kept, and 
  none of them is lost, but the son of per -- di -- tion; that the scrip -- ture might be ful -- filled.

  And now come I to thee; and these things I speak in the world, that they might have my joy ful -- filled 
  in them -- selves. I have gi -- ven them thy word; and the world hath hat -- ed them, be -- cause they are 
  not of the world, e -- ven as I am not of the world. I pray not that thou should -- est take them out of
  the world, but that thou should -- est keep them from the e -- vil. They are not of the world, even as I 
  am not of the world. Sanc -- ti -- fy them through thy truth: thy word is truth. As thou hast sent me 
  in -- to the world, e -- ven so have I al -- so sent them into the world. 1And for their sakes I 
  sanc -- ti -- fy my -- self, that they al -- so might be sanc -- ti -- fied through the truth.

  Nei -- ther pray I for these a -- lone, but for them al -- so which shall be -- lieve on me through their 
  word; that they all may be one; as thou, Fa -- ther, art in me, and I in thee, that they al -- so may be 
  one in us: that the world may be -- lieve that thou hast sent me. 
  And the glory which thou ga -- vest me I have gi -- ven them; that they may be one, even as we are one: 
  I in them, and thou in me, that they may be made per -- fect in one; and that the world may know that 
  thou hast sent me, and hast loved them, as thou hast loved me.

  Fa -- ther, I will that they al -- so, whom thou hast gi -- ven me, be with me where I am; that they may
   be -- hold my glo -- ry, which thou hast gi -- ven me: for thou lovedst me be -- fore the 
   foun -- da -- tion of the world. 
   
   O righ -- teous Fa -- ther, the world hath not known thee: but I have known thee, and these have known 
   that thou hast sent me. And I have de -- clared un -- to them thy name, and will de -- clare it: that 
   the love where -- with thou hast loved me may be in them, and I in them.
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


