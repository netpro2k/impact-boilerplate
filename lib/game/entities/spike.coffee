ig.module("game.entities.spike").requires(
	"impact.entity"
).defines ->

	# This entity is ported from the impact Jump and Run demo: http://impactjs.com/demos/jumpnrun/

	window.EntitySpike = ig.Entity.extend(
		size:
			x: 16
			y: 9

		maxVel:
			x: 100
			y: 100

		friction:
			x: 150
			y: 0

		type: ig.Entity.TYPE.B # Evil enemy group
		checkAgainst: ig.Entity.TYPE.A # Check against friendly
		collides: ig.Entity.COLLIDES.PASSIVE
		health: 10
		speed: 14
		flip: false
		animSheet: new ig.AnimationSheet("media/spike.png", 16, 9)

		init: (x, y, settings) ->
			@parent x, y, settings
			@addAnim "crawl", 0.08, [0, 1, 2]

		update: ->

			# near an edge? return!
			@flip = not @flip  unless ig.game.collisionMap.getTile(@pos.x + ((if @flip then +4 else @size.x - 4)), @pos.y + @size.y + 1)
			xdir = (if @flip then -1 else 1)
			@vel.x = @speed * xdir
			@parent()

		handleMovementTrace: (res) ->
			@parent res

			# collision with a wall? return!
			@flip = not @flip  if res.collision.x

		check: (other) ->
			other.receiveDamage 10, this
	)
