var _c = #346856
if(val > 0) _c = #88C070
else if(val < 0) _c = #E0F8D0

var _str = (is_string(val)) ? val : floor(val)
if(val == 0) _str = "-" + string(_str)
    
var _txt = scribble(_str)
    .starting_format("fnt_default", _c)
    .align(1, 1)
    .blend(c_white, alpha)
    .scale(.6)
    .transform(xscale, yscale, 0)

_txt.draw(x, y)