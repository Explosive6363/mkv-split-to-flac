#!/bin/bash

if [ $# -ne 1 ]; then
    echo "There is an anomaly in the argument."
    exit 1
fi

function clean() {
    rm -r ./tmp ./output ./wav
}

function createDir() {
  mkdir tmp output wav
}

function Init() {
  clean
  createDir
  inputFile=$1
  fileName=$(basename "$inputFile" .mkv)
}

function splitChapter() {
  mkvmerge -o ./tmp/"$fileName".mkv --split chapters:all "$inputFile"
}

function convertToFlac() {
  for f in ./tmp/*.mkv
  do
    tmpFileName=$(basename "$f" .mkv)
    ffmpeg -i "$f" -vn -acodec copy ./wav/"$tmpFileName".wav ;
  done
  for n in ./wav/*.wav
  do
    outputFileName=$(basename "$n" .wav)
    ffmpeg -i "$n" -vn -ar 44100 -ac 2 -acodec flac -f flac ./output/"$outputFileName".flac ;
  done
}

Init "$1"
splitChapter
convertToFlac