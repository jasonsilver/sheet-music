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
	title = "Galatians 3:19-22"
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
	%min-systems-per-page = 12 % this allows you to squish line spacing

	% the distance between two systems in the same score:
	system-system-spacing = #'((basic-distance . 15 ) (minimum-distance . 0) (padding . -.8 ) (stretchability . 00))
	% the distance between the last system of a score and the first system of the score that follows it, when no (title or top-level) markup exists between them:
	score-system-spacing = #'((basic-distance . 0) (minimum-distance . 0) (padding . 0) (stretchability . 0))
	% the distance between a (title or top-level) markup and the system that follows it:
	markup-system-spacing = #'((basic-distance . 0) (padding . -6) (stretchability . 0))
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
	\skip1 e1 a:1.2.3.5 cs:m7 a:1.2.3.5 e a:1.2.3.5 cs:m7 a:1.2.3.5
	 e1 a:1.2.3.5 cs:m7 a:1.2.3.5 e a:1.2.3.5 cs:m7 a:1.2.3.5

	fs1:m7 e:/gs a:1.2.3.5 cs2:m7 b fs1:m7 b2:sus4 b
	fs1:m7 e:/gs a:1.2.3.5 cs2:m7 b a1 b a:/b

	e1 b fs:m7 a:1.2.3.5 e b fs:m7 a:1.2.3.5
	e
}
melody = \relative c'{

	%           \set melismaBusyProperties = #'()
	\time 4/4
	\key e  \major
	\clef treble
	\tempo 4 = 98
	\override Score.MetronomeMark.padding = #3
	\skip2. r8 b8
	\repeat volta 2{
		b8. e16~e8 fs8 e8. b16~b4 | r2. r8 b | b8. e16~e8 fs8 e8. b16~b4 | r2. r8 b |
		b8. e16~e8 fs8 e8. b16~b4 | r4. b16 b b8. a16~a8 gs~|gs8. \tiny a16~a8 gs8 \normalsize r2 | r2. r8 b8 | 
		b8. e16~e8 fs8 e8. b16~b4 | r2 r8 gs gs a | b8. e16~e8 fs8 e8. b16~b4 | r2. r8 b8 |
		b8. e16~e8 fs8 e8. b16~b8 \tiny cs  | b4 \normalsize r8 b8 b8. a16~a8 gs~| gs2 r2 |  r2 \GotoCoda r4 r8 e'  |
		\bar "||"
		fs4 fs4 fs8 e fs gs fs8. e16~e4 r4 fs8 gs | fs8. e16~e4 r4 b8 b | gs'4 gs gs8 fs r8 e
		fs4 fs fs e8 cs cs b~b4 r4 e8 e fs4 fs fs8 e fs gs fs8. e16~e4 r4 fs8 gs | fs8. e16~e4 r4 b8 b |
		gs'4 gs gs8. fs16~fs8 e | a4 gs fs e b2 r2 | r2. r8 b
	}
	\break
	
	 r2 \Coda gs'4 a
	\bar ".|:-||"
	b2 gs4. gs8~gs fs~fs4 gs4 a b2 gs4. e8~e4 r4 gs a
	b4. gs8~gs gs~gs a fs4. e8 gs4 b, cs2 r2 | r2 gs'4 a |
	\bar ":|."
	\improvisationOn e1 \improvisationOff \bar "|."
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	So what was the law for? 
	'Twas gi -- ven to show that 
	the wrong things that we do 
	are a -- gainst God’s will. 
	_ _ And so it con -- ti -- nued 
	un -- til the spe -- cial de -- scen -- dant, 
	Yes, He who'd been pro -- mised; _ _
	Un -- til He came. 
  
	The law was gi -- ven through the an -- gels 
	who used Mo -- ses 
	for a me -- di -- a -- tor 
	to give the law to the peo -- ple.

	But a me -- di -- a -- tor is not need -- ed when there's on -- ly 
	When there's on -- ly one side, 
	and God is on -- ly one. 
	Does
 

}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
 	\tiny Does \normalsize this mean the law is- 
	is a -- gainst God’s pro -- mise? 
	That would be true on -- ly 
	if the law made us_right with God.
	But God did not give law 
	Did not give law that can bring life. 
	In -- stead, Scrip -- tures show the whole world is bound by sin. 	
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	This was so the pro -- mise would be giv'n through faith
	to the peo -- ple who be -- lieve in Je -- sus Christ.
	This was
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
		\new ChordNames {
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
