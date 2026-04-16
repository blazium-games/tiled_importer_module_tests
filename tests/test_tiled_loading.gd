extends AutoworkTest

func test_load_tiled_tmx_map() -> void:
    # Verify that we can load TMJ/TMX maps seamlessly
    var scene = ResourceLoader.load("res://tests/data/test-maps/simple_map.tmx")
    assert_not_null(scene, "Could not load test TMX map.")
    if scene:
        var instance = scene.instantiate()
        assert_not_null(instance, "Failed to instantiate TMX map.")
        assert_eq(str(instance.name), "simple_map", "Map instantiated with wrong name.")
        instance.print_tree_pretty()
        
        var layer: TileMapLayer = instance.get_node_or_null("simple_layer") as TileMapLayer
        assert_not_null(layer, "Failed to find simple_layer.")
        if layer:
            assert_true(layer.get_used_cells().size() > 0, "Layer should contain tiles")
        
        # Test if parsing succeeded with minimal children expectation
        assert_true(instance.get_child_count() > 0, "Map node should have children")

func test_load_infinite_tmx_map() -> void:
    # Verify that infinite maps load
    var scene = ResourceLoader.load("res://tests/data/test-maps/infinite.tmx")
    assert_not_null(scene, "Could not load test infinite TMX map.")
    if scene:
        var instance = scene.instantiate()
        assert_not_null(instance, "Failed to instantiate infinite TMX map.")
        assert_eq(str(instance.name), "infinite", "Map instantiated with wrong name.")

func _get_all_test_maps(path: String, map_files: Array) -> void:
    var dir = DirAccess.open(path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if not file_name in [".", ".."]:
                var full_path = path.path_join(file_name)
                if dir.current_is_dir():
                    _get_all_test_maps(full_path, map_files)
                elif file_name.ends_with(".tmx") or file_name.ends_with(".tmj") or file_name.ends_with(".json") or file_name.ends_with(".world") or file_name.ends_with(".lzma"):
                    if not file_name.ends_with(".import"):
                        map_files.append(full_path)
            file_name = dir.get_next()

func test_load_all_tileson_sample_maps() -> void:
    # Explicitly loop through all map variants recursively to validate the importer port's robust capability
    var all_maps = []
    _get_all_test_maps("res://tests/data/", all_maps)
    
    for res_path in all_maps:
        # Check map variations, note that some specific tests map configurations might throw expected unsupported warnings but MUST NOT CRASH
        var scene = ResourceLoader.load(res_path)
        assert_not_null(scene, str("Could not load Tiled map sample: ", res_path))
        if scene and scene is PackedScene:
            var instance = scene.instantiate()
            assert_not_null(instance, str("Failed to instantiate Tiled map sample: ", res_path))
            if instance:
                assert_true(instance.get_child_count() > 0, str("Map failed to load any child layers/components: ", res_path))
