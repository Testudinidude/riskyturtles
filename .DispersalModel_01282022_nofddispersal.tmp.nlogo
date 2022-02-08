extensions [ gis ]
globals [ patch-data gis-file current-pop prev-pop sea-bird]
turtles-own [natal risk dispersal-distance-size preferred-patch wetland-name age previous-patch]
patches-own [habitat-type risk-level nest-patch landcover]
breed [repeat-breeders repeat-breeder]
breed [first-breeders first-breeder]
breed [sub-adults sub-adult]
breed [hatchlings hatchling]

to setup
  clear-all-plots
  cp ct
  ;; if no gis data are supplied, create an example map
   if patch-data = 0 and sea-bird = 0
    [ user-message "Generating preset example map"
      ask patches [
       if (pxcor < -50) or (pxcor > 50) [ set pcolor blue set habitat-type "wetland" set risk-level risk-of-wetland set landcover 30]
       if (pycor < -50) or (pycor > 50) [ set pcolor blue set habitat-type "wetland" set risk-level risk-of-wetland set landcover 30]
       if ((pxcor >= -50) and (pxcor <= -30) and (pycor >= -50) and (pycor <= 50)) or ((pxcor <= 50) and (pxcor >= 30) and (pycor >= -50) and (pycor <= 50)) [ set pcolor brown set habitat-type "upland-matrix" set risk-level risk-of-upland set landcover 100]
       if ((pycor >= -50) and (pycor <= -30) and (pxcor >= -50) and (pxcor <= 50)) or ((pycor <= 50) and (pycor >= 30) and (pxcor >= -50) and (pxcor <= 50)) [ set pcolor brown set habitat-type "upland-matrix" set risk-level risk-of-upland set landcover 100]
       if ((pxcor > -30) and (pxcor < 0)) and ((pycor < 30) and (pycor > 0)) [ set landcover 1 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor < 30) and (pxcor > 0)) and ((pycor < 30) and (pycor > 0)) [ set landcover 2 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > -30) and (pxcor < 0)) and ((pycor > -30) and (pycor < 0)) [ set landcover 3 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor < 30) and (pxcor > 0)) and ((pycor > -30) and (pycor < 0)) [ set landcover 4 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor = 0) and (pycor < 30) and (pycor > -30)) or ((pycor = 0) and (pxcor < 30) and (pxcor > -30)) [ set pcolor brown set habitat-type "upland-matrix" set risk-level risk-of-upland set landcover 100]
      ]
  ]
  if sea-bird = 1
  [ user-message "Generating seabird example"
      ask patches [
       if (pxcor < -50) [ set pcolor brown set habitat-type "wetland" set risk-level risk-of-wetland set landcover 30]
       if ((pxcor >= -50) and (pxcor <= 50))  [ set pcolor blue set habitat-type "upland-matrix" set risk-level risk-of-upland set landcover 100]
       if ((pxcor > 50) and  (pycor > 40)) [ set landcover 1 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > 50) and ((pycor <= 40) and (pycor > 20))) [ set landcover 2 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > 50) and ((pycor <= 20) and (pycor > 0))) [ set landcover 3 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > 50) and ((pycor <= 0) and (pycor > -20))) [ set landcover 4 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > 50) and ((pycor <= -20) and (pycor > -40))) [ set landcover 5 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
       if ((pxcor > 50) and (pycor <= -40)) [ set landcover 6 set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
      ]
  ]


  ;; if gis data are supplied, then read that data in. In this case, I have coded nesting patches to values < 30, wetlands to values > 30, and all other habitat to 0.
  ;;as of 03/03/2020 - now can set stability-of-risk to varying settings for risk surfaces.
  ;;In this version, numeric coding is used: 1 = yes, 2 = random, 3 = random draw
  if patch-data = 1
  [
    set gis-file gis:load-dataset patch-data
  gis:set-world-envelope-ds gis:envelope-of gis-file
    gis:apply-raster  gis-file landcover
  ask patches [
    if(stability-of-risk = 1) [
    ifelse (landcover > 30)  [ set landcover landcover set pcolor blue set habitat-type "wetland" set risk-level risk-of-wetland]
    [ ifelse (landcover > 0 ) and ( landcover < 30 ) [ set landcover landcover set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level risk-of-nestpatch]
      [ set landcover landcover set pcolor brown set habitat-type "upland-matrix" set risk-level risk-of-upland ]
    ]
    ]
      if(stability-of-risk = 2) [ifelse (landcover > 30)  [ set landcover landcover set pcolor blue set habitat-type "wetland"]
    [ ifelse (landcover > 0 ) and ( landcover < 30 ) [ set landcover landcover set pcolor yellow set habitat-type "nesting" set nest-patch landcover]
      [ set landcover landcover set pcolor brown set habitat-type "upland-matrix"]
    ]
      set risk-level random 80
      ]

    if(stability-of-risk = 3)[ ifelse (landcover > 30)  [ set landcover landcover set pcolor blue set habitat-type "wetland" set risk-level random-normal risk-of-wetland 2]
    [ ifelse (landcover > 0 ) and ( landcover < 30 ) [ set landcover landcover set pcolor yellow set habitat-type "nesting" set nest-patch landcover set risk-level random-normal risk-of-nestpatch 2]
      [ set landcover landcover set pcolor brown set habitat-type "upland-matrix" set risk-level random-normal risk-of-upland 2 ]
    ]
  ]
    ]
  ]
  ;; create turtles with random assignment to breeds. Note that repeat-breeders do not exist upon model initialization.
  ;; Aging of first-time breeders will create repeat-breeders.
  crt num-turt [
    set breed one-of (list first-breeders sub-adults hatchlings)
    set shape "turtle"
    set size 5
    setxy random-xcor random-ycor
  ]
  ;; first, put turtles in wetlands, then have them remember that wetland. then, set natal site to any patch within 120 units (chosen to make sure each turtle gets
  ;; a natal patch). Then, set risk to 0, and set dispersal-distance-size to the dispersal-distance specified.
  ask turtles [
    move-to one-of patches with [habitat-type = "wetland" ]
    set wetland-name patch-here
    set natal [ nest-patch ] of one-of patches with [ habitat-type = "nesting" ]
    set dispersal-distance-size dispersal-distance

  ]
  ;; now, make this model temporally-specific. Animals transition from one stage to another based on their age. Ages are set randomly.
  ask repeat-breeders [ set age ( random ( 12 ) + ( age-of-maturity + 1 ) ) set preferred-patch natal show-turtle set color red set shape "turtle"]
  ask hatchlings [ set age random 3 set preferred-patch natal hide-turtle set color green set shape "turtle" ]
  ask sub-adults [ set age ( random ( age-of-maturity - 4 ) + 3 ) set preferred-patch natal hide-turtle set color yellow set shape "turtle"]
  ask first-breeders [ set age age-of-maturity set preferred-patch natal show-turtle set color orange set shape "turtle"]


