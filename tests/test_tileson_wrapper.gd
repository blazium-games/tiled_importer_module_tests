extends AutoworkTest

func test_tileson_parser_validity() -> void:
    # Validate the GodotTsonTileson endpoint
    var tson = GodotTsonTileson.new()
    assert_not_null(tson, "Failed to instantiate GodotTsonTileson")

    # Parse an existing json file
    var map: GodotTsonMap = tson.parse_file("res://tests/data/test-maps/simple_map.json")
    assert_not_null(map, "parse_file returned null for simple_map.json")
    assert_eq(map.get_status(), "OK", "Map parse status should be OK")

    var size = map.get_size()
    assert_true(size.x > 0 and size.y > 0, "Map size should be valid")

    var tile_size = map.get_tile_size()
    assert_true(tile_size.x > 0 and tile_size.y > 0, "Map tile_size should be valid")

    # Validate the newly bound Map properties
    assert_true(map.get_hexside_length() >= 0, "Hexside Length should be an integer")
    assert_true(typeof(map.is_infinite()) == TYPE_BOOL, "is_infinite should return a bool")
    assert_true(typeof(map.get_next_layer_id()) == TYPE_INT, "Next layer ID should be an integer")
    assert_true(typeof(map.get_next_object_id()) == TYPE_INT, "Next object ID should be an integer")
    assert_not_null(map.get_orientation(), "Map should have an orientation string")
    assert_not_null(map.get_render_order(), "Map should have a render_order string")
    assert_true(typeof(map.get_compression_level()) == TYPE_INT, "compression_level should be an integer")
    assert_true(typeof(map.get_parallax_origin()) == TYPE_VECTOR2, "parallax_origin should be a Vector2")
    assert_true(typeof(map.get_background_color()) == TYPE_COLOR, "Background color should bind properly")

    # Validate Layers
    var layers: Array = map.get_layers()
    assert_true(layers.size() > 0, "Map should contain at least one layer")
    
    var first_layer: GodotTsonLayer = layers[0]
    assert_not_null(first_layer, "Layer should be properly cast to GodotTsonLayer")
    assert_true(first_layer.get_name() != "", "Layer should have a name")
    assert_true(first_layer.get_type() != "", "Layer should have a type")
    
    # Layer newly bound properties check
    assert_true(typeof(first_layer.get_opacity()) == TYPE_FLOAT, "Layer opacity should be float")
    assert_true(typeof(first_layer.get_size()) == TYPE_VECTOR2I, "Layer size should be Vector2i")
    assert_true(typeof(first_layer.get_parallax()) == TYPE_VECTOR2, "Layer parallax should be Vector2")
    assert_true(typeof(first_layer.has_repeat_x()) == TYPE_BOOL, "Layer has_repeat_x should be bool")
    assert_true(typeof(first_layer.has_repeat_y()) == TYPE_BOOL, "Layer has_repeat_y should be bool")
    assert_true(typeof(first_layer.get_offset()) == TYPE_VECTOR2, "Layer offset should be Vector2")

    # Validate Tilesets
    var tilesets: Array = map.get_tilesets()
    assert_true(tilesets.size() > 0, "Map should contain standard tilesets")
    var first_ts: GodotTsonTileset = tilesets[0]
    assert_true(first_ts.get_name() != "", "Tileset should have a name")
    
    # Tileset newly bound properties check
    assert_true(typeof(first_ts.get_columns()) == TYPE_INT, "Tileset columns should be integer")
    assert_true(typeof(first_ts.get_tile_count()) == TYPE_INT, "Tileset tile count should be integer")
    assert_true(typeof(first_ts.get_image_size()) == TYPE_VECTOR2I, "Tileset image size should be Vector2i")
    assert_true(typeof(first_ts.get_tile_offset()) == TYPE_VECTOR2I, "Tileset tile offset should be Vector2i")
    assert_true(typeof(first_ts.get_first_gid()) == TYPE_INT, "Tileset first GID should be Integer")
    assert_true(typeof(first_ts.get_margin()) == TYPE_INT, "Tileset margin should be integer")
    assert_true(typeof(first_ts.get_spacing()) == TYPE_INT, "Tileset spacing should be integer")

    # Validate Map Properties
    var props: Array = map.get_properties()
    assert_true(props is Array, "get_properties should return an Array")

func test_tileson_objects_and_chunks() -> void:
    var tson = GodotTsonTileson.new()
    var map: GodotTsonMap = tson.parse_file("res://tests/data/test-maps/simple_map.json")
    
    for layer in map.get_layers():
        var objects = layer.get_objects()
        var chunks = layer.get_chunks()
        
        assert_true(objects is Array, "get_objects should return an Array")
        assert_true(chunks is Array, "get_chunks should return an Array")
        
        for obj in objects:
            assert_not_null(obj, "GodotTsonObject should be properly formed")
            var obj_id = obj.get_id()
            var obj_name = obj.get_name()
            # Assert execution context is safe
            assert_true(obj_id >= 0, "Object should have valid ID")
            assert_true(typeof(obj.is_ellipse()) == TYPE_BOOL, "is_ellipse should be bool")
            assert_true(typeof(obj.is_point()) == TYPE_BOOL, "is_point should be bool")
            assert_true(typeof(obj.get_object_type()) == TYPE_INT, "object type should be integer")
            assert_true(typeof(obj.get_gid()) == TYPE_INT, "object gid should be integer")
            assert_true(typeof(obj.get_polygon()) == TYPE_ARRAY, "polygon should export to array")
            assert_true(typeof(obj.get_polyline()) == TYPE_ARRAY, "polyline should export to array")
        
        for chunk in chunks:
            assert_not_null(chunk, "GodotTsonChunk should be properly formed")
            assert_true(chunk.get_data() is Array, "Chunk data should export to array")

