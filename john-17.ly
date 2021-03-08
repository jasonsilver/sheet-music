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
  system-system-spacing = #'((basic-distance . 0 ) (minimum-distance . 0) (padding . 1 ) (stretchability . 00))
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
	%\set Staff.midiInstrument = #"string ensemble 1"
  a2 cs:m d cs:m d fs:m e:sus4 e a cs:m d cs:m d fs:m e:sus4 e
  a:/cs d:1.3.5.9 a:/e e a:/cs d:1.3.5.9 fs:m7 e:sus4 e a:/cs d:1.3.5.9 a:/e e e e a:/cs d:1.3.5.9 a:/e e1
  a2:/cs d:1.3.5.9 a:/e e a:/e e2 e1 d b:m
  fs2:m a:/e d:6 a:/cs d:6 a:/cs b:m7 a:/g 
  fs2:m a:/e d:6 a:/cs d:6 a:/cs b:m7 a:/g  fs2:m a:/e d:6 a:/cs d:6 a:/cs b:m7 a:/g
  e:/d a:/cs e:/d a:/cs e:/d a:/cs g:maj7 fs:m7 g1:maj e2:sus4 e
  e2:sus4 e g1:maj7 e2:sus4 e  g1:maj7 b1:m e2:sus4 e 
  a2 cs:m d cs:m d fs:m e:sus4 e a2 cs:m d cs:m d fs:m e:sus4 e d1 b:m g:maj7 e2:sus4 e
  a:/cs d:1.3.5.9 a:/e e a:/cs d:1.3.5.9 fs:m7 e:sus4 e a:/cs d:1.3.5.9 a:/e e e cs1:m7 d2:6
  a2:/e e e b1:m7
  g1:1.3.5.9 d:/fs g:1.3.5.9 d:/fs
  a2:/cs d:1.3.5.9 a:/e e a:/cs d a:/e e a:/cs d:1.3.5.9 a:/e e
	a:/cs d:1.3.5.9 a:/e e a1
  
}
  melody = \relative c'{
  \time 4/4
  \key a  \major
  \clef treble
  \tempo 4 = 80 \override Score.MetronomeMark.padding = #3

  %\set melismaBusyProperties = #'()
  %\unset melismaBusyProperties
  \repeat volta 3{
    cs8 e4 cs8 e e gs fs~fs4 r e8 e16 e~e gs8. fs4 fs8 gs a a gs fs fs e e cs e4 r4
    cs8 e e4 e8 e e gs fs4 r8. d16 e8 e e gs fs4 gs a8 a16 a gs gs fs8 fs e e16 cs8. b4 r4
    \bar "||"
    r4 cs'8 b8~b4 d,8 cs~cs4 a'8 a~a gs~gs4 r4 cs8 b8~b4 d,8 cs~ \time 2/4 cs cs r e \time 4/4 a gs fs gs~gs2 
    r4 cs8 b8~b4 d,8 cs~cs4 a'8 a~a gs4 gs8~ 
  }
  \alternative{
    { \time 2/4 gs2 }
    { \time 2/4 gs2\repeatTie  \time 4/4 r4 cs8 b8~b4 d,8 cs~ \time 2/4 cs4 a'8 gs~ \time 4/4 gs2 r2 }
    { gs8\repeatTie  r8 cs8 b8~b4 d,8 cs~cs4 a'8 a~a gs fs gs~gs4 a8 a~a gs gs4~gs2 r2  }
  }
  r8 fs fs e d cs cs a d2 r2 \bar "||" 
%  \pageBreak
  \tiny r8 cs cs4 cs8 d cs a b cs16 cs~cs4 r8 d8 cs a b cs16 cs~ cs4 r16 cs cs8 b a fs4 r cs'8 d cs a \normalsize
  \bar ".|:-||"
  \repeat volta 2{
    r8 cs cs4 cs8 d cs a b cs16 cs~cs4 r8 d8 cs a b cs16 cs~ cs4 r16 cs cs8 b a fs4 r cs'8 d cs a
    r8 cs cs b cs d cs a b cs16 cs~cs4 r16 cs d8 cs a b cs16 cs~ cs4 r16 cs cs8 b a fs4 r cs'8 d e a,
    gs' fs e d e4 r gs8 fs e d e4 r8 a, gs' fs e d e4 cs8 a b4 b8 cs b4 a d8 cs d cs d4 cs 
  }
  \alternative{
    { b2 r }
    {  b2 r d8 cs d cs d4 cs8 a b2 r d8 cs d cs d4 cs b4. a8 a4 fs b2 r }
  }
  %\pageBreak
  \repeat volta 2{
    cs8 e4 cs8 e e gs fs~fs4 r e8 e16 e~e gs8. fs4 fs8 gs a a gs fs fs e e cs b4 r4
    cs8 e e8. cs16 e8 e e gs fs4 r4 e8 e e gs fs4 gs a8 a gs fs~fs e4 cs8 b4 r4 r8 fs'16 fs fs8 e d cs a b~b2 r2 
    r8 fs'16 fs fs8 e d cs a b~b2 r2 
    \bar "||"

    r4 cs'8 b8~b4 d,8 cs~cs4 a'8 a~a gs~gs4 r4 cs8 b8~b4 d,8 cs~ \time 2/4 cs4 r8 e \time 4/4 a gs fs gs~gs2 
    r4 cs8 b8~b4 d,8 cs~
  }
  \alternative{
    { cs4 a'8 a~a gs4 gs8~  gs4 r8 a8~a gs4 fs8~fs e8~e4 r2 }
    { cs4\repeatTie a'8 a~a gs4 fs8 \time 2/4 gs fs gs a \time 4/4 d,2 r2  }
  }
  \bar "||"
  r8 d d cs d e~e4 r8 d d cs d8. cs16~cs8 b8 | r8 d d cs d e~e4 r8 d d b16 cs d8 cs cs a
  \bar "||"
  b4 cs'8 b8~b4 d,8 cs~cs4 a'8 a~a gs~gs4
  r4 cs8 b8~b4 d,8 cs~cs4 a'8 a~a gs~gs4
  r4 cs8 cs b4 d,8 d cs4 e8 a~a gs~gs4
  r4 cs8 b~b4 d,8 cs~cs4 e4 gs a a1
  \bar "|."
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
  Thee, have I glor-i -- fied on earth: fin -- ished all the work- all the work which thou hast gi -- ven me to do. 
  Fa -- ther now, glo -- ri -- fy thou me with thine own self with glo -- ry which we _ shared _ be -- fore the world __ _ was.

  I have made known thy name to the men thou ga -- vest _ me of the world: 
  they're thine, and thou ga -- vest them me; (me) and they have kept thy word.
}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "3."
  Now they have known that all things thou hast gi -- ven me are of thee. 
  For I have gi -- ven un -- to them; gi -- ven words which thou ga -- vest me; and they have re -- ceived them, 
  and know, sure -- ly that _ I came out from __ _ thee, and they've be -- lieved thou sent me.
  I pray for them: I pray not for the world, but for them which thou hast giv'n me; 
  _  _ _ _ _ _ _ (me)
  for they are thine.
  And all mine are thine, and thine are mine; and I am glo -- ri -- fied in them.
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  And now I am no more in the world, but these are in the world, and I come to thee. Ho -- ly Fa -- ther, 
  keep thru thine own name those thou ga -- vest me, that they may be one, as we.
  While I was with them in the world, 
  I kept them in thy name: those that thou hast gave, and none of them is lost, 
  but the son of per -- di -- tion; 
  that the scrip -- ture be ful -- filled.
}
versefour = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  And now come I to thee; and these things I speak of in the world, that they might have joy, joy ful -- filled __ _ %in them -- selves. 
  I have _ giv -- en them thy word; and so _ the world hath hat -- ed them, _ be -- cause they're not of the wo -- rld,
  e -- ven as I'm not, I'm not of the world. 
  I pray not that thou takes them, but thou should -- est keep them; keep them from the e -- vil _ one. 
  They're not of the world, as I'm not. Sanc -- ti -- fy them thru thy truth: thy word is truth. 
  \set stanza = "4."
  As thou sent me to the world,  so in -- to the world have I al -- _ so __ _ sent __ _ _ _ them.
  For their sakes I sanc -- ti -- fy my -- self, that they al -- so might be sanc -- ti -- fied __ _ thru the truth.
  Nei -- ther pray I for these a -- lone, 
  al -- so for be -- liev -- ers in me; % thru their word;
  That they be one; as we are, and al -- so may be one __ _ in us:
  so that the world may be -- lieve that thou hast sent me. 
}
versefive = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _
  \set stanza = "5."  
  And the _ glo -- ry thou gave I have gi -- ven them; that they may be one, e -- ven as we are one:
  
  I in them, _ and thou __ _ in me, that they __ _ may be made per -- fect- yes- _ in __ _ one; 
  so the world may know thou sent me, and hast loved them, as thou loves me.
  
  Fa -- ther, my will they be with_me; that they may see my glo -- ry, thou gave: for thou loved me 
  _ _ _ _ _ _ _ _ _ 
  be -- fore the foun -- da -- tion of the world. 
  
  O righ -- teous Fa -- ther, the world hath not known thee:
  but I have known thee, and these have known that thou hast sent me. 

  And I've de -- clared un -- to them 
  thy name, and will de -- clare it: 
  that the love where -- with thou hast loved me may be in them, 
  and I in them.
 
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