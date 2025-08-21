val = 0
xscale = 1
yscale = 1
alpha = 1

tag = $"damage_ind:{id}_anim"

var _duration = .5

root.anim.add(
    new Animation(id, "y", y, y - 12, _duration).ease(ease_linear).tag(tag),
    
    new Animation(id, "alpha", alpha, 0, _duration).ease(ease_linear)
        .tag(tag)
        .complete_callback(instance_destroy)
        .callback_args(id),
)

