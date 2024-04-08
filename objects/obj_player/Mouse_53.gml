var _path = a_stars(obj_map_manager.grid_map,x,y,mouse_x,mouse_y);
if(_path != false){
	path_clear_points(path);
	for(var _i = 0; _i < array_length(_path); _i++){
		var _point_x = _path[_i,0] * CELL_SIZE + (CELL_SIZE / 2);
		var _point_y = _path[_i,1] * CELL_SIZE + (CELL_SIZE / 2);
		path_add_point(path,_point_x,_point_y,200);
	}
	
	path_insert_point(path,0,x,y,200);
	path_set_closed(path,0);
	
	if(path_exists(path)){
		path_start(path,1,path_action_stop,false);
	}
}