#!/bin/bash

CORE=(
    "global"
    "animations"
    "fonts"
    "helpers"
    "mixins"
    "variables"
)

COMPONENTS=(
    "wrapper"
    "button"
    "icon"
    "tooltip"
    "title"
    "label"
    "overlay"
    "modal"
    "list"
    "loader"
    "menu"
    "notification"
    "pagination"
)

FORMS=(
    "form-text"
    "form-textarea"
    "form-select"
    "form-checkbox"
    "form-error"
    "form-table"
    "form-radio"
)

MODEL=(CORE[@] COMPONENTS[@] FORMS[@])

while getopts ":n:p:" opt; do
  case $opt in
    n) PROJECT_NAME="$OPTARG"
    ;;
    p) PREFIX="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

buildComponent () {
    for component in "${!MODEL[$1]}"
    do
        buildFile $component
    done
}

buildFile () {
cat > "_$PREFIX-$1".scss <<-EOF
//
// $PROJECT_NAME $1
// --------------------------------------------------

.$PREFIX-$1 {

}
EOF
}

buildMain () {
cat > main.scss <<-EOF
// core
`for component in "${CORE[@]}"
do
    echo @import '"core/_'$PREFIX-$component'.scss;"'
done`

// elements
`for component in "${COMPONENTS[@]}"
do
    echo @import '"elements/_'$PREFIX-$component'.scss;"'
done`

// forms
`for component in "${FORMS[@]}"
do
    echo @import '"elements/forms/_'$PREFIX-$component'.scss;"'
done`
EOF
}

mkdir sass
cd sass
mkdir {core,elements}
buildMain
cd core
buildComponent 0
cd ..
cd elements
buildComponent 1
mkdir forms
cd forms
buildComponent 2
