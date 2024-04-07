for(var _x = 0; _x < grid_width; _x++){
	for(var _y = 0; _y < grid_height; _y++){
		var _pos = position_meeting(_x * CELL_SIZE, _y * CELL_SIZE,obj_wall);
		if(_pos) grid_map.set_cell(_x,_y,1);
	}
}