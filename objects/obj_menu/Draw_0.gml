if(!activated) exit

if(!draw_past_groups){
    draw_group(20, 20, current_group)
}else{
    var i = current_group.parent_count()
    var _current_group_to_draw = current_group
    while(i > -1){
        draw_group(20 + 300 * i, 20, _current_group_to_draw)
        _current_group_to_draw = _current_group_to_draw.parent_group
        i--
    }  
}