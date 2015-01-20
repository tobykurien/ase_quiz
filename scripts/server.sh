#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -cp bin:libs/* -Denvironment=production za.org.ase.quiz.Main
