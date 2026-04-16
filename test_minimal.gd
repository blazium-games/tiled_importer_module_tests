extends SceneTree

var frames = 0


func _process(delta):
	frames += 1
	if frames == 1:
		print("--- SCRIPT RUNNING ---")
		var class_db_exists = ClassDB.class_exists("ResourceImporterTiled")
		print("ClassDB.class_exists('ResourceImporterTiled') = ", class_db_exists)
		print("--- SCRIPT FINISHED ---")
	
	if frames > 2:
		quit(0)
	
	return false