reset-ticks
end


to go

  ;;reset risk and current wetland preferences

  ask turtles [
    set risk 0
    set wetland-name patch-here
  ]

  ;; store previous population size, for calculation of lambda/population growth

  set prev-pop count turtles

  ;; survive based on specified survival rates. Repeat-breeders die if they are older than 70.

  ;;this is where adult risk modifications would happen

  ask hatchlings [ let hatchmort random-float 1 if hatchmort >= hatch-survival [ die ] ]

  ask sub-adults [ let submort random-float 1 if submort >= sub-survival [ die ] ]
;;;adult risk modifications to survival start - based on wetland risk. note added code for switching risk-sensitivity on and off

  ask first-breeders [
    if(risk-sensitive = 1) [set risk sum [ risk-level ] of ( neighbors )
    if (risk > risk-threshold) [ let firstbreedmort random-float 1 if firstbreedmort >= (adult-survival - adult-survival-penalty) [die]
    ]
    if (risk < risk-threshold) [ let firstbreedmort random-float 1 if firstbreedmort >= adult-survival [die]
    ]
  ]
    if (risk-sensitive = 0) [ let firstbreedmort random-float 1 if firstbreedmort >= adult-survival [die] ]
  ]

  ;; ask first-breeders  [ let firstbreedmort random-float 1 if  firstbreedmort >= adult-survival [ die ] ]

  ;;ask repeat-breeders  [ let repbreedmort random-float 1 if repbreedmort >= adult-survival [ die ] ]
  ask repeat-breeders [
    if(risk-sensitive = 1) [set risk sum [ risk-level ] of ( neighbors )
    if (risk > risk-threshold) [ let repbreedmort random-float 1 if repbreedmort >= (adult-survival - adult-survival-penalty) [die]
    ]
    if (risk < risk-threshold) [ let repbreedmort random-float 1 if repbreedmort >= adult-survival [die]
    ]
  ]
    if(risk-sensitive = 0) [ let repbreedmort random-float 1 if repbreedmort >= adult-survival [die] ]
  ]

;;;adult risk modifications to survival end - based on wetland risk
  ask repeat-breeders [ if age >= max-age [ die ] ]


  ;; age, and transition to new age classes. Hatchlings and sub-adults also move randomly at this step.

 ask turtles [
    set age age + 1
  ]

  ask first-breeders [
    if age >= ( age-of-maturity + 1 ) [
    set breed repeat-breeders set color red set shape "turtle"
  ]
  ]

