# TrashThrasher
An "Endless Studios" Game Design Group Project - Spring 24'

The following are the instructions and code I used for what I've done so far. 
Feel free to modify or change this document :-)

1.	Setting up the Scene:
extends Node2D
# Constants for screen dimensions
const SCREEN_WIDTH = 800
const SCREEN_HEIGHT = 600
func _ready():
	# Set the screen size
	get_viewport().size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
		# Add the player character
	var player = Player.new()
	add_child(player)
	
This code sets up the basic structure of the game. We create a new scene that extends Node2D and set constants for the screen width and height. In the _ready() function, we set the viewport size and add the player character (which we'll define in the next section).
The get_viewport() function in Godot returns the viewport, which represents the size and position of the visible area of the game. By using get_viewport().size, we are getting the size of the viewport, which is essentially the size of the user's screen or the game window where the game will be displayed. This allows us to set up our game's dimensions accordingly, ensuring it fits well on the screen.

2.	Player Character:

extends CharacterBody2D
const SPEED = 300
func _process(delta):
	# Move the player left or right based on input
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1
	move_and_slide(Vector2(direction * SPEED * delta, 0))

func _ready():
	# Set the initial position of the player
	position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 50)
	
This code defines the player character as a CharacterBody2D, which allows for physics-based movement. The _process(delta) function handles player movement by checking for input (left or right arrow keys) and moving the player accordingly. The _ready() function sets the initial position of the player at the bottom center of the screen.


Create the falling objects, which the player will shoot down; starting with a basic object that falls from the top of the screen.

TrashObject: Object that utilizes physics engine to fall towards the ground.  Has a collider to detect projectile hits and interact with objects.

	extends RigidBody2D

FallingObjectSpawner:  Test object for spawning trash objects.

	extends Node2D

		const SPAWN_INTERVAL - Sets time between spawns

		func _process(delta): Keeps track of time since last spawn and spawns objects if appropriate time has passed.

		func spawn_object():  Creates new instance of TrashObject, spawns it just above the screen, sets its location randomly across the screen, and sets it to a random rotation.

		Shooting mechanics can include effects like an explosion when an object is hit and destroyed. 
		
TestPlanet: Simple rectangle with collision to hold the place of the actual planet.
	
	extends StaticBody2D 

TestLevel: Level containing a TestPlanet and a FallingObjectSpawner.  Can be used to test physics and behavior of objects.

5.	Shooting Mechanics and Object Destruction:
   
First, let's modify the Player script to handle shooting:

extends CharacterBody2D
const SPEED = 300
const SHOOT_SPEED = 500
var can_shoot = true
var projectile_scene = preload("res://Projectile.tscn")
func _process(delta):
	move_player(delta)
	check_shoot()
func move_player(delta):
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1
	move_and_slide(Vector2(direction * SPEED * delta, 0))
func check_shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		projectile.position = position
		projectile.velocity = Vector2(0, -SHOOT_SPEED)
		can_shoot = false
		$Timer.start()  # Start cooldown timer for shooting
func _on_Timer_timeout():
	can_shoot = true
}

Then created the Projectile script to handle projectile movement and collision detection:

extends Area2D
export var velocity = Vector2.ZERO
const BOUNDARY_MARGIN = 20
func _process(delta):
	move_and_collide(velocity * delta)
	# Destroy projectile if it goes out of bounds
	if position.y < -BOUNDARY_MARGIN:
		queue_free()
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		# Play explosion effect
		var explosion = preload("res://Explosion.tscn").instance()
		get_parent().add_child(explosion)
		explosion.position = position
		body.queue_free()  # Destroy the enemy object
		queue_free()  # Destroy the projectile
		
In the Player script, we added shooting logic to instantiate projectiles (Projectile.tscn) when the shoot action is triggered. The Projectile script handles projectile movement, destruction upon leaving the screen, and triggering an explosion effect and destroying the projectile and enemy when they collide.

1.	Projectile Scene:
Create a new scene in Godot and add an Area2D node as the root node. Add a Sprite node as a child of the Area2D node to represent the projectile's visual appearance. Attach a CollisionShape2D node to the Area2D node to define the collision area of the projectile. Lastly, attach a new script to the Area2D node and name it Projectile.gd.
Here's a basic setup for the Projectile script (Projectile.gd):
extends Area2D
export var velocity = Vector2.ZERO
const BOUNDARY_MARGIN = 20
func _process(delta):
	move_and_collide(velocity * delta)

	# Destroy projectile if it goes out of bounds
	if position.y < -BOUNDARY_MARGIN:
		queue_free()
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		# Play explosion effect
		var explosion = preload("res://Explosion.tscn").instance()
		get_parent().add_child(explosion)
		explosion.position = position
		body.queue_free()  # Destroy the enemy object
		queue_free()  # Destroy the projectile

