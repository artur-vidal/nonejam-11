var _txt = scribble(val)
    .starting_format("fnt_default", #E0F8D0)
    .align(1, 1)
    .blend(c_white, alpha)
    .scale(.3)
    .transform(xscale, yscale, 0)

_txt.draw(x, y)