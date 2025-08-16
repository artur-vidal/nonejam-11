// Funções de suavização. Não fui eu que fiz os cálculos, mas até que entendi os primeiros.
// Cálculos tirados de https://www.davetech.co.uk/gamemakereasingandtweeningfunctions
// Conversão para GameMaker atual feita por mim

#region Ease Linear

/// ease_linear(frame, minvalue, maxvalue, duration)
function ease_linear(_t, _min, _max, _d){
	return _max * _t / _d + _min
}

#endregion

#region Ease Quad (²)

/// ease_in_quad(frame, minvalue, maxvalue, duration)
function ease_in_quad(_t, _min, _max, _d){
	_t /= _d;
	return _max * _t * _t + _min;
}

/// ease_out_quad(frame, minvalue, maxvalue, duration)
function ease_out_quad(_t, _min, _max, _d){
	_t /= _d;
	return -_max * _t * (_t - 2) + _min
}

/// ease_in_out_quad(frame, minvalue, maxvalue, duration)
function ease_in_out_quad(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1)
	{
	    return _max * 0.5 * _t * _t + _min;
	}

	return _max * -0.5 * (--_t * (_t - 2) - 1) + _min;
}

#endregion

#region Ease Cubic (³)

/// ease_in_cubic(frame, minvalue, maxvalue, duration)
function ease_in_cubic(_t, _min, _max, _d){
	return _max * power(_t/_d, 3) + _min
}

/// ease_out_cubic(frame, minvalue, maxvalue, duration)
function ease_out_cubic(_t, _min, _max, _d){
	return _max * (power(_t/_d - 1, 3) + 1) + _min;
}

/// ease_in_out_cubic(frame, minvalue, maxvalue, duration)
function ease_in_out_cubic(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1)
	{
	   return _max * 0.5 * power(_t, 3) + _min
	}

	return _max * 0.5 * (power(_t - 2, 3) + 2) + _min
}

#endregion

#region Ease Quart (⁴)

/// ease_in_quart(frame, minvalue, maxvalue, duration)
function ease_in_quart(_t, _min, _max, _d){
	return _max * power(_t / _d, 4) + _min
}

/// ease_out_quart(frame, minvalue, maxvalue, duration)
function ease_out_quart(_t, _min, _max, _d){
	return -_max * (power(_t / _d - 1, 4) - 1) + _min
}

/// ease_in_out_quart(frame, minvalue, maxvalue, duration)
function ease_in_out_quart(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1) 
	{
	    return _max * 0.5 * power(_t, 4) + _min
	}

	return _max * -0.5 * (power(_t - 2, 4) - 2) + _min
}

#endregion

#region Ease Quint (⁵)

/// ease_in_quint(frame, minvalue, maxvalue, duration)
function ease_in_quint(_t, _min, _max, _d){
	return _max * power(_t / _d, 5) + _min
}

/// ease_out_quint(frame, minvalue, maxvalue, duration)
function ease_out_quint(_t, _min, _max, _d){
	return _max * (power(_t / _d - 1, 5) + 1) + _min
}

/// ease_in_out_quint(frame, minvalue, maxvalue, duration)
function ease_in_out_quint(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1)
	{
	    return _max * 0.5 * power(_t, 5) + _min
	}

	return _max * 0.5 * (power(_t - 2, 5) + 2) + _min
}

#endregion

#region Ease Sine (seno/cosseno)

/// ease_in_sine(frame, minvalue, maxvalue, duration)
function ease_in_sine(_t, _min, _max, _d){
	return _max * (1 - cos(_t / _d * (pi / 2))) + _min
}

/// ease_in_sine(frame, minvalue, maxvalue, duration)
function ease_out_sine(_t, _min, _max, _d){
	return _max * sin(_t / _d * (pi / 2)) + _min
}

/// ease_in_out_sine(frame, minvalue, maxvalue, duration)
function ease_in_out_sine(_t, _min, _max, _d){
	return _max * 0.5 * (1 - cos(pi * _t / _d)) + _min
}

#endregion

#region Ease Circ

/// ease_in_circ(frame, minvalue, maxvalue, duration)
function ease_in_circ(_t, _min, _max, _d){
	// This is a really radical curve... haha hidden programmer joke.
	// (não entendi :P)
	_t /= _d;
	return _max * (1 - sqrt(1 - _t * _t)) + _min
}

/// ease_out_circ(frame, minvalue, maxvalue, duration)
function ease_out_circ(_t, _min, _max, _d){
	_t = _t / _d - 1
	return _max * sqrt(1 - _t * _t) + _min
}

/// ease_in_out_circ(frame, minvalue, maxvalue, duration)
function ease_in_out_circ(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1)
	{
	    return _max * 0.5 * (1 - sqrt(1 - _t * _t)) + _min
	}

	_t -= 2
	return _max * 0.5 * (sqrt(1 - _t * _t) + 1) + _min
}

#endregion

#region Ease Expo

/// ease_in_expo(frame, minvalue, maxvalue, duration)
function ease_in_expo(_t, _min, _max, _d){
	return _max * power(2, 10 * (_t / _d - 1)) + _min
}

/// ease_out_expo(frame, minvalue, maxvalue, duration)
function ease_out_expo(_t, _min, _max, _d){
	return _max * (-power(2, -10 * _t / _d) + 1) + _min
}