Then created the Explosion scene.
2.	Explosion Scene:
Create a new scene in Godot and add a Sprite node as the root node. Assign an animated sprite sheet or a series of sprite frames representing an explosion animation to the Sprite node. Add an AnimationPlayer node to control the animation playback.
An example of how the Explosion script (Explosion.gd) could look like:

extends Node2D
func _ready():
	$AnimatedSprite.play("explode")  # Start the explosion animation
func _on_AnimatedSprite_animation_finished():
	queue_free()  # Destroy the explosion node after animation finishes
	
In this script, we play the explosion animation when the Explosion scene is instantiated and then automatically destroy the explosion node when the animation finishes.
Once we've created these scenes and scripts, we'll need to adjust the properties, animations, and collision shapes as needed for our game.

To integrate the Projectile and Explosion scenes into the main game scene, we'll need to instantiate them dynamically during gameplay. Here's (supposedly) how can do it:

1.	Instantiate Projectile in the Player Script: In the Player script where we handle shooting, we already have the logic to instantiate projectiles. When the player shoots, we create a new instance of the Projectile scene and add it to the scene hierarchy. Here's the relevant code from the Player script:

func check_shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		projectile.position = position
		projectile.velocity = Vector2(0, -SHOOT_SPEED)
		can_shoot = false
		$Timer.start()  # Start cooldown timer for shooting

2.	Instantiate Explosion in the Projectile Script: When a projectile collides with an enemy in the Projectile script, we create an explosion effect and add it to the scene. Here's the relevant code from the Projectile script:

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		# Play explosion effect
		var explosion = preload("res://Explosion.tscn").instance()
		get_parent().add_child(explosion)
		explosion.position = position
		body.queue_free()  # Destroy the enemy object
		queue_free()  # Destroy the projectile


3.	Adding Enemy Objects and Grouping: Make sure your falling objects (enemies) are also instantiated and added to the scene dynamically, similar to how we spawn the falling objects using the FallingObjectSpawner script. You can then group these enemy objects and assign them to the "enemy" group in Godot's inspector. This grouping allows the projectile to detect collisions only with objects in the "enemy" group.

4.	Scene Integration: In your main game scene, you should have nodes for the player character, falling object spawner, and other necessary elements. Make sure to add these elements to your scene and connect scripts and signals as needed for your game logic to work correctly.

After integrating these scenes and scripts, when the player shoots, projectiles will be created and move upwards. When a projectile collides with an enemy object, it will trigger an explosion effect from the Explosion scene at the collision point.

On "1. Setting up the Scene:" 

1.	Open Godot Engine:
o	Launch the Godot Engine on your computer. You should see the project manager where you can create or open projects.

2.	Create a New Project:
o	Click on "New Project" to create a new project.
o	Choose a location on your computer to save the project files and give your project a name (e.g., "TrashThraser", or whatever).

3.	Set Up Project Settings:
o	After creating the project, you'll be in the Godot editor.
o	Go to the "Project" menu at the top and select "Project Settings."
o	In the project settings, navigate to the "Display" category.
o	Set the "Width" to 800 and "Height" to 600 under "Window."
o	These settings will match the screen dimensions we used in the initial code.

4.	Create Player Character Scene:
o	In the Godot editor, click on the "Scene" menu and select "New Scene" to create a new scene.
o	Add a CharacterBody2D (previous versions list this as “Kinematic2D”) node as the root node of the scene. This will represent your player character.
o	Add a Sprite node as a child of the CharacterBody2D node to represent the visual appearance of your player character.
o	You can also add a CollisionShape2D node as a child of the CharacterBody2D node to define the collision shape of your player character.
o	Save this scene as "Player.tscn" in your project folder.

5.	Create Falling Object Scene:
o	Similarly, create a new scene for the falling objects.
o	Add a CharacterBody2D node as the root node.
o	Add a Sprite node to represent the visual appearance of the falling object.
o	Add a CollisionShape2D node to define its collision shape.
o	Save this scene as "FallingObject.tscn" in your project folder.

