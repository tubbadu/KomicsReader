#!/usr/bin/bash

cd /home/tubbadu/code/Kirigami/KomicsReader/
cmake -B build/ . && cmake --build build/ && ./build/bin/KomicsReader "/home/tubbadu/Scaricati/Junji Ito/Junji Ito - Gyo + Bonus.cbr"