ask sub-adults [
    move-to one-of patches in-radius  ( dispersal-distance-size / 10 )
    if age >= age-of-maturity [
      set breed first-breeders set color  orange set shape "turtle" show-turtle
    ]
  ]

   ask hatchlings [
    move-to one-of patches in-radius ( dispersal-distance-size / 20 )
    if age >= 2 [ set breed sub-adults set color yellow set shape "turtle" ]
    hide-turtle
    ]


  ;;  repeat-breeders first consider where they nested previously. They then face any patch with that patch ID, and move forward an amount equal to dispersal-distance-size.
  ;;  Animals then move to the closest nest-patch that has their preferred patch ID. They then quantify risk within the neighborhood around that nesting patch,
  ;;  and make behavioral decisions based on this risk level. If risk is greater than their tolerance of risk (risk-threshold) and their current preferred patch is not where
  ;;  they were born (their natal patch), they set next year's preference to their natal patch; this makes the assumption that repeat-breeders remember where natal patches are, which is
  ;;  likely realistic, given Reid et al. (2016b). If risk is greater than risk tolerance, and animals currently prefer their natal patch, they decide on a random nest patch
  ;;  within their home range size. If risk is less than risk tolerance, they just keep their preferred patch the same.

   ask repeat-breeders [
    show-turtle
    let my-nest-patch preferred-patch
    set previous-patch preferred-patch
    move-to one-of patches with [ nest-patch = my-nest-patch ]
    set risk sum [ risk-level ] of ( neighbors )
     if (risk > risk-threshold) and ( preferred-patch != natal ) [
      set preferred-patch natal
  ]
    if (risk > risk-threshold) and ( preferred-patch = natal ) [
      set preferred-patch [ nest-patch ] of one-of patches with [ habitat-type = "nesting" ] in-radius dispersal-distance-size

  ]
    if (risk < risk-threshold ) [
      set preferred-patch [ nest-patch ] of one-of patches with [ habitat-type = "nesting" ] in-radius 1
  ]
;; random probability of a risk leading to unexpected mortality during nest excursions - only included if risk-sensitive adult survival is switched on
    if(risk-sensitive = 1) [set risk sum [ risk-level ] of ( neighbors )
    if (risk > risk-threshold) [ let repnestrisk random-float 1 if repnestrisk <= nest-excursion-disaster-probability [die]
    ]
  ]


  ;;  nest success is then drawn from 1 to 100 randomly. If there are fewer turtles than carrying capacity (K) and the random number for nest success is less than
  ;;  49 (representing the 49% nest survival rate calculated for SWA, Reid et al. [2016a]) then 8 hatchlings are born. If there are more turtles than K, then no hatchlings
  ;;  are born.
  ;; On 03/03/2020, using numeric coding for different versions of nest success. 1= base, 2 = risk sensitive, 3 = empirical

    ;;base settings for nest survival
    if (nest-success-mode = 1)[
    let nestsuccess random-float 1
    if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
;; nest survival based on risk
    if (nest-success-mode = 2) [
      let nestsuccess random-float 1
      if (risk > risk-threshold) [ if nestsuccess <= (nest-survival * nest-risk-penalty)  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
    if (risk < risk-threshold) [ if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
  ]



    ifelse (nest-success-mode = 3) and (patch-data != 0 ) [
      let nestsuccess random-float 1
if (previous-patch = 1) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 2) [if nestsuccess <= 25  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle]] ]]
  if (previous-patch = 3) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 4) [if nestsuccess <= 15  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 5) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]
  if (previous-patch = 6) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 7) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 8) [if nestsuccess <= 75  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 9) [if nestsuccess <= 67  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 10) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 11) [if nestsuccess <= 67  [ ifelse count turtles <= K [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 12) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 13) [if nestsuccess <= 50  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 14) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]
  if (previous-patch = 15) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 16) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 17) [if nestsuccess <= 100  [ ifelse count turtles <= K [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]

      ]
    [
      let nestsuccess random-float 1
    if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]

    move-to wetland-name
  ]




  ;; rules for first-breeders are different than for repeat-breeders. They always try to get to natal patches (again, where they were born) if they can, but imperfect
  ;; perception of natal habitat prevents this. First, the probability of correctly finding natal habitat is assigned a random decimal between 0 and 1. Then, if error
  ;; is greater than the defined natal-error-rate, then they move to their natal patch to nest. If the probability of correctly finding natal habitat is less
  ;; than the natal-error-rate, then they randomly search an area equivalent to 3 times their dispersal-distance-size for another habitat patch to use, and nest there.
  ask first-breeders [
    show-turtle
    let natalcorrect random-float 1
      if (natalcorrect > natal-error-rate) [
      set preferred-patch natal
      let my-nest-patch preferred-patch
      move-to one-of patches with [ nest-patch = my-nest-patch ]
  ]

    if (natalcorrect < natal-error-rate) [
      let my-nest-patch preferred-patch
      move-to one-of patches with [ habitat-type = "nesting" ]
      set preferred-patch [ nest-patch ] of one-of patches with [ habitat-type = "nesting" ] in-radius 1
  ]
    ;;code for risk to first-breeders goes here
    if(risk-sensitive = 1) [set risk sum [ risk-level ] of ( neighbors )
    if (risk > risk-threshold) [ let firstnestrisk random-float 1 if firstnestrisk <= nest-excursion-disaster-probability [die]
    ]
  ]
  ;;  nest success is then drawn from 1 to 100 randomly. If there are fewer turtles than carrying capacity (K) and the random number for nest success is less than
  ;;  49 (representing the 49% nest survival rate calculated for SWA, Reid et al. [2016a]) then 8 hatchlings are born. If there are more turtles than K, then no
  ;;  hatchlings are born.
    if (nest-success-mode = 1)[
    let nestsuccess random-float 1
    if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
;; nest survival based on risk
    if (nest-success-mode = 2) [
      let nestsuccess random-float 1
      if (risk > risk-threshold) [ if nestsuccess <= (nest-survival * nest-risk-penalty)  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
    if (risk < risk-threshold) [ if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]
  ]
  ifelse (nest-success-mode = 3) and (patch-data != 0 ) [
      let nestsuccess random-float 1
if (previous-patch = 1) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 2) [if nestsuccess <= 25  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle]] ]]
  if (previous-patch = 3) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 4) [if nestsuccess <= 15  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 5) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]
  if (previous-patch = 6) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 7) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 8) [if nestsuccess <= 75  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 9) [if nestsuccess <= 67  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 10) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 11) [if nestsuccess <= 67  [ ifelse count turtles <= K [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 12) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 13) [if nestsuccess <= 50  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 14) [if nestsuccess <= 100  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]
  if (previous-patch = 15) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]]]
  if (previous-patch = 16) [if nestsuccess <= 0  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]]
  if (previous-patch = 17) [if nestsuccess <= 100  [ ifelse count turtles <= K [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ]  ]]

      ]
    [
      let nestsuccess random-float 1
    if nestsuccess <= nest-survival  [ ifelse count turtles <= K  [ hatch-hatchlings clutch-size [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] [ hatch-hatchlings 0 [ move-to wetland-name set color green set shape "turtle" set age 0 set preferred-patch natal hide-turtle] ] ]
    ]

    move-to wetland-name
  ]


  set current-pop count turtles