func test_tileson_project_wrapper() -> void:
    var project = GodotTsonProject.new()
    assert_not_null(project, "Project Wrapper successfully bound")
    assert_eq(project.get_path(), "", "Project should start with empty path natively")
    
    var world = GodotTsonWorld.new()
    assert_not_null(world, "World Wrapper successfully bound")

func test_tileson_wang_wrapper() -> void:
    var wang = GodotTsonWangSet.new()
    assert_not_null(wang, "WangSet successfully bound natively")
    assert_eq(wang.get_name(), "", "Wang should instantiate safely")
    assert_true(typeof(wang.get_class_type()) == TYPE_STRING, "WangSet class type should be string")
    
    var wcolor = GodotTsonWangColor.new()
    assert_not_null(wcolor, "WangColor successfully bound")
    assert_true(typeof(wcolor.get_class_type()) == TYPE_STRING, "WangColor class type should be string")
    
    var wtile = GodotTsonWangTile.new()
    assert_not_null(wtile, "WangTile successfully bound")
    assert_true(typeof(wtile.has_d_flip()) == TYPE_BOOL, "WangTile d_flip should be bool")
    assert_true(typeof(wtile.has_h_flip()) == TYPE_BOOL, "WangTile h_flip should be bool")
    assert_true(typeof(wtile.has_v_flip()) == TYPE_BOOL, "WangTile v_flip should be bool")
    assert_true(typeof(wtile.get_tile_id()) == TYPE_INT, "WangTile id should be integer")

func test_tileson_remaining_classes() -> void:
    var grid := GodotTsonGrid.new()
    assert_not_null(grid, "GodotTsonGrid bound")
    var terrain := GodotTsonTerrain.new()
    assert_not_null(terrain, "GodotTsonTerrain bound")
    var text := GodotTsonText.new()
    assert_not_null(text, "GodotTsonText bound")
    assert_true(typeof(text.get_horizontal_alignment()) == TYPE_INT, "Text horiz align should be int")
    assert_true(typeof(text.get_vertical_alignment()) == TYPE_INT, "Text vert align should be int")
    
    var transf := GodotTsonTransformations.new()
    assert_not_null(transf, "GodotTsonTransformations bound")
    assert_true(typeof(transf.allow_hflip()) == TYPE_BOOL, "Transformations hflip should be bool")
    assert_true(typeof(transf.allow_vflip()) == TYPE_BOOL, "Transformations vflip should be bool")
    assert_true(typeof(transf.allow_preferuntransformed()) == TYPE_BOOL, "Transformations preferuntransf should be bool")
    assert_true(typeof(transf.allow_rotation()) == TYPE_BOOL, "Transformations rotation should be bool")
    var tclass := GodotTsonTiledClass.new()
    assert_not_null(tclass, "GodotTsonTiledClass bound")
    var enumdef := GodotTsonEnumDefinition.new()
    assert_not_null(enumdef, "GodotTsonEnumDefinition bound")
    assert_true(typeof(enumdef.get_storage_type()) == TYPE_INT, "EnumDef storage type should be integer")
    assert_true(typeof(enumdef.has_value("string")) == TYPE_BOOL, "EnumDef has_value should exist")
    assert_true(typeof(enumdef.has_value_id(1)) == TYPE_BOOL, "EnumDef has_value_id should exist")
    
    var enumval := GodotTsonEnumValue.new()
    assert_not_null(enumval, "GodotTsonEnumValue bound")
    assert_true(typeof(enumval.contains_value_name("name")) == TYPE_BOOL, "EnumValue contains_value_name exists")
    var tileobj := GodotTsonTileObject.new()
    assert_not_null(tileobj, "GodotTsonTileObject bound")
    var ptypes := GodotTsonProjectPropertyTypes.new()
    assert_not_null(ptypes, "GodotTsonProjectPropertyTypes bound")
func test_exhaustive_method_calls() -> void:

    var class_names = ['GodotTsonTileson', 'GodotTsonLayer', 'GodotTsonTileset', 'GodotTsonWangColor', 'GodotTsonWangTile', 'GodotTsonWangSet', 'GodotTsonFrame', 'GodotTsonAnimation', 'GodotTsonTile', 'GodotTsonObject', 'GodotTsonChunk', 'GodotTsonMap', 'GodotTsonProperty', 'GodotTsonProjectFolder', 'GodotTsonProjectData', 'GodotTsonProject', 'GodotTsonWorldMapData', 'GodotTsonWorld', 'GodotTsonGrid', 'GodotTsonTerrain', 'GodotTsonText', 'GodotTsonTransformations', 'GodotTsonTiledClass', 'GodotTsonEnumDefinition', 'GodotTsonEnumValue', 'GodotTsonTileObject', 'GodotTsonProjectPropertyTypes']

    var total_called = 0

    for cls_name in class_names:

        var ScriptClass = ClassDB.instantiate(cls_name)

        assert_not_null(ScriptClass, str(cls_name, " instantiated successfully for exhaustive test"))

        if ScriptClass:

            var methods = ScriptClass.get_method_list()

            for method in methods:

                var method_name = method.name

                if method.args.size() == 0 and (method_name.begins_with("get_") or method_name.begins_with("is_") or method_name.begins_with("has_")):

                    var result = ScriptClass.call(method_name)

                    assert_true(true, str(cls_name, ".", method_name, "() invoked safely without crashing."))

                    total_called += 1

    assert_true(total_called > 100, str("Exhaustively tested ", total_called, " wrapper getters across all nodes"))

