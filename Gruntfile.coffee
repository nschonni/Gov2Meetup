module.exports = (grunt) ->

	# Project configuration.
	grunt.initConfig

		# Metadata.
		pkg: grunt.file.readJSON("package.json")
		banner: "/*! Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW) wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html\n" +
				" - v<%= pkg.version %> - " + "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n*/\n"

		# Task configuration.

		# Builds the demos
		assemble:
			options:
				prettify:
					indent: 2
				marked:
					sanitize: false
				production: false
				data: "src/data/**/*.{yml,json}"
				assets: "dist"
				helpers: "src/helpers/helper-*.js"
				partials: ["src/includes/**/*.hbs"]

			site:
				cwd: "src"
				src: ["*.hbs"]
				dest: "dist/"
				expand: true

		sass:
			dist:
				expand: true
				cwd: "src/scss"
				src: ["**/*.scss", "!**/_*.scss"]
				dest: "dist/css/"
				ext: ".css"

		cssmin:
			dist:
				expand: true
				cwd: "dist/css"
				src: ["**/*.css", "!**/*.min.css"]
				dest: 'dist/css'
				ext: ".min.css"

		copy:
			revealjs:
				cwd: "lib/reveal.js"
				src: [
					"**/*.min.js",
					"**/*.min.css"
				]
				dest: "dist/reveal.js"
				expand: true

			assets:
				cwd: "src"
				src: "assets/**/*"
				dest: "dist"
				expand: true

			readme:
				src: "README.md"
				dest: "dist"
				expand: true

		clean:
			dist: "dist"
			cssUncompressed: ["dist/css/**/*.css", "!dist/css/**/*.min.css"]

		"gh-pages":
			options:
				message: "Rebuild site"
				base: "dist"
			src: [
				"**/*.*"
			]

		connect:
			server:
				options:
					port: 8000
					base: "dist"
					keepalive: true
					open: "dist/index.html"


	# These plugins provide necessary tasks.
	@loadNpmTasks "assemble"
	@loadNpmTasks "grunt-contrib-clean"
	@loadNpmTasks "grunt-contrib-connect"
	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-gh-pages"
	@loadNpmTasks "grunt-sass"

	# Default task.
	@registerTask "default", ["dist"]
	@registerTask "css", ["sass", "cssmin", "clean:cssUncompressed"]

	@registerTask "dist", ["clean:dist", "css", "copy", "html"]
	@registerTask "html", ["assemble"]
	@registerTask "deploy", ["gh-pages"]

	@