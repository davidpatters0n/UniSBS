#!/usr/bin/env bash
find . -not -path '*.git*' -and -type f -exec sed -i "s/$1/$2/g" {} +
find . -not -path '*.git*' -and -type f -exec rename $1 $2 {} +
