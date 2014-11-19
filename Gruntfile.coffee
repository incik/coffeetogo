module.exports = (grunt) ->

  # configuration for Karma
  karmaConfig = (configFile, customOptions) ->
    options = { configFile: configFile, keepalive: true }
    travisOptions = process.env.TRAVIS && { browsers: ['PhantomJS'], reporters: 'dots' }
    grunt.util._.extend(options, customOptions, travisOptions)

  grunt.initConfig
    distdir: 'dist'
    pkg: grunt.file.readJSON("package.json")

    karma:
      unit:
        options: karmaConfig 'test/config/unit.js'
      watch:
        options: karmaConfig('test/config/unit.js', { singleRun: false, autoWatch: true })

    coffee:
      compile:
        options:
          bare: true
        files:
          'tmp/src/<%= pkg.name %>.js': ['src/*.coffee', 'src/**/*.coffee']
      compileTests:
        files:
          'tmp/test/tests.spec.js': ['test/unit/*.coffee', 'test/unit/**/*.coffee']

    concat:
      dist:
        src: 'tmp/src/*.js'
        dest: '<%= distdir %>/<%= pkg.name %>.js'
      options:
        separator: ";"

    clean: ['<%= distdir %>/*']

    watch:
      coffee:
        files: ["src/*.coffee", 'test/unit/*.coffee']
        tasks: ["coffee", "karma:unit", "build"]


  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-karma"

  # Print a timestamp (useful for when watching)
  grunt.registerTask 'timestamp', () ->
    grunt.log.subhead Date()

  grunt.registerTask "default", ["coffee", 'karma:unit', 'build']
  grunt.registerTask 'build', ['clean','concat']
  grunt.registerTask 'release', ['coffee','clean','karma:unit','concat:index']
