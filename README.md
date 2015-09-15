## SASS structure builder
Shell

#### Usage
````shell
    cd <dir>
    build-sass.sh -n '<project_name>' -p '<file_prefix>'
````
where `-n` argument represents project name<br>
where `-p` argument represents file prefix

> Output structure:

    |-- sass/
    |   |-- core/
    |       |-- _<prefix>-<core_component>.scss
    |   |-- elements/
    |       |-- forms/
    |           |-- _<prefix>-<form_element>.scss
    |       |-- _<prefix>-<element>.scss
    |   |-- main.scss

> Output main.scss:

````sass
    // core
    @import "core/_<prefix>-<core_component>.scss;"

    // elements
    @import "elements/_<prefix>-<element>.scss;"

    // forms
    @import "elements/forms/_<prefix>-<form-element>.scss;"
````
> Output _file.scss:

````sass
    //
    // <project_name> <component>
    // --------------------------------------------------

    .<prefix>-<component> {

    }
````

====

#### Troubleshooting:

> *build-sass: command not found.*

**Solutions**:

 - Set script as executable

    ````shell
        cd <dir>
        chmod +x build.sass.sh
    ````

 - Run script via interpreter

     Windows/Linux/OSX

     ````shell
        bash </path/to/script> OR
        sh </path/to/script>
    ````

*Notice*: .sh cannot be run natively via Windows command prompt.