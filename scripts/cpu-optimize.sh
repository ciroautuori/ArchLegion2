#!/bin/bash
# CPU Performance Tweaks
cpupower frequency-set -g performance
cpupower frequency-set --max 4.2GHz
undervolt --cpu -125 --cache -125 --gpu -80
echo "CPU ottimizzata per prestazioni massime"
