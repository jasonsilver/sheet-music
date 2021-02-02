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
  title = "Galatians 2:15-21"
  subtitle = "New Century Version"
  composer = "Jason Silver"
  arranger = " "
  poet = ""
  copyright = "Silver Ink. 2021"
  tagline = "Permission granted to share with attribution."
}
\paper {
  top-margin = 8\mm
  bottom-margin = 4\mm
  right-margin = 10\mm
  left-margin = 10\mm
  indent = 0\mm
 
 	%min-systems-per-page = 11 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . 1 ) (stretchability . 00))
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
  f4. ef8~ef2 | bf4.:/d c8:/e~c2/e | f4. ef8~ef2 | bf4.:/d c8:/e~c2/e
  f4. ef8~ef2 | bf4.:/d c8:/e~c2/e | f4. ef8~ef2 | bf4.:/d c8:/e~c2/e
  bf4.:6/d c8:/e~c2:/e |f4. g8:m~g2:m | ef4. f8~f2
}
melody = \relative c'{
  \set Staff.midiInstrument = #"acoustic grand"
  %           \set melismaBusyProperties = #'()
  \time 4/4
	\key f \major
	\clef treble
	\tempo 4 = 100
  \override Score.MetronomeMark.padding = #3
  \repeat volta 2{
    r8 a' g g~g f f d~d f4 d8~d c c bf c2 r2 | r1 |
    r8 a' g g~g f f d~d f4 d8~d c c bf c2 r8 f g a~a bf a g~g f g a~
    
  }
  \alternative  {
    { a8 bf a g~g f4 f8~ f2 r2 | \improvisationOn f4. f8~f2 \improvisationOff }
    {  a8 bf a g~g f4 a8(~a bf) a g~g f( g) a~a bf a g~g2  }
  }
  \bar "||" \break


}
nothing = \lyricmode {}
verseone = \lyricmode {
  \override LyricText #'font-size = \LyricFontSize
  \set stanza = "1."
  We're not born as non -- Jew -- ish “sin -- ners,” but as Jews. 
  Yet we know that a per -- son is made right with God 
  Not by fol -- l'wing the law, 
  but by trust -- ing in Je -- sus Christ. 

}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  \set stanza = "3."

So we, too, have put our faith in Je -- sus _ Christ, 
that we're made right with God since we trust -- ed in Christ. 
Not from fol -- l'wing the law, be -- cause no 

_ _ _ _ _ _ _
_ one can be made 
right with God by fol -- l'wing the law.

We Jews came to Christ, try -- ing to be made right with God, and it be -- came clear that we are 
sinn -- ers, too. Does this mean that Christ en -- cour -- ag -- es sin? No! But I would real -- ly 
be wrong to be -- gin teach -- ing a -- gain those things that I gave up.  It was the law that put 
me to death, and I died to the law so that I can now live for God.  I was put to death on the cross 
with Christ, and I do not live a -- ny -- more— it is Christ who lives in me. I still live in my 
bo -- dy, but I live by faith in the Son of God who loved me and gave hims -- elf to save me.  By 
say -- ing these things I am not go -- ing a -- gainst God’s grace. Just the op -- po -- site, if 
the law could make us right with God, then Christ’s death would be use -- less.
  
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
		\new ChordNames  \with {midiInstrument = #"acoustic grand"} {
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