if(stability-of-risk = 3) [ask patches
    [ ifelse (landcover > 30)  [ set risk-level random-normal risk-of-wetland 2]
    [ ifelse (landcover > 0 ) and ( landcover < 30 ) [  set risk-level random-normal risk-of-nestpatch 2]
      [ set risk-level random-normal risk-of-upland 2 ]
    ]
  ]
  ]
 if(stability-of-risk = 2) [ask patches
    [
      set risk-level random 80
    ]
  ]

tick
end

;; code to load own patch data, drawn from the simulatingcomplexity wordpress (see credits and references section in info tab). Make sure that the map follows
;; conventions defined in the info tab.


to load-own-patch-data
  let file user-file

  if ( file != false )
  [
    set patch-data []
    file-open file
    set patch-data file
    user-message "File loading complete!"
    file-close

  ]
end
to load-set-patch-data

  let file "mergednestingareaswater_clipped.asc"
  set patch-data []
  set patch-data file
end

to set-sea-bird
  set sea-bird 1
end

to set-defaults
  set num-turt 200
  set dispersal-distance 60
  set K 5000
  set adult-survival 0.94
  set sub-survival 0.85
  set hatch-survival 0.60
  set risk-of-upland 10
  set risk-of-nestpatch 5
  set risk-of-wetland 1
  set risk-threshold 65
  set natal-error-rate 0.2
  set max-age 70
  set age-of-maturity 17
  set-risk-defaults
  set nest-excursion-disaster-probability 0.05
  set clutch-size 8
end
to set-seabird-defaults
  set num-turt 200
  set dispersal-distance 60
  set K 5000
  set adult-survival 0.85
  set sub-survival ( 0.88 * adult-survival )
  set hatch-survival ( 0.70 * adult-survival )
  set risk-of-upland 5
  set risk-of-nestpatch 10
  set risk-of-wetland 1
  set risk-threshold 65
  set natal-error-rate 0.
  set max-age 10
  set age-of-maturity 3
  set-risk-defaults
  set nest-excursion-disaster-probability 0.05
  set clutch-size 2
end

to set-risk-defaults
  set risk-sensitive 0
  set nest-success-mode 3
  set stability-of-risk 1
end
;; code to clear the patch data from netlogo memory.

to clear-gis
  set patch-data 0
  set gis-file 0
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
821
622
-1
-1
4.9835
1
10
1
1
1
0
0
0
1
-60
60
-60
60
0
0
1
ticks
30.0

SLIDER
21
234
193
267
num-turt
num-turt
0
300
200.0
1
1
NIL
HORIZONTAL

BUTTON
25
12
88
45
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
117
13
180
46
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
24
51
181
84
load your own patches
load-own-patch-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
24
129
181
162
clear loaded map
clear-gis
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
706
193
739
risk-threshold
risk-threshold
0
100
65.0
1
1
NIL
HORIZONTAL

PLOT
824
10
1225
160
Age Structure
Time
# Turtles
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Repeated Breeders" 1.0 0 -2674135 true "" "plot count repeat-breeders"
"First-Time Breeders" 1.0 0 -955883 true "" "plot count first-breeders"
"Sub-Adults" 1.0 0 -4539718 true "" "plot count sub-adults"
"Hatchlings" 1.0 0 -16777216 true "" "plot count hatchlings"

