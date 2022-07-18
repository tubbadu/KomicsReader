#!/usr/bin/bash

cd /home/tubbadu/code/Kirigami/KomicsReader/
cmake -B build/ . && cmake --build build/ && ./build/bin/KomicsReader "/home/tubbadu/Video/fumetti nanetta/Itou Junji Kyoufu Manga Collection Vol.011 Ch.005 The Supernatural Transfer Student [KissManga].cbz"
