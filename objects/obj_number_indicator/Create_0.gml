val = 0
xscale = 1
yscale = 1
alpha = 1

tag = $"damage_ind:{id}_anim"

var _first_duration = 1
var _second_duration = 1

var _add_x = irandom_range(16, 32)

root.anim.add(
    new Animation(id, "y", y, y + 8, _first_duration).ease(ease_out_bounce).tag(tag),
    new Animation(id, "x", x, x + _add_x, _first_duration).ease(ease_out_cubic).tag(tag),
    
    new Animation(id, "y", y + 8, y - 30, _second_duration)
        .ease(ease_linear)
        .delay(_first_duration + .5)
        .tag(tag),
        
    new Animation(id, "xscale", xscale, .01, _second_duration)
        .ease(ease_linear)
        .delay(_first_duration + .5)
        .tag(tag),
        
    new Animation(id, "alpha", alpha, 0, _second_duration)
        .ease(ease_linear)
        .delay(_first_duration + .5)
        .tag(tag)
        .complete_callback(instance_destroy)
        .callback_args(id),
)

