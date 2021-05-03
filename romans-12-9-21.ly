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
  title = "Romans 12:9-21"
  subtitle = ""
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
 	%min-systems-per-page = 10 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . 2 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -2) (stretchability . 0))
	% the distance between the last system of a score and the (title or top-level) markup that follows it:
	score-markup-spacing = #'((basic-distance . 0) (padding . -4) (stretchability . 0))
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
	%set Staff.midiInstrument = #"string ensemble 1"
  d:maj7 g:maj7 d:maj7 g:maj7 d:maj7 g:maj7 d:maj7 g:maj7
  d:maj7 g:maj7 d:maj7 g:maj7 d:maj7 g:maj7 d:maj7 g:maj7
  e2:m g:maj7 a:1.4.5.7 a:6 e2:m g:maj7 a:1.4.5.7 a
  e2:m g:maj7 a:1.4.5.7 a:6 e2:m g:maj7 a:1.4.5.7 a
  e2:m g:maj7 a:1.4.5.7 a
  d1 fs:m7 d fs:m d fs:m7 e:m7 a:1.4.5.7 

  d:maj7 g:maj7 d:maj7 g:maj7 d:maj7
}
melody = \relative c'{
  %set Staff.midiInstrument = #"trumpet"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key d  \major
	\clef treble
	\tempo 4 = 60
  \override Score.MetronomeMark.padding = #3

  r8 fs8 e d a'8 \tiny a8 \normalsize b8. fs16(~fs4. e8~e4) r r8 fs8 e d a'8. b16~b4 fs8 g16 fs~fs8 g16 e~e4 r
  r8 fs8 e d a'8 \tiny a8 \normalsize b8. fs16(~fs4. e8~e4) r r8 fs8 e d a'8 fs16 a~a b8. fs8 e16 fs~fs8 g16 e~e4 r4
  \bar "||"
  r4 cs'8 cs d4 cs b2 r2 r4 cs8 cs d d cs4 b4~b8 a8~a4 r4
  r4 cs d cs b2 r4 a16 b cs cs~cs8. a16  a b cs d cs8 a~a4 r8 b b a16 b(~b8. cs16~cs4) 
  \bar ":|." 
  r4 e,16 fs g a g8 fs4 g8 fs e~e4 r2
  r8. d16 e fs g a g8 fs16 fs~fs8 e16 d e8 fs16 e~e8 d16 e~e4 r4
  r8. d16 e fs g a g8 fs16 fs~fs8 fs16 g fs8 e16 e~e4 r2
  r4 e16 fs g a g8. fs16~fs fs8 e16~e4 r8 d e fs16 e~e d8 a'16~a2 r2 | r1 |
  \bar ".|:-||" 
  r4 d,8 d d e fs g a4 fs e fs r4 d8 d d e fs g a4 fs fs8 e d fs~
  fs4 r4 fs8 a4 a8~a fs4 e8~e fs8~fs4 g g g8 fs e g~g4 r2. \bar ":|."

  r8 fs8 e d a'4 b8. fs16(~fs4. e8~e4) r 
  r8 fs8 e d a'8 a b4 fs4. e8~e4 r | r1
  \bar ":|."
 
}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  Your love must be _ sin -- cere
  Hate what is e -- vil; cling to what is good
  A lov -- ing fam -- _ i -- ly
  Ho -- nour -- ing one a -- no -- ther _ a -- bove your -- selves
  Do not lack in zeal
  Keep your spir -- it -- ual fer -- vor
  serv -- ing the Lord
  joy -- ful in hope, and pa -- tient in af -- flict -- ion, faith -- ful in prayer
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "2."
  Share with God's peo -- ple in need
  Share with them, prac -- tice hos -- pi -- tal -- i -- ty
  Bless those who per -- se -- cute you
  Bless and don't curse. Re -- joice and mourn with all in kind.

  Live in har -- mo -- ny 
  Don't be proud, but make friends with
  With the low -- ly 
  Do not be wise in your own es -- ti -- ma -- tion
  Don't be con -- ceit_-_ed

  Do not re -- pay e -- vil for e -- vil. 
  Be care -- ful to do what is right in the eyes of ev -- 'ry -- one. 
  As far as it is pos -- si -- ble, live at peace with all. 
  Do not take re -- venge, my dear friends, 
  For ven -- geance is the Lord's!

  “If your e -- ne -- my is hun -- gry, feed him;
  If your e -- ne -- my is thir -- sty, give him a drink.
  Do -- ing this will be like pour -- ing fire on his head.”

  Do not let e -- vil win, 
  O -- ver -- come e -- vil with good.

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
