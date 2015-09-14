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

# Main model 2D matrix.
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

# -----------------------------
# @description
# Build component.
#
# @param {Integer} | model sub-array reference
# @param {String}  | current component name
# @param {Array}   | components' items
# -----------------------------
buildComponent () {
    declare -a component=("${!3}")
    echo "[$(getTime)] Building $2 - ${#component[@]} items"
    for component in "${!MODEL[$1]}"
    do
        buildFile $component
    done
}

# -----------------------------
# @description
# Build individual ".scss" template.
#
# @param {String} | component name
# @return {String}
# -----------------------------
buildFile () {
cat > "_$PREFIX-$1".scss <<-EOF
//
// $PROJECT_NAME $1
// --------------------------------------------------

.$PREFIX-$1 {

}
EOF
}

# -----------------------------
# @description
# Build "main.scss" template.
#
# @return {String}
# -----------------------------
buildMain () {
    echo "[Building] main.scss"
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

# -----------------------------
# @description
# Get timestamp.
#
# @return {String} <hh:mm:ss [AP]M>
# -----------------------------
getTime() {
  date +"%r"
}

# -----------------------------
# @description
# Log error.
#
# @param {String} | error message
# @return {String}
# -----------------------------
logError () {
    echo "${1:-"Uknown Error"}" 1>&2
    exit 1
}

{
    mkdir sass || logError "[Error:$LINENO] Directory '"sass"' already exists."
} && {
    cd sass &&
    mkdir {core,elements} || logError "[Error:$LINENO] Directory '"core'|'elements"' already exists."
    buildMain
} && {
    cd core &&
    buildComponent 0 'Core' CORE[@] &&
    cd ..
} && {
    cd elements &&
    buildComponent 1 'Components' COMPONENTS[@] &&
    mkdir forms || logError "[Error:$LINENO] Directory '"forms"' already exists."
} && {
    cd forms &&
    buildComponent 2 'Forms' FORMS[@] &&
    echo "Build complete."
}