SLIDER
21
309
193
342
K
K
5000
20000
5000.0
100
1
NIL
HORIZONTAL

MONITOR
826
167
930
212
breeding dispersal
( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )
4
1
11

MONITOR
945
168
1035
213
natal dispersal
( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )
4
1
11

SLIDER
21
752
193
785
natal-error-rate
natal-error-rate
0
1
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
22
592
194
625
risk-of-upland
risk-of-upland
0
20
5.0
1
1
NIL
HORIZONTAL

SLIDER
22
633
194
666
risk-of-nestpatch
risk-of-nestpatch
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
21
670
193
703
risk-of-wetland
risk-of-wetland
0
20
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
24
738
174
756
Controls on natal dispersal\n
11
0.0
1

TEXTBOX
26
570
176
588
Controls on breeding dispersal\n
11
0.0
1

TEXTBOX
27
219
225
247
Controls on demography/behavior
11
0.0
1

MONITOR
1062
168
1195
213
Ratio Natal:Breeding
( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )
2
1
11

SLIDER
19
384
191
417
adult-survival
adult-survival
0
1
0.85
0.01
1
NIL
HORIZONTAL

SLIDER
20
421
192
454
sub-survival
sub-survival
0
1
0.748
0.01
1
NIL
HORIZONTAL

SLIDER
21
457
193
490
hatch-survival
hatch-survival
0
1
0.595
0.01
1
NIL
HORIZONTAL

PLOT
826
386
1229
536
Frequencies of patch preferences
NIL
NIL
0.0
20.0
0.0
50.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [ preferred-patch ] of ( turtle-set repeat-breeders first-breeders )"

PLOT
827
222
1228
372
lambda
NIL
NIL
0.0
2.0
0.0
2.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if ( current-pop != 0 ) and ( prev-pop != 0 ) [ plot ( current-pop / prev-pop ) ]"
"pen-1" 1.0 0 -2674135 true "" "plot 1"

BUTTON
24
87
178
120
Load provided patch data
load-set-patch-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
26
173
180
206
Default Parameters
set-defaults
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
214
676
428
709
nest-excursion-disaster-probability
nest-excursion-disaster-probability
0
1
0.05
0.05
1
NIL
HORIZONTAL

CHOOSER
677
631
790
676
nest-success-mode
nest-success-mode
1 2 3
2

SLIDER
613
724
789
757
nest-risk-penalty
nest-risk-penalty
0
1
0.5
0.1
1
NIL
HORIZONTAL

CHOOSER
214
626
306
671
stability-of-risk
stability-of-risk
1 2 3
0

CHOOSER
312
625
404
670
risk-sensitive
risk-sensitive
0 1
0

SLIDER
614
683
789
716
adult-survival-penalty
adult-survival-penalty
0
0.05
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
21
345
193
378
nest-survival
nest-survival
0
1
0.42
0.01
1
NIL
HORIZONTAL

SLIDER
21
530
193
563
age-of-maturity
age-of-maturity
0
100
3.0
1
1
NIL
HORIZONTAL

SLIDER
21
494
193
527
max-age
max-age
0
200
10.0
1
1
NIL
HORIZONTAL

SLIDER
21
271
193
304
dispersal-distance
dispersal-distance
0
60
60.0
1
1
NIL
HORIZONTAL

BUTTON
444
696
565
729
seabird example
set-sea-bird
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
494
643
614
676
seabird defaults
set-seabird-defaults
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
280
760
452
793
clutch-size
clutch-size
0
20
2.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

Turtles often return to the same areas where they were born to nest (natal philopatry), and generally return to the same areas every time they nest (nest site fidelity). However, recent research has suggested that this is not always the case. Sometimes, individuals never return to the area where they are born (often called natal dispersal); other times, turtles seem to switch nesting areas between years (often called breeding dispersal). 

This model explores potential behavioral mechanisms that could lead a particular turtle species, the Blanding's Turtle (Emydoidea blandingii) to deviate from expected patterns of natal philopatry and nest site fidelity, using calculated rates of natal and breeding dispersal at Sandhill Wildlife Area (SWA) in Wood County, WI from Reid et al. (2016b) as a real-world pattern to guide inquiry and exploration. Although designed with this site in mind, the model can readily incorporate other landscapes, provided that the user has GIS data. 

In addition, this model also allows exploration of emergent relationships between dispersal rates, survival rates, and population growth rates.  

## HOW IT WORKS

Natal and breeding dispersal emerge via two simple behavioral mechanisms: avoidance of risky nesting areas by experienced breeders, and imperfect perception of natal habitat by inexperienced, first-time breeders. 

In the case of risk avoidance, users can control how risky the landscape is, ranging from low values to high values for three different habitat patches (nesting areas, upland habitat, and wetlands). Users can also control the threshold for nesting area risk that experienced breeders use for behavioral decisions. Experienced breeders move to nesting areas, and then perceive the amount of risk in the landscape around that nesting area. If the sum of risk values around that nesting area is greater than the set risk threshold, that turtle chooses a new site for the following year that is within their current home range size.