6.	Create Falling Object Spawner Scene:
o	Create another new scene for the falling object spawner.
o	Add a Node2D or a Timer node as the root node.
o	Save this scene as "FallingObjectSpawner.tscn" in your project folder.

7.	Add Scripts:
o	For each of the scenes you created (Player, FallingObject, FallingObjectSpawner), create GDScript files and attach them to the respective nodes.
o	You can create scripts by right-clicking on a node in the Scene panel, then choosing "Attach Script."
o	Write the code for each script as we've discussed earlier in this conversation.
Once you've completed these steps, your basic setup for the scene, player character, falling objects, and spawner should be in place within the Godot editor. You can then continue with integrating shooting mechanics, explosions, and other gameplay elements into your game. 

In Step 4, "Create Player Character Scene:" How to add a CharacterBody2D node as the root node of the scene, and add a CollisionShape2D node as it's child:

1.	Create Player Character Scene:
o	Open Godot and create a new scene by going to the "Scene" menu and selecting "New Scene."
o	Once the new scene is created, you'll see an empty scene workspace.

2.	Adding KinematicBody2D as Root Node:
o	In the Scene panel (usually on the left side of the Godot interface), right-click on the root node (usually named "Node") and choose "Add Child Node."
o	In the "Add Node" window, type "CharacterBody2D" in the search bar or scroll down until you find the "CharacterBody2D" node, then select it and click "Create."
o	You'll now see a CharacterBody2D node added to your scene as the root node.

3.	Adding Sprite as Child Node:
o	With the CharacterBody2D node selected in the Scene panel, right-click on it and choose "Add Child Node."
o	In the "Add Node" window, type "Sprite" in the search bar or scroll down until you find the "Sprite" node, then select it and click "Create."
o	This will add a Sprite node as a child of the CharacterBody2D node. You can then configure the sprite's properties (like texture, size, etc.) in the Inspector panel (usually on the right side of the Godot interface).

4.	Adding CollisionShape2D as Child Node:
o	Similar to adding the Sprite node, with the CharacterBody2D node selected in the Scene panel, right-click on it and choose "Add Child Node."
o	In the "Add Node" window, type "CollisionShape2D" in the search bar or scroll down until you find the "CollisionShape2D" node, then select it and click "Create."
o	This will add a CollisionShape2D node as a child of the KinematicBody2D node. You can then adjust the collision shape (shape type, size, position) in the Inspector panel to match the shape of your player character.
After adding these nodes, you can save your scene by going to the "Scene" menu and choosing "Save Scene As." Give your scene a meaningful name like "Player.tscn" and save it in your project folder.


Here's how you can add nodes in Godot using the "Create Root Node" option:

1.	Create Player Character Scene:
o	Open Godot and create a new scene by going to the "Scene" menu and selecting "New Scene."
o	Once the new scene is created, you'll see an empty scene workspace.

2.	Adding CharacterBody2D as Root Node:
o	In the scene workspace, you should see a message like "Create Root Node: 2D Scene, 3D Scene, User Interface or Other Node." Click on this message.

3.	Choose CharacterBody2D:
o	In the dialog that appears, choose "2D Scene" to create a 2D scene.
o	Once the 2D scene is created, you'll see a new node (usually named "Node2D") added to the scene as the root node.

4.	Adding Sprite as Child Node:
o	With the Node2D (or whichever node was created as the root node) selected in the Scene panel, look for the "Create Child Node" button in the toolbar or right-click on the Node2D and choose "Create Child Node."
o	In the dialog that appears, choose "Sprite" to create a Sprite node as a child of the selected node.
o	This will add a Sprite node under the Node2D in the Scene panel.

5.	Adding CollisionShape2D as Child Node:
o	Similarly, with the Node2D selected, use the "Create Child Node" button or right-click to create another child node.
o	Choose "CollisionShape2D" in the dialog to add a CollisionShape2D node as a child of the Node2D.
After adding these nodes, you can set their properties (like texture for the Sprite, shape for the CollisionShape2D) in the Inspector panel on the right side of the Godot interface. 
Remember to save your scene by going to the "Scene" menu and choosing "Save Scene As."

**Character movement**:
On the code for player character, to use either the arrow keys for left, right movement, or the "A" key for left and "D" key for right; this is how you'd do that:
Modify the input handling in the Player script. 

extends CharacterBody2D
const SPEED = 300
const SHOOT_SPEED = 500
var can_shoot = true
var projectile_scene = preload("res://Projectile.tscn")
func _process(delta):
	move_player(delta)
	check_shoot()
