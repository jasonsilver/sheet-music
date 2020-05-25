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
  title = "Habakkuk 3:2-19"
  subtitle = "New International Version"
  composer = "Jason Silver"
  poet = ""
  copyright = "Silver Ink. 2019"
  tagline = "Permission granted to share with attribution."
}
\paper {
  top-margin = #10
  bottom-margin = #4
  right-margin = #12
  left-margin = #12
  indent = #0
% min-systems-per-page = 8 % this allows you to squish line spacing

  % the distance between two systems in the same score:
  system-system-spacing = #'((basic-distance . 12 ) (minimum-distance . 0) (padding . 1 ) (stretchability . 00))
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
  c1 c:maj7 f:6/c g2:7/b c:/e f1 g2 c:/e f1 g2:/b c:/e f1 g4:/b c g:/b c4~c1 c1

  d:m7 f:6 a:m d:m7 f:6 a:m c2:/e c8.:/e d16:m7~d8:m7 c g8.:/b c16~c2.
  f1 g f:/a g g
 }
melody = \relative c'{
	\set Staff.midiInstrument = #"piano"
	\time 4/4
	\key c  \major
	\clef treble
	\tempo 4 = 114 \override Score.MetronomeMark.padding = #3

	%\set melismaBusyProperties = #'()
	%\unset melismaBusyProperties
	e8. c16~c8 d8 e8. c16~c8 d8 e2 r2
	f8. d16~d8 e8 f8. d16~d8 e8 f4 g4 r4 c,
	a'4. g8~g4 e4 d4. r8 c4 c4 a'4. g8~g4 e4 d2 r2
	a'4. g8~g4 e4 d e d4 c4~c2 r2 r1
	\bar ".|:-||" \break
	\repeat volta 2 {  
		d8. d16~d8 c8 d8. e16~e4
		d8. d16~d8 e8 d8. c16~c8 b8 a2 r2
		d8. d16~d8 c8 d8 e16 e16~e4
		d8. d16~d8 e8 d8. c16~c8 b8 b8. a16~a4 r2
		
		g'8. g16~g8 g8 g8. f16~f8 e d8. e16~e4 r2 
		a,4 f'4 e c b2 r2 a4 f'4 e4 c 
	}
	\alternative{
		{   
			\set Score.repeatCommands = #'((volta "1, 3"))
 			c8. b16~b4 r2 \bar ":|."
		}
		{ 
			\set Score.repeatCommands = #'((volta "2, 4"))
			c8. b16~b4 r2 \textRepeats "DC  " \bar "||"
		}
	}
	\break
	%\sectionTitle "Bridge"
  \bar ".|:"
	e4 r8 d e e r d f8. f16~f8 e8 d( e) e4 e4 r8 d e4 r8 d f8. f16~f8 e8 d( e) e4
	f4 r8 e8 f4.  e8 f4 g f d e2 r2 r2. r8 d
	e4 r8 d e4 r8 d f8. f16~f8 e8 d( e) e4 e4 r8 d e4 r8 d f8. f16~f8 e8 d( e) e4
	f4 r4 f4 r g f f d e2 r2 r2. r8 d
	\bar ":|."
	a'8. a16~a8 b c8. b16~b8 a a8. g16~g4 r2 a8. a16~a8 b c8. (b16~b8 a ) a8. g16~g4 r2_\markup { \left-align \small "   to Verse 5" }
}
nothing = \lyricmode {}
verseone = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize

	Lord, I have heard of your fame;
	I stand in awe of your deeds, Lord.
	Re -- peat them to -- day,
	in our time make them known;
	in wrath re -- mem -- ber mer -- cy.
	
	\set stanza = "1."
	God came from Te -- man,
	Ho -- ly One from Mount Pa -- ran. 
	His glo -- ry co -- vered the hea -- vens 
	%and 
		his praise filled the earth. _ 
	
	His splen -- dor was like the sun -- rise; 
	rays flashed from his hand, 
	where his pow'r was hid -- den. 
}
versetwo = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	 \set stanza = "2."
	Plague went be -- fore him; 
	pes -- ti -- lence fol -- lowed his steps. 
	He stood, and shook the earth; 
	he looked, and made na -- tions trem -- ble. 
	
	The an -- cient moun -- tains, they crum -- bled
	%and the 
		age -- old hills col -- lapsed—
	but he mar -- ches %on 
		_ _ ev -- er.
}
versethree = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	\set stanza = "3."
	I saw the tents of Cu -- shan, they were in dis -- tress,
	dwel -- lings of Mid -- i -- an ang -- uished,
	Were you an -- gry %with the ri -- vers, 
		Lord? _
	Was your wrath a -- gainst the % streams? 
		ri -- vers?
	%Did you 
		Rage a -- gainst the sea?
	when you rode %your hor -- ses
	%and your char -- iots 
		to vic -- t'ry?
}
versefour = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	\set stanza = "4."
	%You 
		un -- cov -- ered your bow,
	you called for ma -- ny ar -- rows.
	You split the earth with % ri -- vers;
		streams
	     the moun -- tains saw you and writhed. _
	Torr -- ents of wa -- ter swept by; __ _
	the deep wa -- ters roared,
	 lift -- ed  waves on _ _ high. _
	
  % bridge
	 Sun and moon __ _ stood still in the hea -- vens
	at the glint of your fly -- ing ar -- rows,
	at the light -- ning of your flash -- ing spear.
	 In wrath you strode through  earth
	%and in ang -- er you 
		threshed the na -- tions.
	 You came out de -- li -- vered your peo -- ple,
	to save your a -- noint -- ed one.
  You
}
versefive = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	_ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	crushed the lead -- er of the land of wick-ed -- ness,
	%you 
		stripped him from _ from head to foot.
	 With his own spear _ you pierced thru his head.
	when his _ warriors _ stormed out to scat-ter us,
	gloat -- ing as though a -- bout to de-vour
	the wretch -- ed who were in hid -- ing.
	 You   tram -- pled the sea with your hor -- ses,
	churn -- ing the great __ wa -- ters.
}
versesix = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
   _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  \set stanza = "5."
   I heard and my heart pound -- ed,
	I shook at the sound;
	de -- cay crept into my bones,
	%and my 
  legs trem -- bled, yet I will wait; _
  Wait for the day of ca -- la -- m'ty
	to come on the land, the_na -- tion_in -- vad -- ing us. __ _
	
}
verseseven = \lyricmode {
	\override LyricText #'font-size = \LyricFontSize
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  \set stanza = "6."
  %Though the 
  Fig tree does not bud
	and there're no grapes on the vines,
	the o -- live crop fails _
	the fields pro -- duce __ _ no food, _
	though there're no sheep %in the pen
	and no cat -- tle %in the stalls,
	 yet I will re -- joice; % in the Lord,
	%I will be 
  joy -- ful in my _ _ God. __ _ % my Savior.

}
verseeight = \lyricmode {
  \set stanza = "last chorus" 
  The So -- v'reign Lord is my strength;
	he makes my feet like the feet of–
  the feet of a deer,
	he en -- a -- bles me to–
  to tread on the heights. __ _ _
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