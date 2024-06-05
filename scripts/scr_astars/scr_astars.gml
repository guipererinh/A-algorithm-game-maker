function Grid(_grid_width,_grid_height,_val) constructor{
	grid_width = _grid_width;
	grid_height = _grid_height;
	val = _val;
	grid_arr = [];
	
	for(var _x = 0; _x < grid_width; _x++){
		for(var _y = 0; _y < grid_height; _y++){
			grid_arr[_x,_y] = val;
		}
	}
	
	static get_cell = function(_x,_y){
		if(_x < 0 or _x >= grid_width) return;
		if(_y < 0 or _y >= grid_height) return;
		return grid_arr[_x,_y];
	}
	
	static set_cell = function(_x,_y,_val){
		if(_x < 0 or _x >= grid_width) return;
		if(_y < 0 or _y >= grid_height) return;
		grid_arr[_x,_y] = _val;
	}
}

function Node(_x,_y,_g_cost,_h_cost,_parent) constructor{
	x = _x;
	y = _y;
	g_cost = _g_cost;
	h_cost = _h_cost;
	f_cost = g_cost + h_cost;
	parent = _parent;
}

function heuristic(_x1,_y1,_x2,_y2){
	return abs(_x2 - _x1) + abs(_y2 - _y1);
}

function a_stars_find_path(_grid,_xstart,_ystart,_xend,_yend){
	
	if(!is_struct(_grid)) return false;
	
	_xstart = _xstart div CELL_SIZE;
	_ystart = _ystart div CELL_SIZE;
	
	_xend = _xend div CELL_SIZE;
	_yend = _yend div CELL_SIZE;
	
	if(_grid.get_cell(_xend,_yend) == 1){
		show_debug_message("I can't go to an obstacle");
		return false;
	}
	
	var _open_list = [];
	var _closed_list = [];
	
	var _start_node = new Node(_xstart,_ystart,0,heuristic(_xstart,_ystart,_xend,_yend),-1);
	array_push(_open_list,_start_node);
	
	while(array_length(_open_list) > 0){
		
		var _cur_index = 0;
		
		for(var _i = 0; _i < array_length(_open_list); _i++){
			if(_open_list[_i].f_cost < _open_list[_cur_index].f_cost){
				_cur_index = _i;
			}
		}
		
		var _cur_node = _open_list[_cur_index];
		array_delete(_open_list,_cur_index,1);
		array_push(_closed_list,_cur_node);
		
		if(_cur_node.x == _xend and _cur_node.y == _yend){
			var _path = a_stars_get_path(_cur_node);
			show_debug_message("Path found successfully!");
			return _path;
		}
		
		var _neighbors = [[0,1],[1,0],[0,-1],[-1,0],[1,1],[-1,-1]];
		
		for(var _i = 0; _i < array_length(_neighbors); _i++){
			var _neighbor_x = _cur_node.x + _neighbors[_i,0];
			var _neighbor_y = _cur_node.y + _neighbors[_i,1];
			
			if(_neighbor_x < 0 or _neighbor_x >= _grid.grid_width or _neighbor_y < 0 or _neighbor_y >= _grid.grid_height) continue;

			if(_grid.get_cell(_neighbor_x,_neighbor_y) == 1) continue;
			
			var _new_g_cost = _cur_node.g_cost + 1;
			var _new_h_cost = heuristic(_neighbor_x,_neighbor_y,_xend,_yend);
			var _new_f_cost = _new_g_cost + _new_h_cost;
			
			var _neighbor_node = new Node(_neighbor_x,_neighbor_y,_new_g_cost,_new_h_cost,_cur_node);
			
			var _found_in_open = false;
			for(var _j = 0; _j < array_length(_open_list); _j++){
				if(_open_list[_j].x == _neighbor_node.x and _open_list[_j].y == _neighbor_node.y){
					_found_in_open = true;
					if(_new_f_cost < _open_list[_j].f_cost){
						_open_list[_j] = _neighbor_node;
					}
					break;
				}
			}
			
			if(_found_in_open) continue;
			
			var _found_in_closed = false;
			for(var _j = 0; _j < array_length(_closed_list); _j++){
				if(_closed_list[_j].x == _neighbor_node.x and _closed_list[_j].y == _neighbor_node.y){
					_found_in_closed = true;
					break;
				}
			}
			
			if(_found_in_closed) continue;
			array_push(_open_list,_neighbor_node);
		}
		
	}
	
	show_debug_message("Couldn't find the way!");
	return false;
	
}

function a_stars_follow_path(_grid,_xstart,_ystart,_xend,_yend,_path){
	var _a_path = a_stars_find_path(_grid,_xstart,_ystart,_xend,_yend);
	if(_a_path != false){
		path_clear_points(_path);
		for(var _i = 0; _i < array_length(_a_path); _i++){
			var _point_x = _a_path[_i,0] * CELL_SIZE + (CELL_SIZE / 2);
			var _point_y = _a_path[_i,1] * CELL_SIZE + (CELL_SIZE / 2);
			path_add_point(_path,_point_x,_point_y,200);
		}
	
		path_insert_point(_path,0,x,y,200);
		path_set_closed(_path,0);
	
		if(path_exists(_path)){
			path_start(_path,1,path_action_stop,false);
		}
	}
}

function a_stars_get_path(_end_node){
	var _path = [];
	var _cur_node = _end_node;
	
	while(_cur_node.parent != -1){
		array_insert(_path,0,[_cur_node.x,_cur_node.y]);
		_cur_node = _cur_node.parent;
	}
	
	return _path;
}

function a_stars_set_obstacles(_grid,_obstacle){
	if(!is_struct(_grid)) return false;
	var _grid_width = _grid.grid_width;
	var _grid_height = _grid.grid_height;
	for(var _x = 0; _x < _grid_width; _x++){
		for(var _y = 0; _y < _grid_height; _y++){
			var _pos = position_meeting(_x * CELL_SIZE, _y * CELL_SIZE,_obstacle);
			if(_pos) _grid.set_cell(_x,_y,1);
		}
	}
}

function a_stars_draw_grid(_grid){
	if(!DEBUG_MODE) return false;
	if(!is_struct(_grid)) return false;
	draw_set_font(fnt_debug);
	for(var _x = 0; _x < grid_width; _x++){
		for(var _y = 0; _y < grid_height; _y++){
			var _pos = grid_map.get_cell(_x,_y);
			draw_text(_x * CELL_SIZE + 8, _y * CELL_SIZE + 8, string(_pos));
		}
	}
	draw_set_font(-1);
}