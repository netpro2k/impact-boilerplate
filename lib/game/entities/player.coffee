ig.module("game.entities.player").requires(
	"impact.entity"
).defines ->

	# This entity is ported from the impact Jump and Run demo: http://impactjs.com/demos/jumpnrun/

	window.EntityPlayer = ig.Entity.extend(

		# The players (collision) size is a bit smaller than the animation
		# frames, so we have to move the collision box a bit (offset)
		size:
			x: 8
			y: 14

		offset:
			x: 4
			y: 2

		maxVel:
			x: 100
			y: 200

		friction:
			x: 600
			y: 0

		type: ig.Entity.TYPE.A # Player friendly group
		checkAgainst: ig.Entity.TYPE.NONE
		collides: ig.Entity.COLLIDES.PASSIVE
		animSheet: new ig.AnimationSheet("media/player.png", 16, 16)

		# These are our own properties. They are not defined in the base
		# ig.Entity class. We just use them internally for the Player
		flip: false
		accelGround: 400
		accelAir: 200
		jump: 200
		health: 10
		flip: false

		init: (x, y, settings) ->
			@parent x, y, settings

			# Add the animations
			@addAnim "idle", 1, [0]
			@addAnim "run", 0.07, [0, 1, 2, 3, 4, 5]
			@addAnim "jump", 1, [9]
			@addAnim "fall", 0.4, [6, 7]

		update: ->

			# move left or right
			accel = (if @standing then @accelGround else @accelAir)
			if ig.input.state("left")
				@accel.x = -accel
				@flip = true
			else if ig.input.state("right")
				@accel.x = accel
				@flip = false
			else
				@accel.x = 0

			# jump
			@vel.y = -@jump  if @standing and ig.input.pressed("jump")

			# shoot
			if ig.input.pressed("shoot")
				ig.game.spawnEntity EntitySlimeGrenade, @pos.x, @pos.y,
					flip: @flip


			# set the current animation, based on the player's speed
			if @vel.y < 0
				@currentAnim = @anims.jump
			else if @vel.y > 0
				@currentAnim = @anims.fall
			else unless @vel.x is 0
				@currentAnim = @anims.run
			else
				@currentAnim = @anims.idle
			@currentAnim.flip.x = @flip

			# move!
			@parent()
	)

	# The grenades a player can throw are NOT in a separate file, because
	# we don't need to be able to place them in Weltmeister. They are just used
	# here in the code.

	# Only entities that should be usable in Weltmeister need to be in their own
	# file.
	window.EntitySlimeGrenade = ig.Entity.extend(
		size:
			x: 4
			y: 4

		offset:
			x: 2
			y: 2

		maxVel:
			x: 200
			y: 200


		# The fraction of force with which this entity bounces back in collisions
		bounciness: 0.6
		type: ig.Entity.TYPE.NONE
		checkAgainst: ig.Entity.TYPE.B # Check Against B - our evil enemy group
		collides: ig.Entity.COLLIDES.PASSIVE
		animSheet: new ig.AnimationSheet("media/slime-grenade.png", 8, 8)
		bounceCounter: 0
		init: (x, y, settings) ->
			@parent x, y, settings
			@vel.x = ((if settings.flip then -@maxVel.x else @maxVel.x))
			@vel.y = -50
			@addAnim "idle", 0.2, [0, 1]

		handleMovementTrace: (res) ->
			@parent res
			if res.collision.x or res.collision.y

				# only bounce 3 times
				@bounceCounter++
				@kill()  if @bounceCounter > 3


		# This function is called when this entity overlaps anonther entity of the
		# checkAgainst group. I.e. for this entity, all entities in the B group.
		check: (other) ->
			other.receiveDamage 10, this
			@kill()
	)
