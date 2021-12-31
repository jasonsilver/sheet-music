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
  title = "Galatians 4:8-16"
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
  min-systems-per-page = 8 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 9 ) (minimum-distance . 0) (padding . -.2 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between the last system of a score and the (title or top-level) markup that follows it:
  score-markup-spacing = #'((basic-distance . 5) (padding . 0) (stretchability . 0))
  % the distance between two (title or top-level) markups:
  markup-markup-spacing = #'((basic-distance . -1) (padding . -.5))
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
slurOff = {
  \set melismaBusyProperties = #'()
}
slurOn = {
  \unset melismaBusyProperties
}
chExceptions = #(append (sequential-music-to-chord-exceptions chExceptionMusic #t) ignatzekExceptions)
chordNames = \chordmode {
	\set chordNameExceptions = #chExceptions
	\set chordChanges = ##t % ##t(true) or ##f(false)
	\set Staff.midiInstrument = #"piano"
  d1 cs:m7 b:m7 cs:m7 d1 cs:m7 b:m7 a:maj7 
  d1 cs:m7 b:m7 cs:m7 d1 cs:m7 b:m7 a:maj7 b:m7 cs:m7 

  d:maj7 cs:m7 b:m7 cs:m7 d:maj7 cs:m7 b:m7 a:maj7
}
melody = \relative c'{
	\set Staff.midiInstrument = #"piano"
		\time 4/4
	\key a  \major
	\clef treble
	\tempo 4 = 100
	%\set melismaBusyProperties = #'()
	%\unset melismaBusyProperties
  r4 fs8 gs a gs fs e e8. (cs16~cs8) b8~b r cs e, fs4 r8 cs' d cs d e e2 r2 |
  r4 fs8 \slurOff  gs (a)   \slurOn
  gs fs e e8. cs16~cs8 b8~b r cs e, fs4 r8 cs' d cs d( \slurOff e) \slurOn  e2 r2 |
  r8. e16 fs8 gs a gs fs e e8. cs16~cs8 b8~b r cs e, fs4 r8 cs' d cs16 d~d8 e e2 r2 |
  r4 fs8 gs a gs fs e e8. cs16~cs8 b8~b r16 \tiny b \normalsize cs8 e,16 fs~fs4 b8 cs d16 cs8. d8 e e2 r4 cs8 e,16 fs~
  fs8 e fs8. cs'16 d8 cs d e e2 r2 \bar "||"
  r2 cs'8 d cs b~b gs gs a \slurOff  \tieDashed  gs~ \tiny gs \normalsize \tieSolid \slurOn e4 fs1( gs2) r2 | r2 cs8 d cs b~b gs gs a gs8. e16~e8 d~d1 (cs2) r2 \bar "|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize

  In the past you did not know God. 
  You were slaves to gods that were not real. 
  But now _ you know the one true God. 
  Real -- ly tho', it's God who knows _ you. 

  So why do you turn back to those weak rules,
  Use -- less rules that you fol -- lowed be -- fore? 
  Do you want to be en -- slaved a -- gain,
  _ Fol -- low -- ing teach -- ings a -- bout spe -- cial days? % , months, seasons, and years. 
  I'm a -- fraid for you, that my work's been a waste.

  Bro -- thers and sis -- ters, I be -- came _ like you, 
  so now I beg that you be -- come like me. 
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  You were ve -- ry good to me_be -- fore. 
  I was ill, when I met you first time-
  Re -- mem -- ber that I preached the Good News. 
  I was sick, you did not make me leave. 

  _ But you wel -- comed me as one from God,
  Just as if I were Je -- sus him -- self! 
  You were hap -- py then, where's that joy now? 
  I'd tes -- ti -- fy you'd have tak -- en out your eyes
  Gi -- ven them to me, if that were pos -- si -- ble. 
  
  Now I'm your e -- n'my since I tell you the truth?
  Now I'm your e -- n'my since I tell the truth?

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