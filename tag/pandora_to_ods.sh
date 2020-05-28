#!/bin/bash

perl -i -pe "
    s/\tMODE=/\t/g;
    s/(con|imp)\|PERS.=/\1\t\t/g;
    s/\tPERS.=/\t\t\t/g;
    s/\tNOMB.=/\t\t\t\t/g;
    s/\tDEGRE=/\t\t\t\t\t\t\t/g;
    s/\|[\w\.]+?\=/\t/g;
    s/MORPH\=empty//g;
    " *.TSV 
    
