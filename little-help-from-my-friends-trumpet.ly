\language "english"
\header {
  title = "Stones"
  composer = "Barbarosa"
}
chordNames = \chordmode {
  \set chordChanges = ##f % makes chords appear everytime they're notated
  a1:m  c  g2. g8:sus g  g1 
  a1:m  c  g2. g8:sus g  g2. g8:sus g  
  e1:m c g d e:m c g d
}
melody = \relative g' {
  \key g \major
    d'8 e e4 b a | d8 c e4. d8 c d | b4 b8 a g4 r4 | r1 | \break
    d'8 e e4 b a | d8 c e4. d8 c d | b4. a8 g4. e8 | g2 r2 \bar "||" \break
    r4 b8 fs'8 (e) e  b4~b8 a8 g4 r8 e' e d b4 r8 b d8 b a g~g4 r2. \break
    r4 b8 fs'8 (e) e  b4~b8 a8 g4 r8 e' e d~d4 r4 d8 b a g~g4 r2. \break
  \bar "|."
}

\score {
  <<
   \new ChordNames {
      \chordNames
    }
    \new Voice = "one" {
      \melody
    }
  >>
  \layout {}
  \midi {}
}