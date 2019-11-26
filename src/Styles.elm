port module Styles exposing (..)

import Element exposing ( rgba, padding )
import Element.Font as Font
import Element.Border as Border


-- COLORS
blue = Element.rgb255 100 100 238

red = Element.rgb255 238 100 100

gray = Element.rgb255 155 155 155

green = Element.rgb255 100 210 100

white = Element.rgb255 255 255 255


-- COMPONENT STYLES

heading1 = [ Font.size 24
  , Font.semiBold
  , Font.family [ Font.typeface "Helvetica", Font.sansSerif ]
  ]  


actionX = [ Font.color red 
  , Font.family [ Font.typeface "Helvetica", Font.sansSerif ]
  , Font.size 14 ]

sortButton =
  [ padding 6
  , Border.width 3
  , Border.color red ]

standardButton =
  [ padding 4
  , Border.width 2
  , Border.color gray ]