In the case of imperfect perception of natal habitat, all individuals have a stored natal location that describes where they were born. For the first three years of an animal's status as a breeding individual (from age 17-20), animals try to reach natal habitat to nest, as this is the only nesting habitat that they know about. Users can set a probability of incorrect discrimination of natal habitat, representing the fact that first-time breeders are relatively inexperienced at navigating the landscape to get to their natal habitat. If an animal is unable to find its natal habitat, it selects a random nesting patch within its current home range size, and nests there. 

## HOW TO USE IT

First, users must decide upon a map to use for the model. This can be the map supplied with this model (mergednestingareaswater_clipped.asc), which is based on Reid et al. (2016a,b). However, if the user has a landscape map, the same basic procedure applies. Click LOAD YOUR OWN PATCHES and navigate to the map of choice. Note that maps must follow several criteria:

1) They must be in .asc format, with an associated .prj.
2) Nesting patches should be assigned values ranging from 1-29, with unique numbers assigned to discrete patches. '
3) Upland habitat should be assigned a 0. 
4) Wetland habitat can take any value greater than 30. 

As long as the map fulfills these criteria, the model will operate correctly. Note that users may also click the CLEAR LOADED MAP button to remove the current loaded map from netlogo. Don't worry, this does not delete the map from memory - it only removes it from the netlogo model! 

Once the map is loaded, users should decide how many turtles they would like to include in the model (controlled by the NUM-TURT slider), the home range of turtles (indicating the maximum movement distance, controlled by the HOME-RANGE slider) and the carrying capacity of the population, which sets an upper limit on how many turtles can exist on the landscape (controlled by the K slider). Users can also vary survival rates (ADULT-SURVIVAL, SUB-SURVIVAL, and HATCH-SURVIVAL) as they choose, although default settings best reflect the study site used in Reid et al. (2016a). Users should also decide how much risk should be assigned to the three habitat types in the model (controlled by 3 sliders: RISK-OF-UPLAND, RISK-OF-NESTPATCH, and RISK-OF-WETLAND). 

Once these decisions have been made, click SETUP. This places NUM-TURT turtles randomly within wetlands, with randomized assignments as hatchlings (ages 0-2), sub-adults (ages 3-16), or first-time breeders (ages 17-20). Each turtle is randomly assigned a natal nesting patch upon placement. In addition, risk values for the landscape are placed by the SETUP command as well. 

Once SETUP has been clicked, users should choose their preferred settings for risk thresholds for experienced, repeated breeders (controlled by the RISK-THRESHOLD slider) and the degree of error associated with inexperienced breeders' discrimination of natal habitat (controlled by the NATAL-ERROR slider). 

Once these settings have been set as desired, click GO. Turtles will move around the landscape, and the following events take place in order: turtles survive or die, turtles age and transition to new stages, breeders move to nesting areas and set their future nesting preferences, and hatchlings emerge from nests (at a lower rate if number of turtles > K). Plots of how many animals are in each stage,current rates of natal and breeding dispersal, lambda (or population growth rate, where values > 1 indicate a growing population and values < 1 indicate a declining population), and nest patch preferences are updated at each tick. In addition, current rates of natal and breeding dispersal, and the ratio between the two, are printed in monitors below the plots.

## THINGS TO NOTICE

1) Note that sub-adults and hatchlings are hidden by the model - this is primarily to avoid unnecessarily cluttering the screen. 

2) Calculations of risk are based only on adjacent neighbors. This does not take into account risk accumulated during the trip to nesting patches.

3) Animals can technically move further than their home range in a given time period. Animals move the equivalent of their home range size, then move to the closest nesting patch that matches their preferences. This essentially assumes that repeat-breeders can always get to their preferred nesting patch, which may not be accurate in some cases.

4) This model is analogous to a pre-breeding census in population biology parlence. Individuals survive, then age, then breed (if applicable), so all individuals are at least 1 year old before reproduction occurs in each time step.

5) Turtles in this model are female-only for two reasons: first, this is a common convention in many population models that makes calculations easier; and second, the emphasis on nesting behavior in this model made representing males explicitly in-model unnecesssary. 


## THINGS TO TRY

1) Try setting RISK-THRESHOLD to its highest value, and NATAL-ERROR to its highest value. This represents a behavioral strategy where animals have substantial difficulty in finding natal habitat due to inexperience, but are relatively unlikely to respond to risk. This is a perfectly plausible hypothesized pattern of behavior; since turtles have shells, they are probably less likely to worry about predators than many other vertebrate groups.

2) Try setting RISK-THRESHOLD to 1, and NATAL-ERROR to 0. This represents another plausible behavioral strategy, where animals can always find their natal habitat but are fairly worried about risk levels when they nest. This also makes a lot of sense given turtle life history. Population persistence is tied to adult survival in most turtle species; as a result, reproductive effort in any given year should be weighed towards maximizing adult survival at the expense of nest survival.

