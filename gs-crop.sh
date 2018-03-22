#!/bin/bash

# https://stackoverflow.com/a/6184547
# 72 points == 1 inch == 25.4 millimeters
# A4 paper
# 595 points width  == 210 millimeters
# 842 points height == 297 millimeters

#   left edge: 24 points == 1/3 inch ~=  8.5 millimeters
#  right edge: 36 points == 1/2 inch ~= 12.7 millimeters
#    top edge: 48 points == 2/3 inch ~= 17.0 millimeters
# bottom edge: 72 points ==   1 inch ~= 25.4 millimeters

# 72p = 25.4mm
# x   = input
# x = 72p*input / 25.4

# without -l, bc operates on integers!
function mmToPt(){
    input=$1
    res=$(echo "72 * ${input} / 25.4" | bc)
    echo "$res"
}
function topPt(){
    inMm=$1
    inPt=$(mmToPt $inMm)
    res=$(echo "842 - ${inPt}" | bc)
    echo "${res}"
}
function rightPt(){
    inMm=$1
    inPt=$(mmToPt $inMm)
    res=$(echo "595 - ${inPt}" | bc)
    echo "${res}"
}


inFile=$5
outFile=$6
echo "left:$1 bottom:$2 right:$3 top:$4 '${inFile}'=>'${outFile}'"

left=$(mmToPt $1)
bottom=$(mmToPt $2)
right=$(rightPt $3)
top=$(topPt $4)

echo "left:$left bottom:$bottom right:$right top:$top"

gs -sDEVICE=pdfwrite \
   -c "[/CropBox [${left} ${bottom} ${right} ${top}]" \
   -c "/PAGES pdfmark" \
   -o ${outFile} \
   -f ${inFile}

