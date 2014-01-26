module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-ngmin'
    grunt.loadNpmTasks 'grunt-html2js'

    mountFolder = (connect, dir) ->
        connect.static require('path').resolve(dir)

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        thirdParty: [
            'bower_components/angular/angular.min.js'
            'bower_components/angular-resource/angular-resource.min.js'
            'bower_components/angular-route/angular-route.min.js'
        ]

        copy:
            main:
                src: 'app/index.html'
                dest: 'build/index.html'

        concat:
            options:
                stripBanners: true
            libs:
                src: [ '<%= thirdParty %>' ]
                dest: 'build/scripts/libs.js'

        coffee:
            options:
                bare: true
            app:
                options:
                    join: true
                files:
                    'build/scripts/<%= pkg.name %>.js': [
                        'app/coffee/index.coffee'
                    ]

        connect:
            options:
                port: 9001
                debug: true
                livereload: true
            server:
                options:
                    middleware: (connect) ->
                        [
                            require('connect-livereload')()
                            mountFolder connect, 'build'
                        ]

        watch:
            options:
                livereload: true
            html:
                files: [ 'app/index.html' ]
                tasks: [ 'copy' ]
            coffee:
                files: [ 'app/coffee/*.coffee' ]
                tasks: [ 'coffee' ]

    grunt.registerTask 'dev', [
        'copy'
        'concat:libs'
        'coffee'
        'connect'
        'watch'
    ]