/// ease_in_out_expo(frame, minvalue, maxvalue, duration)
function ease_in_out_expo(_t, _min, _max, _d){
	_t /= _d * 0.5

	if (_t < 1) 
	{
	    return _max * 0.5 * power(2, 10 * --_t) + _min
	}

	return _max * 0.5 * (-power(2, -10 * --_t) + 2) + _min
}

#endregion

#region Ease Elastic

/// ease_in_elastic(frame, minvalue, maxvalue, duration)
function ease_in_elastic(_t, _min, _max, _d){
var _s = 1.70158
var _p = 0
var _a = _max

	if (_t == 0 || _a == 0) 
	{
	    return _min
	}

	_t /= _d

	if (_t == 1) 
	{
	    return _min + _max
	}

	if (_p == 0) 
	{
	    _p = _d * 0.3
	}

	if (_a < abs(_max)) 
	{ 
	    _a = _max
	    _s = _p * 0.25 
	}
	else
	{
	    _s = _p / (2 * pi) * arcsin (_max / _a)
	}

	return -(_a * power(2,10 * (--_t)) * sin((_t * _d - _s) * (2 * pi) / _p)) + _min
}

/// ease_out_elastic(frame, minvalue, maxvalue, duration)
function ease_out_elastic(_t, _min, _max, _d){
	var _s = 1.70158
	var _p = 0
	var _a = _max

	if (_t == 0 || _a == 0)
	{
	    return _min
	}

	_t /= _d

	if (_t == 1)
	{
	    return _min + _max
	}

	if (_p == 0)
	{
	    _p = _d * 0.3
	}

	if (_a < abs(_max)) 
	{ 
	    _a = _max
	    _s = _p * 0.25
	}
	else 
	{
	    _s = _p / (2 * pi) * arcsin (_max / _a)
	}

	return _a * power(2, -10 * _t) * sin((_t * _d - _s) * (2 * pi) / _p ) + _max + _min
}

/// ease_in_out_elastic(frame, minvalue, maxvalue, duration)
function ease_in_out_elastic(_t, _min, _max, _d){
	var _s = 1.70158
	var _p = 0
	var _a = _max

	if (_t == 0 || _a == 0)
	{
	    return _min
	}

	_t /= _d * 0.5

	if (_t == 2)
	{
	    return _min + _max
	}

	if (_p == 0)
	{
	    _p = _d * (0.3 * 1.5) //Elasticidade
	}

	if (_a < abs(_max)) 
	{ 
	    _a = _max
	    _s = _p * 0.25
	}
	else
	{
	    _s = _p / (2 * pi) * arcsin (_max / _a)
	}

	if (_t < 1)
	{
	    return -0.5 * (_a * power(2, 10 * (--_t)) * sin((_t * _d - _s) * (2 * pi) / _p)) + _min
	}

	return _a * power(2, -10 * (--_t)) * sin((_t * _d - _s) * (2 * pi) / _p) * 0.5 + _max + _min
}

#endregion

#region Ease Back

/// ease_in_back(frame, minvalue, maxvalue, duration)
function ease_in_back(_t, _min, _max, _d){
	var _s = 1.70158

	_t /= _d
	return _max * _t * _t * ((_s + 1) * _t - _s) + _min
}

/// ease_out_back(frame, minvalue, maxvalue, duration)
function ease_out_back(_t, _min, _max, _d){
	var _s = 1.70158

	_t = _t / _d - 1
	return _max * (_t * _t * ((_s + 1) * _t + _s) + 1) + _min
}

/// ease_in_out_back(frame, minvalue, maxvalue, duration)
function ease_in_out_back(_t, _min, _max, _d){
	var _s = 1.70158

	_t = _t / _d * 2

	if (_t < 1)
	{
	    _s *= 1.525
	    return _max * 0.5 * (_t * _t * ((_s + 1) * _t - _s)) + _min
	}

	_t -= 2
	_s *= 1.525

	return _max * 0.5 * (_t * _t * ((_s + 1) * _t + _s) + 2) + _min
}

#endregion

#region Ease Bounce

/// ease_in_bounce(frame, minvalue, maxvalue, duration)
function ease_in_bounce(_t, _min, _max, _d){
	return _max - ease_out_bounce(_d - _t, 0, _max, _d) + _min
}

/// ease_out_bounce(frame, minvalue, maxvalue, duration)
function ease_out_bounce(_t, _min, _max, _d){
	_t /= _d

	if (_t < 1/2.75)
	{
	    return _max * 7.5625 * _t * _t + _min;
	}
	else if (_t < 2/2.75)
	{
	    _t -= 1.5/2.75;
	    return _max * (7.5625 * _t * _t + 0.75) + _min
	}
	else if (_t < 2.5/2.75)
	{
	    _t -= 2.25/2.75;
	    return _max * (7.5625 * _t * _t + 0.9375) + _min
	}
	else
	{
	    _t -= 2.625/2.75;
	    return _max * (7.5625 * _t * _t + 0.984375) + _min
	}
	
}


/// ease_in_out_bounce(frame, minvalue, maxvalue, duration)
function ease_in_out_bounce(_t, _min, _max, _d){
	
	if (_t < _d * 0.5) 
	{
	    return (ease_in_bounce(_t * 2, 0, _max, _d) * 0.5 + _min)
	}

	return (ease_out_bounce(_t * 2 - _d, 0, _max, _d) * 0.5 + _max * 0.5 + _min)
}

#endregion