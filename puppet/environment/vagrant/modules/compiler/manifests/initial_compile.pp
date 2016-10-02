### Note: the prefix 'compiler::::', corresponds to a puppet convention:
###
###       https://github.com/jeff1evesque/machine-learning/issues/2349
###
class compiler::initial_compile {
    ## local variables
    $hiera_general   = hiera('general')
    $root_dir        = $hiera_general['root']
    $environment     = $hiera_general['environment']
    $dev_env_path    = "${root_dir}/puppet/environment/${environment}"

    $sources  = [
        'jsx',
        'img',
        'scss',
        'js'
    ]

    $sources.each |String $source| {
        ## variables
        $check_files = "ls -A ${root_dir}/src/${source}/"
        $touch_files = "touch ${root_dir}/src/${source}/*"

        ## touch source: ensure initial build compiles every source file.
        #
        #  @touch, changes the modification time to the current system time.
        #
        #  Note: the current inotifywait implementation watches close_write,
        #        move, and create. However, the source files will already exist
        #        before this 'inotifywait', since the '/vagrant' directory will
        #        already have been mounted on the initial build.
        #
        #  Note: every 'command' implementation checks if directory is
        #        nonempty, then touch all files in the directory, respectively.
        #
        exec { "touch-${source}-files":
            command  => $touch_files,
            onlyif   => $check_files,
            provider => shell,
        }
    }
}