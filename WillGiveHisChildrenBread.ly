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
  title = "Will Give His Children Bread"
  subtitle = "(Sometimes a light surprises)"
  composer = "Jason Silver"
  poet = "William Cowper (1731-1800)"
  copyright = "Silver Ink. 2020"
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
  system-system-spacing = #'((basic-distance . 14 ) (minimum-distance . 0) (padding . 2.5246 ) (stretchability . 4 ))
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
  <cs ds es gs>1-\markup { "2" } % notate as 1.2.3.5 
  <cs fs gs>1-\markup {"sus"}
  <cs as ds gs>1-\markup { "m2" } % 1.6.2.
  <cs es gs ds'>1-\markup { \super "add9" } % 1.3.5.9
  <cs e gs ds'>1-\markup { "m" \super "add9" } % 1.3.5.9
}
chExceptions = #(append (sequential-music-to-chord-exceptions chExceptionMusic #t) ignatzekExceptions)
chordNames = \chordmode {
	\set chordNameExceptions = #chExceptions
	\set chordChanges = ##t % ##t(true) or ##f(false)
	\set Staff.midiInstrument = #"string ensemble 1"
  \skip2. a4.:m7 g c:/e f d:m7 c g:sus4 g 
  a:m7 g c:/e f d:m7 c g:sus4 g 
  d:m7 c:/e g:sus4 g d:m7 c:/e g:sus4 g
  a:m7 g c:/e f d:m7 c g:sus4 g 
  % instrumental
  a4.:m7 g c:/e f d:m7 c g:sus4 g

  g:sus4 g

  c e:m7 f2.:6 c4. e:m7 f4. d:m7 c4. e:m7 f2.:6 c4. e:m7 f:6 g
  a4.:m7 g c:/e f d:m7 c g:sus4 g 
  a:m7 g c:/e f d:m7 g:/b c2.
  \bar "||"
}
melody = \relative c''{
	\set Staff.midiInstrument = #"piano"
	%           \set melismaBusyProperties = #'()
	\time 6/8
	\key a  \minor
	\clef treble
	\tempo 4 = 70
  
	r4. r4 b8 \bar ".|:"
  \repeat volta 2 { 
    c4 d8 b4 g8 | g4. a4 r16 g | f4 g8 e4 c8 | d4. r4 b'8
    c4 d8 b4 g8 | g4. a4 r16 g | f4 g8 g4 c,8 | d4. r4 e8 |
    f4 a8 g4 e8 e (d c)  d4 e8 f4 a8  g4 e8 d4. r8 a'8 b |
    c4 d8 b8 a g | g4. a4 r16 g | f4 g8 e4 c8 
  }
  \alternative{
    { d4. r4 \tiny b'8
      c4 d8 b4 g8 | g4. a4 r16 g | f4 g8 e4 c8 | d4. r4 \normalsize b'8
    }
    {
      \break d,4. r8 e d \bar "||" 
    }
  }
  c4. g'4 e8 d4. c4 d8 | c4 c8 g'4 e8 c4. r4 d8 | c4 c8 g'4 e8 d4. c4 d8 c4 c8 g'4 e8 c4. r4 b'8 |
  c4 d8 b4 g8 | g4. a4 r16 g | f4 g8 e4 c8 | d4. r8 a' b8
   c4 d8 b8 ( a ) g | g4. a4 r16 g | f4 e8 d4 b8 | c4. r4.
  %\bar "|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "1."
  Some -- times a light sur -- pri -- ses
  The Chris -- tian while he sings;
  It is the Lord who ri -- ses
  With heal -- ing in His wings;
  When com -- forts are de -- clin -- ing,
  He grants the soul a -- gain
  _ A sea -- son of __ _ clear shin -- ing,
  To cheer it af -- ter rain.
  _ _ _ _ _ _ _ _ _ _ _ _ _
  In
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "2."
  _ ho -- ly con -- tem -- pla -- tion
  We sweet -- ly then pur -- sue
  The theme of God’s sal -- va -- tion,
  And find it ev -- er new;
  Set free from pre -- sent sor -- row,
  We cheer -- full -- y can say—
  E -- ven let the un -- known to -- mor -- row
  Bring with it what it 
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ may.
  \set stanza = "Chorus"
  It can bring with it no -- thing,
  But He will bear us through;
  Who gives the li -- lies clo -- thing,
  Will clothe His peo -- ple too:
  Be -- neath the spread -- ing hea -- vens
  No crea -- ture but is fed;
  And __ _ He, who feeds the ra -- vens,
  Will give His child -- ren bread.

}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	\set stanza = "3."

  Though vine nor fig tree nei -- ther
  Their won -- ted fruit shall bear;
  Though all the fields should wi -- ther
  Nor flocks nor herds be there;
  Yet God the same a -- bid -- ing,
  His praise shall tune my voice,
  For, while in Him con -- fid -- ing,
  I can -- not but re -- joice.
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