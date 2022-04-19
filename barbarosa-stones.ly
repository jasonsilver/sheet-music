\header {
  title = "Stones"
  composer = "Barbarosa"
}
chordNames = \chordmode {
  \set chordChanges = ##f % makes chords appear everytime they're notated
  a1:m  c  g2. g8:sus g  g1 
  a1:m  c  g2. g8:sus g  g2. g8:sus g  

}
melody = \relative c'' {
    d8 e e4 b a | d8 c e4. d8 c d | b4 b8 a g4 r4 | r1 | \break
    d8 e e4 b a | d8 c e4. d8 c d | b4. a8 g4. e8 | g2 r2 
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