if(show_grid){
	draw_set_alpha(0.5);
	draw_set_font(fnt_debug);
	for(var _x = 0; _x < grid_width; _x++){
		for(var _y = 0; _y < grid_height; _y++){
			var _pos = grid_map.get_cell(_x,_y);
			draw_text(_x * CELL_SIZE + 8, _y * CELL_SIZE + 8, string(_pos));
		}
	}
	draw_set_font(-1);
	draw_set_alpha(1);
}