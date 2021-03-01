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
  system-system-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . 2 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . -5) (stretchability . 0))
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
  c2 e:m f e:m f a:m g:sus4 g c e:m f e:m f a:m g:sus4 g
  c:/e f:1.3.5.9 c:/g g c:/e f:1.3.5.9 a:m7 g:sus4 g c:/e f:1.3.5.9 c:/g g g g c:/e f:1.3.5.9 c:/g g1
  c2:/e f:1.3.5.9 c:/g g c:/g g2 g1 f d:m
  a2:m c:/g f:6 c:/e f:6 c:/e d:m7 c:/bf  a2:m c:/g f:6 c:/e f:6 c:/e d:m7 c:/bf
  g:/f c:/e g:/f c:/e g:/f c:/e bf:maj7 a:m7 bf1:maj g2:sus4 g

  c2 e:m f e:m f a:m g:sus4 g c2 e:m f e:m f a:m g:sus4 g f1 d:m

}
  melody = \relative c'{
  \time 4/4
  \key c  \major
  \clef treble
  \tempo 4 = 80 \override Score.MetronomeMark.padding = #3

  %\set melismaBusyProperties = #'()
  %\unset melismaBusyProperties
  \repeat volta 3{
    e8 g4 e8 g g b a~a4 r g8 g16 g~g b8. a4 a8 b c c b a a g g e g4 r4
    e8 g g4 g8 g g b a4 r8. f16 g8 g g b a4 b c8 c16 c b b a8 a g g16 e8. g4 r4
    \bar "||"
    r4 e'8 d8~d4 f,8 e~e4 c'8 c~c b~b4 r4 e8 d8~d4 f,8 e~ \time 2/4 e e g c~ \time 4/4 c b a b~b2 
    r4 e8 d8~d4 f,8 e~e4 c'8 c~c b4 b8~ 
  }
  \alternative{
    { \time 2/4 b2 }
    { \time 2/4 b2\repeatTie  \time 4/4 r4 e8 d8~d4 f,8 e~ \time 2/4 e4 c'8 b~ \time 4/4 b2 r2 }
    { b8\repeatTie  r8 e8 d8~d4 f,8 e~e4 c'8 c~c b a b~b4 c8 c~c b b4~b2 r2  }
  }
  r8 a a g g f f e d2 r2 \bar "||" \break
  r8 e e4 e8 f e c d e16 e~e4 r8 f8 e c d e16 e~ e4 r16 e e8 d c a4 r e'8 f e c
  r8 e e d e f e c d e16 e~e4 r16 e f8 e c d e16 e~ e4 r16 e e8 d c a4 r e'8 f e c
  b' a g f g4 r b8 a g f g4 r8 c, b' a g f g4 e8 c d4 d8 e d4 g, f'8 e f e f4 e d2 r \bar ".|:-||" \break

   \repeat volta 3{
    e8 g4 e8 g g b a~a4 r g8 g16 g~g b8. a4 a8 b c c b a a g g e g4 r4
    e8 g g4 g8 g g b a4 r4 g8 g g b a4 b c8 c b a a g e g~g4 r4 r8 a16 a a8 g f e c d~d2 r2
    \bar "||"
    r4 e'8 d8~d4 f,8 e~e4 c'8 c~c b~b4 r4 e8 d8~d4 f,8 e~ \time 2/4 e e g c\time 4/4 c b b a b2 
    r4 e8 d8~d f, f e~e4 c'8 c~c b~b4 
  }
  \alternative{
    { r4 e8 d~d4 f,8 e~e g c c~c b b a | b2 r2 }
    { \time 2/4 b2\repeatTie  \time 4/4 r4 e8 d8~d4 f,8 e~ \time 2/4 e4 c'8 b~ \time 4/4 b2 r2 }
    { b8\repeatTie  r8 e8 d8~d4 f,8 e~e4 c'8 c~c b a b~b4 c8 c~c b b4~b2 r2  }
  }
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
  they're thine, and thou ga -- vest them me; _ and they have kept thy word.
}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "3."
  Now they have known that all things thou hast gi -- ven me are of thee. 
  For I have gi -- ven un -- to them; gi -- ven words which thou ga -- vest me; and they have re -- ceived them, 
  and know, sure -- ly that _ I came out from __ _ thee, and they've be -- lieved thou sent me.
  I pray for them: I pray not for the world, but for them which thou hast giv'n me; 
  _  _ _ _ _ _ _ _
  for they are thine.
  And all mine are thine, and thine are mine; and I am glo -- ri -- fied in them.

  And now I am no more in the world, but these are in the world, and I come to thee. Ho -- ly Fa -- ther, 
  keep thru thine own name those thou ga -- vest me, that they may be one, as we.
  While I was with them in the world, 
  I kept them in thy name: those that thou hast gave, and none of them is lost, 
  but the son of per -- di -- tion; 
  that the scrip -- ture be ful -- filled.
  
  \set stanza = "4."
  And now __ _ come I to thee; and these things I speak in the world, that they might have my joy ful -- filled. 
  I have giv'n, gi -- ven them thy word; and the world hath hat -- ed them, be -- cause they're not of the world,
  e -- ven as I'm not of the world. 
  
  I pray not that thou takes them, but that thou should -- est keep them from the e -- vil one. 
  They're not of the world, as I'm not. Sanc -- ti -- fy them thru thy truth: thy word is truth. 
  As thou hast sent me in -- to the world, e -- ven so have I al -- so sent them into the world. 1And for their sakes I 
  sanc -- ti -- fy my -- self, that they al -- so might be sanc -- ti -- fied through the truth.
}
versefour = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  \set stanza = "5."
  I don't pray for these a -- lone, but for them al -- so which __ _ shall be -- lieve on me __ _ through their
  word; that they __ _ all may __ _ be one; as thou, Fa -- ther, art in me, and I in thee, that they al -- so may be 
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


