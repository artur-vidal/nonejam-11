var _txt = scribble(val)
    .starting_format("fnt_default", #081820)
    .align(1, 1)
    .blend(c_white, alpha)
    .scale(.3)
    .transform(xscale, yscale, 0) 
    .outline(#081820)

_txt.draw(x, y)