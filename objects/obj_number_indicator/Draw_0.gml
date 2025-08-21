var _c = #e0f8d0
if(val > 0) _c = #88c070
else if(val < 0) _c = #081820

var _str = string(floor(val))
    
var _txt = scribble(_str)
    .starting_format("fnt_default", _c)
    .align(1, 1)
    .blend(c_white, alpha)
    .scale(.6)
    .transform(xscale, yscale, 0) 
    .outline(#081820)

_txt.draw(x, y)