3) In Reid et al. (2016b), natal dispersal rates ranged from 0.08-0.11, whereas breeding dispersal rates ranged from 0.001 to 0.05. This means that the ratio of natal:breeding can range anywhere from 1.6:1 to 110:1, but with the most probable values anywhere between 2:1 and 4:1. Try adjusting RISK-THRESHOLD and NATAL-ERROR to fit these criteria. I was able to find values that roughly matched these criteria at default values of landscape risk (10, 5, and 1 for upland, nesting, and wetland, respectively), RISK-THRESHOLD=65, and NATAL-ERROR = 0.2. This suggests that some combination of imperfect discrimination of natal habitats and risk avoidance is probably required to reproduce values calculated at this site.

4) This model can also be used to simulate habitat loss effects on dispersal rates. A couple obvious directions for this are given below:

a) If you are familiar with GIS, try removing some nesting patches (by setting some patches with values 1-29 to 0) to represent habitat loss. Does this have an effect on dispersal estimates?

b) Try adjusting the relative risk levels on the landscape while keeping other inputs (particularly RISK-THRESHOLD and NATAL-ERROR) constant. In particular, try doubling RISK-OF-UPLAND from 10 to 20, as this may indicate either a particularly active year for a predator, the introduction of a more threatening predator, or the removal of habitat in upland patches that could be used for turtles trying to hide. What does this do to dispersal rates? 

5) Try adjusting other inputs that are more related to turtle population demography and natural history - namely K and HOME-RANGE-SIZE - and see if those have an effect on dispersal rates.

6) While secondary to the point of the model, try slightly adjusting survival rates. You should notice that very, very slight changes in adult survival have large impacts on population growth rate (lambda), which is a common feature of most turtle life histories. 

## EXTENDING THE MODEL

1) Ideally, turtles would take into account risk experienced over the entire trip to a nesting area when deciding to switch preferences or not (rather than simply taking into account risk around nesting patches). This would be relatively complicated, and would likely require creating links between starting wetlands and turtles, and summing risk values along that link. 

2) The exact mechanism expected to produce relative levels of habitat risk for turtles is assumed to be predators in this model, and predator activity levels/densities are not represented explicitly. Furthermore, all patches of a particular habitat type always have the same levels of risk. Future extensions could represent predator foraging and movement behaviors, feed that into patch-specific estimates of risk, and use that in calculations of risk levels experienced by turtles.

3) While natal discrimination errors are assumed to drive natal dispersal, it is not currently known how differences in nest survival rates between nesting patches could also impact patterns of natal and breeding dispersal. A further extension could involve setting nest survival rates on a per patch basis, and seeing how this impacts dispersal rates. 

4) Feeding in additional maps that describe risk levels or nest success rates would be relatively easy to accomplish in future model versions.


5) Density dependence in this model only affects reproductive rates. It would be worthwhile to include multiple forms of density dependence in the model.

6) Demographic parameters are taken from Reid et al. (2016a) and an ongoing mark-recapture effort at Sandhill Wildlife Area in Wood County, WI. 

7) Initial model runs suggest that patch shape and length seems to also affect the probability of turtles using that patch. It would be an intriguing extension to explore
the role of patch-level metrics in driving patch preferences, as this may suggest that patch preferences are less driven by mechanistic behavioral decisions and more by landscape configuration. 

## NETLOGO FEATURES

This model uses the netlogo gis extension to read in gis map. There are many possibilities for improving upon the model by feeding in maps that describe predation risk or nest survival rates.

## RELATED MODELS

Although no other models appear to explore the phenomenon in this model, numerous models have explored how individual habitat selection rules create patterns of animal distribution, dispersal,  and population growth. Several examples are provided below.

Baggio, Jacopo, Salau, Kehinde, Schoon, Michael, Janssen, Marco (2014, January 20). “Managing Connectivity: insights from modelling species interactions accross multiple scales in an idealized landscape” (Version 1.2.0). CoMSES Computational Model Library. Retrieved from: https://www.comses.net/codebases/3241/releases/1.2.0/

Moritz, Mark, Hamilton, Ian M, Yoak, Andrew, Pi, Hongyang, Cronley, Jeff, Maddock, Paul (2018, January 06). “Ideal Free Distribution of Mobile Pastoralists in the Logone Floodplain, Cameroon” (Version 1.4.0). CoMSES Computational Model Library. Retrieved from: https://www.comses.net/codebases/4242/releases/1.4.0/

## CREDITS AND REFERENCES

This work was funded in part by a USDA Hatch Act to M. Z. Peery, and represents part of an ongoing project aimed at understanding effects of environmental change on Wisconsin turtle species. More information can be found here: http://labs.russell.wisc.edu/peery/turtle-project/

Sources cited:

Reid, B. N., R. P. Thiel, and M. Z. Peery. 2016a. Population dynamics of endangered Blanding's turtles in a restored area. Journal of Wildlife Management 80: 553–562. 

Reid, B. N., R. P. Thiel, P. J. Palsbøll, and M. Z. Peery. 2016b. Linking Genetic Kinship and Demographic Analyses to Characterize Dispersal: Methods and Application to Blanding’s Turtle. Journal of Heredity 107: 603–614.

