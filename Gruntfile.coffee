nconf = require('nconf')

defaults =
	port: 8888      # --port=8888

nconf
	.argv()
	.env()
	.defaults(defaults)

module.exports = (grunt) ->
	gameDir = nconf.get('gameDir')
	port = nconf.get('port')

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-livereload'
	grunt.loadNpmTasks 'grunt-open'
	grunt.loadNpmTasks 'grunt-regarde'

	grunt.initConfig

		clean:
			dist: ["lib/game/**/*.js", "!lib/game/levels/**/*.js"]

		coffee:
			compile:
				expand: true
				cwd: "lib/game"
				src: ["**/*.coffee"]
				dest: "lib/game"
				ext: '.js'

		regarde:
			coffee:
				files: ["lib/game/**/*.coffee"]
				tasks: ["coffee:change"]
			livereload:
				files: ["lib/**/*.js", "css/**/*.css", "media/**/*", "*.html"]
				tasks: ["livereload"]

		open:
			server:
				url: "http://localhost:#{port}"

	createChangeTask = (task, cwd, src) ->
		grunt.registerTask "#{task}:change", ->
			conf = grunt.config
			dir = conf.get cwd
			files = grunt.regarde.changed

			conf.set src, files.map (changed) ->
				changed.split(dir)[1].slice(1)

			grunt.task.run "#{task}:compile"

	createChangeTask 'coffee', 'coffee.compile.cwd', 'coffee.compile.src'

	grunt.registerTask 'server', 'Serve dist directory and weltmister', ->

		express = require('express')
		impact = require('impact-weltmeister')
		app = express()

		app.configure ->
			app.use(express.methodOverride())
			app.use(express.bodyParser())
			app.use(app.router)

		impact.listen(app, root: "#{__dirname}/")

		app.use(express.static(__dirname))

		app.listen(port)

		console.log('listening on port', port);

	grunt.registerTask 'build', [
		'clean',
		'coffee:compile']

	grunt.registerTask 'develop', [
		'livereload-start',
		'server',
		'open',
		'regarde']

	grunt.registerTask 'default', [
		'build',
		'develop']
