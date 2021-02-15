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
  title = "Galatians 2:20b - 3:1"
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
 	min-systems-per-page = 10 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 4 ) (minimum-distance . .10) (padding . .6 ) (stretchability . 00))
  % the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
  score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
  % the distance between a (title or top-level) markup and the system that follows it:
  markup-system-spacing = #'((basic-distance . 0) (padding . -5) (stretchability . 0))
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
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 e:maj7 e:maj7
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 e:maj7 e:maj7
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 cs:m7 cs:m7
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 e:maj7 e:maj7
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 cs:m7 cs:m7 gs:m b
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 e:maj7 e:maj7
  gs1:m gs:m gs:m/fs gs:m/fs e:maj7 e:maj7 e:maj7 e:maj7 

}
melody = \relative c'{
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key gs  \minor
	\clef treble
	\tempo 4 = 74
  \override Score.MetronomeMark.padding = #3
  \tiny
  \set countPercentRepeats = ##t
  \repeat percent 4 { ds8 b ds b ds b' as gs | ds8 b ds b ds b' as gs }
  \bar "||" 
  \normalsize
  r2 r8 fs e ds~ds2~ds8 ds b cs ds2 r2 | r1 | r2 r8 fs e ds~ds2~ds8 b4 cs8~cs2 r2 r1
  r2 r8 fs e ds~ds4 e8 ds~ds4 b8 cs ds2 r2 | r1 | r2 r8 fs e ds ds2~ds8 b4 cs8~cs2 r4. ds8~ds2 r2 
  \bar "||" 
  r2 r8 fs e ds~ds4 e8 ds~ds4 b8 cs ds2 r2 | r1 | r2 r8 fs e ds~ds4 e8 ds~ds b4 cs8~cs2 r2 r1
  r2 r8 fs e ds~ds4 e8 ds~ds4 b8 cs~cs ds~ds4 r2 | r1 | r2 r8 fs e ds ds4 e8 ds~ds4 b8 cs8~cs4. ds8~ds2
  r2 fs4 e8 e~ e ds~ds4 r2 |  r1 
  \bar "||"
  r2. fs8 e~e4 ds8 ds~ds4 b8 cs~cs ds ds2 r4 | r1 | r2. e8 ds~ds2 ds4 b8 cs~cs4. ds8~ds2 r1 
  r2 r8 fs fs e ds4 e8 ds~ds4 b8 cs~cs ds~ds2 e8 ds~ds2 r8 ds ds b cs4 ds4~ds8 ds8 ds b cs4 ds2 r4 | r1

}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  I still live in my bo -- dy, 
  but I live by faith 
  in the Son of God who loved me 
  and gave him -- self to save me.
  When I say these things I am not
  not go -- ing a -- gainst God’s grace. 
  Just the op -- po -- site, if the law could make us right with God, 
  then Christ’s death would be use -- less. 

  You peop -- le in Gal -- a -- ti -- a 
  were told ve -- ry clear -- ly 
  a -- bout the death of Je -- sus Christ on the cross. 
  But you were fool -- ish; let some -- one trick you.
}
versetwo = \lyricmode {
_ _ _ _ _ _ _ _ _ _ _ _ _ _
	\override LyricText #'font-size = \LyricFontSize
  _ _ \set stanza = "2."
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