Simulating complexity wordpress: 

https://simulatingcomplexity.wordpress.com/2014/08/20/turtles-in-space-integrating-gis-and-netlogo/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Varying Demography" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="30"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <steppedValueSet variable="hatch-survival" first="55" step="1" last="60"/>
    <steppedValueSet variable="sub-survival" first="78" step="1" last="83"/>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <steppedValueSet variable="adult-survival" first="89" step="1" last="94"/>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Varying risk threshold" repetitions="5" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="150"/>
    <metric>count hatchlings</metric>
    <metric>count sub-adults</metric>
    <metric>count first-breeders</metric>
    <metric>count repeat-breeders</metric>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="25"/>
      <value value="65"/>
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="86"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="varying natal error" repetitions="10" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="86"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <steppedValueSet variable="natal-error-rate" first="0.1" step="0.1" last="1"/>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="varying risk and natal error" repetitions="2" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="risk-threshold" first="1" step="20" last="100"/>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <steppedValueSet variable="natal-error-rate" first="0.1" step="0.1" last="1"/>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Varying K and Risk Threshold" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="risk-threshold" first="1" step="20" last="100"/>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="K" first="5000" step="1000" last="20000"/>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Varying Home Range" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <steppedValueSet variable="home-range" first="1" step="5" last="60"/>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="20000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Varying Num Turtles" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="20000"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-turt" first="1" step="25" last="200"/>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Varying K" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="K" first="1" step="1000" last="20000"/>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Risk Sensitivity" repetitions="25" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <enumeratedValueSet variable="rep-nest-survival-penalty">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="first-nest-survival-penalty">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-risk-penalty">
      <value value="42"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="nest success mode and risk sensitivity" repetitions="5" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>( ( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders ) ) / ( ( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders ) )</metric>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <steppedValueSet variable="rep-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="first-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;base&quot;"/>
      <value value="&quot;risk sensitive&quot;"/>
      <value value="&quot;empirical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nest-risk-penalty" first="0" step="25" last="100"/>
  </experiment>
  <experiment name="Nest Survival - Risk Sensitive True" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <steppedValueSet variable="rep-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="first-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;risk sensitive&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nest-risk-penalty" first="0" step="25" last="100"/>
  </experiment>
  <experiment name="Nest Survivial - Risk Sensitive False" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <steppedValueSet variable="rep-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="first-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;risk sensitive&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nest-risk-penalty" first="0" step="25" last="100"/>
  </experiment>
  <experiment name="Nest Survival - Empircal True" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <steppedValueSet variable="rep-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="first-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;empirical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nest-risk-penalty" first="0" step="25" last="100"/>
  </experiment>
  <experiment name="Nest Survival - Empirical False" repetitions="1" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <steppedValueSet variable="rep-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="home-range">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="first-nest-survival-penalty" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="&quot;empirical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nest-risk-penalty" first="0" step="25" last="100"/>
  </experiment>
  <experiment name="experiment" repetitions="5" runMetricsEveryStep="true">
    <setup>clear-gis
load-set-patch-data
setup</setup>
    <go>go</go>
    <timeLimit steps="300"/>
    <metric>( count repeat-breeders with [ preferred-patch != previous-patch ] ) / ( count repeat-breeders )</metric>
    <metric>( count first-breeders with [ preferred-patch != natal ] ) /( count first-breeders )</metric>
    <metric>count turtles with [preferred-patch = 1]</metric>
    <metric>count turtles with [preferred-patch = 2]</metric>
    <metric>count turtles with [preferred-patch = 3]</metric>
    <metric>count turtles with [preferred-patch = 4]</metric>
    <metric>count turtles with [preferred-patch = 5]</metric>
    <metric>count turtles with [preferred-patch = 6]</metric>
    <metric>count turtles with [preferred-patch = 7]</metric>
    <metric>count turtles with [preferred-patch = 8]</metric>
    <metric>count turtles with [preferred-patch = 9]</metric>
    <metric>count turtles with [preferred-patch = 10]</metric>
    <metric>count turtles with [preferred-patch = 11]</metric>
    <metric>count turtles with [preferred-patch = 12]</metric>
    <metric>count turtles with [preferred-patch = 13]</metric>
    <metric>count turtles with [preferred-patch = 14]</metric>
    <metric>count turtles with [preferred-patch = 15]</metric>
    <metric>count turtles with [preferred-patch = 16]</metric>
    <metric>count turtles with [preferred-patch = 17]</metric>
    <enumeratedValueSet variable="risk-threshold">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability-of-risk">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival">
      <value value="0.94"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-turt">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="age-of-maturity">
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-distance">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-wetland">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-success-mode">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hatch-survival">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sub-survival">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="adult-survival-penalty">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-survival">
      <value value="0.42"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-sensitive">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="natal-error-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-upland">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-age">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="risk-of-nestpatch">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-excursion-disaster-probability">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-risk-penalty">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
