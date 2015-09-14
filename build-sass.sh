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

buildCore () {
    for component in "${CORE[@]}"
    do
        buildFile $component
    done
}

buildElements () {
    for component in "${COMPONENTS[@]}"
    do
        buildFile $component
    done
}

buildForms () {
    for component in "${FORMS[@]}"
    do
        buildFile $component
    done
}

buildFile () {
    component=$1
cat > "_$PREFIX-$component".scss <<-EOF
//
// $PROJECT_NAME $component
// --------------------------------------------------

.$PREFIX-$component {

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
buildCore
cd ..
cd elements
buildElements
mkdir forms
cd forms
buildForms