func move_player(delta):
	var direction = 0
	# Handle movement with arrow keys or A/D keys
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction += 1
	move_and_slide(Vector2(direction * SPEED * delta, 0))
func check_shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		projectile.position = position
		projectile.velocity = Vector2(0, -SHOOT_SPEED)
		can_shoot = false
		$Timer.start()  # Start cooldown timer for shooting
func _on_Timer_timeout():
	can_shoot = true
	
In this modified code:
•	We use Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right") to check for arrow key presses.
•	We also keep the existing checks for "move_left" and "move_right" actions, which can be bound to the "A" and "D" keys respectively.
You need to ensure that your project's input map is set up accordingly. You can configure these input actions in Godot by going to the "Project" menu -> "Project Settings" -> "Input Map" tab. There, you can define "ui_left" and "ui_right" actions for the arrow keys and "move_left" and "move_right" actions for the "A" and "D" keys respectively.

Note: In the "1. Setting up the Scene" section where we set the screen size and add the player character, you would save this initial setup as a scene file in Godot. This scene file will represent the main gameplay scene where the player interacts with the game environment. 

1.	Save the Scene:
o	After you've written the code to set the screen size and add the player character in your Godot script, you need to create a scene from this setup.
o	In the Godot editor, go to the "Scene" menu at the top.
o	Select "Save Scene As..." or "Save Scene" depending on whether you've saved the scene before.
o	Choose a location in your project directory to save the scene file.

2.	Name the Scene:
o	When you choose to save the scene, Godot will prompt you to enter a name for the scene file.
o	Give your scene file a descriptive name that reflects its purpose or content. For example, you can name it "GameplayScene.tscn" or "MainGame.tscn" to indicate that this is the main gameplay scene.
o	Make sure to use the ".tscn" extension, which stands for "Text Scene" in Godot.

3.	Usage of the Scene File:
o	Once you've saved the scene file, you can then use it as the main scene in your Godot project.
o	To set a scene as the main scene, go to the "Project" menu -> "Project Settings" -> "General" tab.
o	In the "Run" section, select your saved scene file as the "Main Scene" of your project. This tells Godot to start the game from this scene when you run the project.
By following these steps, you create a scene file that contains the initial setup of your game, including the screen size definition and the addition of the player character. This scene file becomes the starting point of your game and serves as the foundation for adding more gameplay elements, levels, and interactions.

Again, here are the steps for creating a new scene in Godot:
1.	Create a New Scene:
o	Open Godot Engine on your computer.
o	In the Godot editor, go to the "Scene" menu at the top.

2.	Select "New Scene":
o	In the "Scene" menu, select "New Scene" to create a new scene file.
o	This action will clear the current scene (if any) and provide you with a fresh scene to work on.

3.	Set up the Scene:
o	After creating the new scene, you'll see an empty scene workspace in the Godot editor.
o	Now, you can start setting up the scene according to your game requirements.

4.	Add Nodes to the Scene:
o	Right-click in the Scene panel (usually on the left side of the Godot interface) to bring up the context menu.
o	In the context menu, choose "Create Node" to add nodes to your scene.
o	For example, you can add a Node2D or a CharacterBody2D node as the root node of your scene. To do this, select "2D Scene" or "CharacterBody2D" from the options, respectively.

5.	Set Screen Size Script:
o	Once you have your scene set up with the necessary nodes, you can then write the script to set the screen size and add the player character.
o	In the Godot editor, click on the "Script" icon in the toolbar or press Ctrl + S to open the script editor.
o	Write the script for setting the screen size and adding the player character. For example, you can use the script provided in the initial code snippet for setting up the scene.

6.	Save the Scene:
o	After writing the script and setting up the scene, it's time to save your work.
o	Go to the "Scene" menu and choose "Save Scene As..." or "Save Scene" depending on whether you've saved the scene before.
o	Choose a location in your project directory to save the scene file.
o	Give your scene file a meaningful name, such as "MainGame.tscn" or "GameplayScene.tscn."

7.	Usage of the Scene File:
o	Once you've saved the scene file, you can use it in your project as the main scene or as a scene to be loaded during gameplay.
o	To set a scene as the main scene, go to the "Project" menu -> "Project Settings" -> "General" tab.
o	In the "Run" section, select your saved scene file as the "Main Scene" of your project. This tells Godot to start the game from this scene when you run the project.
