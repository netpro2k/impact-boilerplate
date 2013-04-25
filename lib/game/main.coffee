ig.module("game.main").requires(
	"impact.game",
	"impact.font",
	"game.entities.player",
	"game.entities.spike",
	"game.levels.test"
).defines ->

	# Allow live relaoding of image assets for entities and tilemaps
	# this is currently experimental and may have issues.
	# See http://github.com/netpro2k/impact-livereload for more info
	LiveReload.reloader.reloadImages = _.wrap LiveReload.reloader.reloadImages,  (origFunc, path) ->
		newImg = new ig.Image("#{path}?t=#{Date.now()}")

		entitiesUsingImage = _.filter ig.game.entities, (entity) ->
			entity.animSheet.image.path.indexOf(path) != -1

		for entity in entitiesUsingImage
			entity.animSheet.image = newImg
			for own name,anim of entity.anims
				anim.image = newImg

		mapsUsingImage = _.filter ig.game.backgroundMaps, (map) ->
			map.tilesetName.indexOf(path) != -1

		preRenderedMaps = []
		for map in mapsUsingImage
			map.tiles = newImg
			preRenderedMaps.push(map) if map.preRender

		newImg.loadCallback = ->
			map.preRenderMapToChunks() for map in preRenderedMaps

		origFunc.call(LiveReload.reloader, path)


	MyGame = ig.Game.extend(
		gravity: 300 # All entities are affected by this

		# Load a font
		font: new ig.Font("media/04b03.font.png")

		init: ->
			# Bind keys
			ig.input.bind ig.KEY.LEFT_ARROW, "left"
			ig.input.bind ig.KEY.RIGHT_ARROW, "right"
			ig.input.bind ig.KEY.X, "jump"
			ig.input.bind ig.KEY.C, "shoot"

			# Load the LevelTest as required above ('game.level.test')
			@loadLevel LevelTest

		update: ->
			# Update all entities and BackgroundMaps
			@parent()

			# screen follows the player
			player = @getEntitiesByType(EntityPlayer)[0]
			if player
				@screen.x = player.pos.x - ig.system.width / 2
				@screen.y = player.pos.y - ig.system.height / 2

		draw: ->
			# Draw all entities and BackgroundMaps
			@parent()
			@font.draw "Arrow Keys, X, C", 2, 2
	)

	# Start the Game with 60fps, a resolution of 240x160, scaled
	# up by a factor of 4
	ig.main "#canvas", MyGame, 60, 240, 160, 4
