#!/bin/bash

 od -An -tu1  -vw1 $1 |
 awk '

 BEGIN {
     pc = 1536
 }

 {
     if( s == 0 ) {
         #printf "\n; $%04x", pc
         printf "\n dcb %3d", $1;
         s=15;
     } else {
         s=s-1;
         printf ",%3d", $1;
     }
     pc = pc + 1
 }
 
 END {
     printf "\n"
 } '

