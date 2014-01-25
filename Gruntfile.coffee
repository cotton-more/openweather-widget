module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-ngmin'
    grunt.loadNpmTasks 'grunt-html2js'

    mountFolder = (connect, dir) ->
        connect.static require('path').resolve(dir)

    grunt.initConfig
        src: 'app'
        build: 'build'
        tmp: '.tmp'
        pkg: grunt.file.readJSON 'package.json'

        thirdParty: [
            'bower_components/angular/angular.min.js'
            'bower_components/angular-resource/angular-resource.min.js'
            'bower_components/angular-route/angular-route.min.js'
        ]

        coffee:
            app:
                options:
                    bare: true
                files: [
                    expand: true
                    cwd: 'app/coffee'
                    src: [ '*.coffee' ]
                    dest: '<%= build %>/scripts/built'
                    ext: '.js'
                ]

        concat:
            options:
                stripBanners: true
            libs:
                src: [ '<%= thirdParty %>' ]
                dest: '<%= build %>/scripts/libs.js'
            app:
                src: [ '<%= build %>/scripts/built/*.js' ]
                dest: '<%= build %>/scripts/<%= pkg.name %>.js'

        connect:
            options:
                port: 9001
                debug: true
                keepalive: true
            server:
                options:
                    base: [
                        'build'
                    ]

        watch:
            options:
                livereload: true
            coffee:
                files: [ 'app/coffee/**/*.coffee' ]
                tasks: [ 'coffee' ]
