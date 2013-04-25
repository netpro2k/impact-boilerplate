A boilerplate for impact games written in coffeescript, complete with an auto compiling watch server with livereload (including hot swapping of images) and a weltmiester backend

# Prerequisites

You must have [node.js](http://nodejs.org/) (tested on 0.8.12) installed, including npm

# Setup

First, if you don't already have it installed, install the grunt-cli package globally:

	npm install -g grunt-cli

Then (from the boilerplate directory) run:
	
	npm install

The impactjs source code is not included in this repository (as it requires a payed license). You must your download your licensed version of impact from [http://impactjs.com/download](http://impactjs.com/download) and then:

- copy `weltmeister.html` and the `tools` directory into the root (along side `index.html`)
- copy the `impact` and `weltmiester` directories into `lib`

# Running

To launch the development server simply run:

	grunt

This will compile your coffeescript code, launch your browser, and begin watching for changes. 
- coffeescript changes will automatically be compiled
- CSS and image changes will be hot swapped into the page without reloading (note that image hot swapping is experimental)
- all other changes will reload the page

# TODO

- do further testing on live image swapping
- make an install script that will extract the appropriate parts of impact directly from impact zip (and perhaps even download it for you, given your impact key)
- investigate hot reloading of levels and entities
