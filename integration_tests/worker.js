(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return $elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return $elm$core$Maybe$Nothing;
	}
}


// SEND REQUEST

var _Http_toTask = F3(function(router, toTask, request)
{
	return _Scheduler_binding(function(callback)
	{
		function done(response) {
			callback(toTask(request.expect.a(response)));
		}

		var xhr = new XMLHttpRequest();
		xhr.addEventListener('error', function() { done($elm$http$Http$NetworkError_); });
		xhr.addEventListener('timeout', function() { done($elm$http$Http$Timeout_); });
		xhr.addEventListener('load', function() { done(_Http_toResponse(request.expect.b, xhr)); });
		$elm$core$Maybe$isJust(request.tracker) && _Http_track(router, xhr, request.tracker.a);

		try {
			xhr.open(request.method, request.url, true);
		} catch (e) {
			return done($elm$http$Http$BadUrl_(request.url));
		}

		_Http_configureRequest(xhr, request);

		request.body.a && xhr.setRequestHeader('Content-Type', request.body.a);
		xhr.send(request.body.b);

		return function() { xhr.c = true; xhr.abort(); };
	});
});


// CONFIGURE

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.headers; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}
	xhr.timeout = request.timeout.a || 0;
	xhr.responseType = request.expect.d;
	xhr.withCredentials = request.allowCookiesFromOtherDomains;
}


// RESPONSES

function _Http_toResponse(toBody, xhr)
{
	return A2(
		200 <= xhr.status && xhr.status < 300 ? $elm$http$Http$GoodStatus_ : $elm$http$Http$BadStatus_,
		_Http_toMetadata(xhr),
		toBody(xhr.response)
	);
}


// METADATA

function _Http_toMetadata(xhr)
{
	return {
		url: xhr.responseURL,
		statusCode: xhr.status,
		statusText: xhr.statusText,
		headers: _Http_parseHeaders(xhr.getAllResponseHeaders())
	};
}


// HEADERS

function _Http_parseHeaders(rawHeaders)
{
	if (!rawHeaders)
	{
		return $elm$core$Dict$empty;
	}

	var headers = $elm$core$Dict$empty;
	var headerPairs = rawHeaders.split('\r\n');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf(': ');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3($elm$core$Dict$update, key, function(oldValue) {
				return $elm$core$Maybe$Just($elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}
	return headers;
}


// EXPECT

var _Http_expect = F3(function(type, toBody, toValue)
{
	return {
		$: 0,
		d: type,
		b: toBody,
		a: toValue
	};
});

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		d: expect.d,
		b: expect.b,
		a: function(x) { return func(expect.a(x)); }
	};
});

function _Http_toDataView(arrayBuffer)
{
	return new DataView(arrayBuffer);
}


// BODY and PARTS

var _Http_emptyBody = { $: 0 };
var _Http_pair = F2(function(a, b) { return { $: 0, a: a, b: b }; });

function _Http_toFormData(parts)
{
	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}
	return formData;
}

var _Http_bytesToBlob = F2(function(mime, bytes)
{
	return new Blob([bytes], { type: mime });
});


// PROGRESS

function _Http_track(router, xhr, tracker)
{
	// TODO check out lengthComputable on loadstart event

	xhr.upload.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Sending({
			sent: event.loaded,
			size: event.total
		}))));
	});
	xhr.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Receiving({
			received: event.loaded,
			size: event.lengthComputable ? $elm$core$Maybe$Just(event.total) : $elm$core$Maybe$Nothing
		}))));
	});
}



// STRINGS


var _Parser_isSubString = F5(function(smallString, offset, row, col, bigString)
{
	var smallLength = smallString.length;
	var isGood = offset + smallLength <= bigString.length;

	for (var i = 0; isGood && i < smallLength; )
	{
		var code = bigString.charCodeAt(offset);
		isGood =
			smallString[i++] === bigString[offset++]
			&& (
				code === 0x000A /* \n */
					? ( row++, col=1 )
					: ( col++, (code & 0xF800) === 0xD800 ? smallString[i++] === bigString[offset++] : 1 )
			)
	}

	return _Utils_Tuple3(isGood ? offset : -1, row, col);
});



// CHARS


var _Parser_isSubChar = F3(function(predicate, offset, string)
{
	return (
		string.length <= offset
			? -1
			:
		(string.charCodeAt(offset) & 0xF800) === 0xD800
			? (predicate(_Utils_chr(string.substr(offset, 2))) ? offset + 2 : -1)
			:
		(predicate(_Utils_chr(string[offset]))
			? ((string[offset] === '\n') ? -2 : (offset + 1))
			: -1
		)
	);
});


var _Parser_isAsciiCode = F3(function(code, offset, string)
{
	return string.charCodeAt(offset) === code;
});



// NUMBERS


var _Parser_chompBase10 = F2(function(offset, string)
{
	for (; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (code < 0x30 || 0x39 < code)
		{
			return offset;
		}
	}
	return offset;
});


var _Parser_consumeBase = F3(function(base, offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var digit = string.charCodeAt(offset) - 0x30;
		if (digit < 0 || base <= digit) break;
		total = base * total + digit;
	}
	return _Utils_Tuple2(offset, total);
});


var _Parser_consumeBase16 = F2(function(offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (0x30 <= code && code <= 0x39)
		{
			total = 16 * total + code - 0x30;
		}
		else if (0x41 <= code && code <= 0x46)
		{
			total = 16 * total + code - 55;
		}
		else if (0x61 <= code && code <= 0x66)
		{
			total = 16 * total + code - 87;
		}
		else
		{
			break;
		}
	}
	return _Utils_Tuple2(offset, total);
});



// FIND STRING


var _Parser_findSubString = F5(function(smallString, offset, row, col, bigString)
{
	var newOffset = bigString.indexOf(smallString, offset);
	var target = newOffset < 0 ? bigString.length : newOffset + smallString.length;

	while (offset < target)
	{
		var code = bigString.charCodeAt(offset++);
		code === 0x000A /* \n */
			? ( col=1, row++ )
			: ( col++, (code & 0xF800) === 0xD800 && offset++ )
	}

	return _Utils_Tuple3(newOffset, row, col);
});
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $author$project$Firestore$Firestore = function (a) {
	return {$: 'Firestore', a: a};
};
var $author$project$Firestore$init = function (config) {
	return $author$project$Firestore$Firestore(config);
};
var $author$project$Firestore$Config$Config = function (a) {
	return {$: 'Config', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $IzumiSy$elm_typed$Typed$Typed = function (a) {
	return {$: 'Typed', a: a};
};
var $IzumiSy$elm_typed$Typed$new = $IzumiSy$elm_typed$Typed$Typed;
var $author$project$Firestore$Config$defaultDatabase = $IzumiSy$elm_typed$Typed$new('(default)');
var $author$project$Firestore$Config$new = function (config) {
	return $author$project$Firestore$Config$Config(
		{
			apiKey: $IzumiSy$elm_typed$Typed$new(config.apiKey),
			authorization: $elm$core$Maybe$Nothing,
			baseUrl: $IzumiSy$elm_typed$Typed$new('https://firestore.googleapis.com'),
			database: $author$project$Firestore$Config$defaultDatabase,
			project: $IzumiSy$elm_typed$Typed$new(config.project)
		});
};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$Firestore$Config$withHost = F3(
	function (host, port_, _v0) {
		var config = _v0.a;
		return $author$project$Firestore$Config$Config(
			_Utils_update(
				config,
				{
					baseUrl: $IzumiSy$elm_typed$Typed$new(
						host + (':' + $elm$core$String$fromInt(port_)))
				}));
	});
var $author$project$Worker$init = function (_v0) {
	return _Utils_Tuple2(
		$author$project$Firestore$init(
			A3(
				$author$project$Firestore$Config$withHost,
				'http://localhost',
				8080,
				$author$project$Firestore$Config$new(
					{apiKey: 'test-api-key', project: 'elm-firestore-test'}))),
		$elm$core$Platform$Cmd$none);
};
var $author$project$Worker$RunTestCreate = function (a) {
	return {$: 'RunTestCreate', a: a};
};
var $author$project$Worker$RunTestDelete = function (a) {
	return {$: 'RunTestDelete', a: a};
};
var $author$project$Worker$RunTestDeleteExisting = function (a) {
	return {$: 'RunTestDeleteExisting', a: a};
};
var $author$project$Worker$RunTestDeleteExistingFail = function (a) {
	return {$: 'RunTestDeleteExistingFail', a: a};
};
var $author$project$Worker$RunTestGet = function (a) {
	return {$: 'RunTestGet', a: a};
};
var $author$project$Worker$RunTestGetTx = function (a) {
	return {$: 'RunTestGetTx', a: a};
};
var $author$project$Worker$RunTestInsert = function (a) {
	return {$: 'RunTestInsert', a: a};
};
var $author$project$Worker$RunTestListAsc = function (a) {
	return {$: 'RunTestListAsc', a: a};
};
var $author$project$Worker$RunTestListDesc = function (a) {
	return {$: 'RunTestListDesc', a: a};
};
var $author$project$Worker$RunTestListPageSize = function (a) {
	return {$: 'RunTestListPageSize', a: a};
};
var $author$project$Worker$RunTestListPageToken = function (a) {
	return {$: 'RunTestListPageToken', a: a};
};
var $author$project$Worker$RunTestListTx = function (a) {
	return {$: 'RunTestListTx', a: a};
};
var $author$project$Worker$RunTestPatch = function (a) {
	return {$: 'RunTestPatch', a: a};
};
var $author$project$Worker$RunTestQueryComplex = function (a) {
	return {$: 'RunTestQueryComplex', a: a};
};
var $author$project$Worker$RunTestQueryCompositeOp = function (a) {
	return {$: 'RunTestQueryCompositeOp', a: a};
};
var $author$project$Worker$RunTestQueryEmpty = function (a) {
	return {$: 'RunTestQueryEmpty', a: a};
};
var $author$project$Worker$RunTestQueryFieldOp = function (a) {
	return {$: 'RunTestQueryFieldOp', a: a};
};
var $author$project$Worker$RunTestQueryOrderBy = function (a) {
	return {$: 'RunTestQueryOrderBy', a: a};
};
var $author$project$Worker$RunTestQueryTx = function (a) {
	return {$: 'RunTestQueryTx', a: a};
};
var $author$project$Worker$RunTestQueryUnaryOp = function (a) {
	return {$: 'RunTestQueryUnaryOp', a: a};
};
var $author$project$Worker$RunTestTransaction = function (a) {
	return {$: 'RunTestTransaction', a: a};
};
var $author$project$Worker$RunTestUpsert = function (a) {
	return {$: 'RunTestUpsert', a: a};
};
var $author$project$Worker$RunTestUpsertExisting = function (a) {
	return {$: 'RunTestUpsertExisting', a: a};
};
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$json$Json$Decode$null = _Json_decodeNull;
var $author$project$Worker$runTestCreate = _Platform_incomingPort(
	'runTestCreate',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestDelete = _Platform_incomingPort(
	'runTestDelete',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestDeleteExisting = _Platform_incomingPort(
	'runTestDeleteExisting',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestDeleteExistingFail = _Platform_incomingPort(
	'runTestDeleteExistingFail',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestGet = _Platform_incomingPort(
	'runTestGet',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestGetTx = _Platform_incomingPort(
	'runTestGetTx',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestInsert = _Platform_incomingPort(
	'runTestInsert',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestListAsc = _Platform_incomingPort(
	'runTestListAsc',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestListDesc = _Platform_incomingPort(
	'runTestListDesc',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestListPageSize = _Platform_incomingPort(
	'runTestListPageSize',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestListPageToken = _Platform_incomingPort(
	'runTestListPageToken',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestListTx = _Platform_incomingPort(
	'runTestListTx',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestPatch = _Platform_incomingPort(
	'runTestPatch',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryComplex = _Platform_incomingPort(
	'runTestQueryComplex',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryCompositeOp = _Platform_incomingPort(
	'runTestQueryCompositeOp',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryEmpty = _Platform_incomingPort(
	'runTestQueryEmpty',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryFieldOp = _Platform_incomingPort(
	'runTestQueryFieldOp',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryOrderBy = _Platform_incomingPort(
	'runTestQueryOrderBy',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryTx = _Platform_incomingPort(
	'runTestQueryTx',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestQueryUnaryOp = _Platform_incomingPort(
	'runTestQueryUnaryOp',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestTransaction = _Platform_incomingPort(
	'runTestTransaction',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestUpsert = _Platform_incomingPort(
	'runTestUpsert',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$runTestUpsertExisting = _Platform_incomingPort(
	'runTestUpsertExisting',
	$elm$json$Json$Decode$null(_Utils_Tuple0));
var $author$project$Worker$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				$author$project$Worker$runTestGet($author$project$Worker$RunTestGet),
				$author$project$Worker$runTestListPageToken($author$project$Worker$RunTestListPageToken),
				$author$project$Worker$runTestListPageSize($author$project$Worker$RunTestListPageSize),
				$author$project$Worker$runTestListDesc($author$project$Worker$RunTestListDesc),
				$author$project$Worker$runTestListAsc($author$project$Worker$RunTestListAsc),
				$author$project$Worker$runTestQueryFieldOp($author$project$Worker$RunTestQueryFieldOp),
				$author$project$Worker$runTestQueryCompositeOp($author$project$Worker$RunTestQueryCompositeOp),
				$author$project$Worker$runTestQueryUnaryOp($author$project$Worker$RunTestQueryUnaryOp),
				$author$project$Worker$runTestQueryOrderBy($author$project$Worker$RunTestQueryOrderBy),
				$author$project$Worker$runTestQueryEmpty($author$project$Worker$RunTestQueryEmpty),
				$author$project$Worker$runTestQueryComplex($author$project$Worker$RunTestQueryComplex),
				$author$project$Worker$runTestInsert($author$project$Worker$RunTestInsert),
				$author$project$Worker$runTestCreate($author$project$Worker$RunTestCreate),
				$author$project$Worker$runTestUpsert($author$project$Worker$RunTestUpsert),
				$author$project$Worker$runTestUpsertExisting($author$project$Worker$RunTestUpsertExisting),
				$author$project$Worker$runTestPatch($author$project$Worker$RunTestPatch),
				$author$project$Worker$runTestDelete($author$project$Worker$RunTestDelete),
				$author$project$Worker$runTestDeleteExisting($author$project$Worker$RunTestDeleteExisting),
				$author$project$Worker$runTestDeleteExistingFail($author$project$Worker$RunTestDeleteExistingFail),
				$author$project$Worker$runTestTransaction($author$project$Worker$RunTestTransaction),
				$author$project$Worker$runTestGetTx($author$project$Worker$RunTestGetTx),
				$author$project$Worker$runTestListTx($author$project$Worker$RunTestListTx),
				$author$project$Worker$runTestQueryTx($author$project$Worker$RunTestQueryTx)
			]));
};
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $author$project$Firestore$Query$And = {$: 'And'};
var $author$project$Firestore$Options$List$Asc = function (a) {
	return {$: 'Asc', a: a};
};
var $elm$http$Http$BadStatus = function (a) {
	return {$: 'BadStatus', a: a};
};
var $author$project$Firestore$Options$List$Desc = function (a) {
	return {$: 'Desc', a: a};
};
var $author$project$Firestore$Query$Descending = {$: 'Descending'};
var $author$project$Firestore$Query$Equal = {$: 'Equal'};
var $author$project$Firestore$Query$GreaterThanOrEqual = {$: 'GreaterThanOrEqual'};
var $author$project$Firestore$Http_ = function (a) {
	return {$: 'Http_', a: a};
};
var $author$project$Firestore$Query$IsNull = {$: 'IsNull'};
var $author$project$Firestore$Query$LessThan = {$: 'LessThan'};
var $author$project$Firestore$Query$LessThanOrEqual = {$: 'LessThanOrEqual'};
var $author$project$Worker$RanTestCreate = function (a) {
	return {$: 'RanTestCreate', a: a};
};
var $author$project$Worker$RanTestDelete = function (a) {
	return {$: 'RanTestDelete', a: a};
};
var $author$project$Worker$RanTestDeleteExisting = function (a) {
	return {$: 'RanTestDeleteExisting', a: a};
};
var $author$project$Worker$RanTestDeleteExistingFail = function (a) {
	return {$: 'RanTestDeleteExistingFail', a: a};
};
var $author$project$Worker$RanTestGet = function (a) {
	return {$: 'RanTestGet', a: a};
};
var $author$project$Worker$RanTestGetTx = function (a) {
	return {$: 'RanTestGetTx', a: a};
};
var $author$project$Worker$RanTestInsert = function (a) {
	return {$: 'RanTestInsert', a: a};
};
var $author$project$Worker$RanTestListAsc = function (a) {
	return {$: 'RanTestListAsc', a: a};
};
var $author$project$Worker$RanTestListDesc = function (a) {
	return {$: 'RanTestListDesc', a: a};
};
var $author$project$Worker$RanTestListPageSize = function (a) {
	return {$: 'RanTestListPageSize', a: a};
};
var $author$project$Worker$RanTestListPageToken = function (a) {
	return {$: 'RanTestListPageToken', a: a};
};
var $author$project$Worker$RanTestListTx = function (a) {
	return {$: 'RanTestListTx', a: a};
};
var $author$project$Worker$RanTestPatch = function (a) {
	return {$: 'RanTestPatch', a: a};
};
var $author$project$Worker$RanTestQueryComplex = function (a) {
	return {$: 'RanTestQueryComplex', a: a};
};
var $author$project$Worker$RanTestQueryCompositeOp = function (a) {
	return {$: 'RanTestQueryCompositeOp', a: a};
};
var $author$project$Worker$RanTestQueryEmpty = function (a) {
	return {$: 'RanTestQueryEmpty', a: a};
};
var $author$project$Worker$RanTestQueryFieldOp = function (a) {
	return {$: 'RanTestQueryFieldOp', a: a};
};
var $author$project$Worker$RanTestQueryOrderBy = function (a) {
	return {$: 'RanTestQueryOrderBy', a: a};
};
var $author$project$Worker$RanTestQueryTx = function (a) {
	return {$: 'RanTestQueryTx', a: a};
};
var $author$project$Worker$RanTestQueryUnaryOp = function (a) {
	return {$: 'RanTestQueryUnaryOp', a: a};
};
var $author$project$Worker$RanTestTransaction = function (a) {
	return {$: 'RanTestTransaction', a: a};
};
var $author$project$Worker$RanTestUpsert = function (a) {
	return {$: 'RanTestUpsert', a: a};
};
var $author$project$Worker$RanTestUpsertExisting = function (a) {
	return {$: 'RanTestUpsertExisting', a: a};
};
var $author$project$Firestore$Options$Patch$Options = function (a) {
	return {$: 'Options', a: a};
};
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A3($elm$core$Dict$insert, key, _Utils_Tuple0, dict));
	});
var $author$project$Firestore$Options$Patch$addDelete = F2(
	function (path, _v0) {
		var options = _v0.a;
		return $author$project$Firestore$Options$Patch$Options(
			_Utils_update(
				options,
				{
					deletes: A2($elm$core$Set$insert, path, options.deletes)
				}));
	});
var $author$project$Firestore$Options$Patch$addUpdate = F3(
	function (path, field, _v0) {
		var options = _v0.a;
		return $author$project$Firestore$Options$Patch$Options(
			_Utils_update(
				options,
				{
					updateFields: A3($elm$core$Dict$insert, path, field, options.updateFields),
					updates: A2($elm$core$Set$insert, path, options.updates)
				}));
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $author$project$Firestore$Codec$asDecoder = function (_v0) {
	var out = _v0.a;
	return out;
};
var $author$project$Firestore$Codec$asEncoder = function (_v0) {
	var out = _v0.b;
	return out;
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$core$Task$onError = _Scheduler_onError;
var $elm$core$Task$attempt = F2(
	function (resultToMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2(
					$elm$core$Task$onError,
					A2(
						$elm$core$Basics$composeL,
						A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
						$elm$core$Result$Err),
					A2(
						$elm$core$Task$andThen,
						A2(
							$elm$core$Basics$composeL,
							A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
							$elm$core$Result$Ok),
						task))));
	});
var $author$project$Firestore$Config$Op = function (a) {
	return {$: 'Op', a: a};
};
var $author$project$Firestore$Transaction = F3(
	function (a, b, c) {
		return {$: 'Transaction', a: a, b: b, c: c};
	});
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $author$project$Firestore$beginEncoder = $elm$json$Json$Encode$object(
	_List_fromArray(
		[
			_Utils_Tuple2(
			'options',
			$elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'readWrite',
						$elm$json$Json$Encode$object(_List_Nil))
					])))
		]));
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$url$Url$Builder$toQueryPair = function (_v0) {
	var key = _v0.a;
	var value = _v0.b;
	return key + ('=' + value);
};
var $elm$url$Url$Builder$toQuery = function (parameters) {
	if (!parameters.b) {
		return '';
	} else {
		return '?' + A2(
			$elm$core$String$join,
			'&',
			A2($elm$core$List$map, $elm$url$Url$Builder$toQueryPair, parameters));
	}
};
var $elm$url$Url$Builder$relative = F2(
	function (pathSegments, parameters) {
		return _Utils_ap(
			A2($elm$core$String$join, '/', pathSegments),
			$elm$url$Url$Builder$toQuery(parameters));
	});
var $IzumiSy$elm_typed$Typed$value = function (_v0) {
	var value_ = _v0.a;
	return value_;
};
var $author$project$Firestore$Config$basePath = function (_v0) {
	var project = _v0.a.project;
	var database = _v0.a.database;
	return A2(
		$elm$url$Url$Builder$relative,
		_List_fromArray(
			[
				'projects',
				$IzumiSy$elm_typed$Typed$value(project),
				'databases',
				$IzumiSy$elm_typed$Typed$value(database),
				'documents'
			]),
		_List_Nil);
};
var $elm$url$Url$Builder$crossOrigin = F3(
	function (prePath, pathSegments, parameters) {
		return prePath + ('/' + (A2($elm$core$String$join, '/', pathSegments) + $elm$url$Url$Builder$toQuery(parameters)));
	});
var $elm$url$Url$Builder$QueryParameter = F2(
	function (a, b) {
		return {$: 'QueryParameter', a: a, b: b};
	});
var $elm$url$Url$percentEncode = _Url_percentEncode;
var $elm$url$Url$Builder$string = F2(
	function (key, value) {
		return A2(
			$elm$url$Url$Builder$QueryParameter,
			$elm$url$Url$percentEncode(key),
			$elm$url$Url$percentEncode(value));
	});
var $author$project$Firestore$Config$endpoint = F3(
	function (params, appender, config) {
		var apiKey = config.a.apiKey;
		var baseUrl = config.a.baseUrl;
		var path = function () {
			if (appender.$ === 'Path') {
				var value = appender.a;
				return _List_fromArray(
					[
						$author$project$Firestore$Config$basePath(config),
						value
					]);
			} else {
				var value = appender.a;
				return _List_fromArray(
					[
						$author$project$Firestore$Config$basePath(config) + (':' + value)
					]);
			}
		}();
		return A3(
			$elm$url$Url$Builder$crossOrigin,
			$IzumiSy$elm_typed$Typed$value(baseUrl),
			A2($elm$core$List$cons, 'v1beta1', path),
			A2(
				$elm$core$List$append,
				params,
				_List_fromArray(
					[
						A2(
						$elm$url$Url$Builder$string,
						'key',
						$IzumiSy$elm_typed$Typed$value(apiKey))
					])));
	});
var $elm$http$Http$Header = F2(
	function (a, b) {
		return {$: 'Header', a: a, b: b};
	});
var $elm$http$Http$header = $elm$http$Http$Header;
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Firestore$Config$httpHeader = function (_v0) {
	var authorization = _v0.a.authorization;
	return A2(
		$elm$core$Maybe$withDefault,
		_List_Nil,
		A2(
			$elm$core$Maybe$map,
			$elm$core$List$singleton,
			A2(
				$elm$core$Maybe$map,
				$elm$http$Http$header('Bearer'),
				A2($elm$core$Maybe$map, $IzumiSy$elm_typed$Typed$value, authorization))));
};
var $elm$http$Http$BadStatus_ = F2(
	function (a, b) {
		return {$: 'BadStatus_', a: a, b: b};
	});
var $elm$http$Http$BadUrl_ = function (a) {
	return {$: 'BadUrl_', a: a};
};
var $elm$http$Http$GoodStatus_ = F2(
	function (a, b) {
		return {$: 'GoodStatus_', a: a, b: b};
	});
var $elm$http$Http$NetworkError_ = {$: 'NetworkError_'};
var $elm$http$Http$Receiving = function (a) {
	return {$: 'Receiving', a: a};
};
var $elm$http$Http$Sending = function (a) {
	return {$: 'Sending', a: a};
};
var $elm$http$Http$Timeout_ = {$: 'Timeout_'};
var $elm$core$Maybe$isJust = function (maybe) {
	if (maybe.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (_v0.$ === 'Just') {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$http$Http$jsonBody = function (value) {
	return A2(
		_Http_pair,
		'application/json',
		A2($elm$json$Json$Encode$encode, 0, value));
};
var $elm$http$Http$BadBody = function (a) {
	return {$: 'BadBody', a: a};
};
var $elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var $elm$http$Http$NetworkError = {$: 'NetworkError'};
var $elm$http$Http$Timeout = {$: 'Timeout'};
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $author$project$Firestore$Response = function (a) {
	return {$: 'Response', a: a};
};
var $author$project$Firestore$FirestoreError = F3(
	function (code, message, status) {
		return {code: code, message: message, status: status};
	});
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom = $elm$json$Json$Decode$map2($elm$core$Basics$apR);
var $elm$json$Json$Decode$field = _Json_decodeField;
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required = F3(
	function (key, valDecoder, decoder) {
		return A2(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom,
			A2($elm$json$Json$Decode$field, key, valDecoder),
			decoder);
	});
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$Firestore$errorInfoDecoder = A3(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
	'status',
	$elm$json$Json$Decode$string,
	A3(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
		'message',
		$elm$json$Json$Decode$string,
		A3(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
			'code',
			$elm$json$Json$Decode$int,
			$elm$json$Json$Decode$succeed($author$project$Firestore$FirestoreError))));
var $author$project$Firestore$errorDecoder = A3(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
	'error',
	$author$project$Firestore$errorInfoDecoder,
	$elm$json$Json$Decode$succeed($author$project$Firestore$Response));
var $elm$http$Http$stringResolver = A2(_Http_expect, '', $elm$core$Basics$identity);
var $author$project$Firestore$jsonResolver = function (decoder) {
	return $elm$http$Http$stringResolver(
		function (response) {
			switch (response.$) {
				case 'BadUrl_':
					var url = response.a;
					return $elm$core$Result$Err(
						$author$project$Firestore$Http_(
							$elm$http$Http$BadUrl(url)));
				case 'Timeout_':
					return $elm$core$Result$Err(
						$author$project$Firestore$Http_($elm$http$Http$Timeout));
				case 'NetworkError_':
					return $elm$core$Result$Err(
						$author$project$Firestore$Http_($elm$http$Http$NetworkError));
				case 'BadStatus_':
					var statusCode = response.a.statusCode;
					var body = response.b;
					var _v1 = A2($elm$json$Json$Decode$decodeString, $author$project$Firestore$errorDecoder, body);
					if (_v1.$ === 'Err') {
						return $elm$core$Result$Err(
							$author$project$Firestore$Http_(
								$elm$http$Http$BadStatus(statusCode)));
					} else {
						var firestoreError = _v1.a;
						return $elm$core$Result$Err(firestoreError);
					}
				default:
					var body = response.b;
					var _v2 = A2($elm$json$Json$Decode$decodeString, decoder, body);
					if (_v2.$ === 'Err') {
						return $elm$core$Result$Err(
							$author$project$Firestore$Http_(
								$elm$http$Http$BadBody(body)));
					} else {
						var result = _v2.a;
						return $elm$core$Result$Ok(result);
					}
			}
		});
};
var $elm$core$Task$fail = _Scheduler_fail;
var $elm$http$Http$resultToTask = function (result) {
	if (result.$ === 'Ok') {
		var a = result.a;
		return $elm$core$Task$succeed(a);
	} else {
		var x = result.a;
		return $elm$core$Task$fail(x);
	}
};
var $elm$http$Http$task = function (r) {
	return A3(
		_Http_toTask,
		_Utils_Tuple0,
		$elm$http$Http$resultToTask,
		{allowCookiesFromOtherDomains: false, body: r.body, expect: r.resolver, headers: r.headers, method: r.method, timeout: r.timeout, tracker: $elm$core$Maybe$Nothing, url: r.url});
};
var $author$project$Firestore$TransactionId = function (a) {
	return {$: 'TransactionId', a: a};
};
var $elm$json$Json$Decode$map = _Json_map1;
var $author$project$Firestore$transactionDecoder = A2(
	$elm$json$Json$Decode$field,
	'transaction',
	A2($elm$json$Json$Decode$map, $author$project$Firestore$TransactionId, $elm$json$Json$Decode$string));
var $author$project$Firestore$begin = function (_v0) {
	var config = _v0.a;
	return A2(
		$elm$core$Task$map,
		function (transaction) {
			return A3($author$project$Firestore$Transaction, transaction, $elm$core$Dict$empty, $elm$core$Set$empty);
		},
		$elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody($author$project$Firestore$beginEncoder),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'POST',
				resolver: $author$project$Firestore$jsonResolver($author$project$Firestore$transactionDecoder),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_Nil,
					$author$project$Firestore$Config$Op('beginTransaction'),
					config)
			}));
};
var $author$project$Worker$User = F2(
	function (name, age) {
		return {age: age, name: name};
	});
var $author$project$Firestore$Codec$Codec = F2(
	function (a, b) {
		return {$: 'Codec', a: a, b: b};
	});
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $author$project$Firestore$Encode$Encoder = function (a) {
	return {$: 'Encoder', a: a};
};
var $author$project$Firestore$Encode$document = $author$project$Firestore$Encode$Encoder;
var $author$project$Firestore$Codec$build = function (_v0) {
	var d = _v0.a;
	var e = _v0.b;
	return A2(
		$author$project$Firestore$Codec$Codec,
		d,
		A2($elm$core$Basics$composeR, e, $author$project$Firestore$Encode$document));
};
var $author$project$Firestore$Codec$Document = F2(
	function (a, b) {
		return {$: 'Document', a: a, b: b};
	});
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $author$project$Firestore$Decode$Decoder = function (a) {
	return {$: 'Decoder', a: a};
};
var $author$project$Firestore$Decode$document = A2($elm$core$Basics$composeL, $author$project$Firestore$Decode$Decoder, $elm$json$Json$Decode$succeed);
var $author$project$Firestore$Codec$document = function (fun) {
	return A2(
		$author$project$Firestore$Codec$Document,
		$author$project$Firestore$Decode$document(fun),
		$elm$core$Basics$always(_List_Nil));
};
var $author$project$Firestore$Codec$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $author$project$Firestore$Decode$Field = function (a) {
	return {$: 'Field', a: a};
};
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$core$String$toInt = _String_toInt;
var $author$project$Firestore$Decode$int = $author$project$Firestore$Decode$Field(
	A2(
		$elm$json$Json$Decode$andThen,
		function (value) {
			return A2(
				$elm$core$Maybe$withDefault,
				$elm$json$Json$Decode$fail('Unconvertable string to int'),
				A2(
					$elm$core$Maybe$map,
					$elm$json$Json$Decode$succeed,
					$elm$core$String$toInt(value)));
		},
		A2($elm$json$Json$Decode$field, 'integerValue', $elm$json$Json$Decode$string)));
var $author$project$Firestore$Encode$Field = function (a) {
	return {$: 'Field', a: a};
};
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Firestore$Internals$Encode$int = function (value) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'integerValue',
				$elm$json$Json$Encode$string(
					$elm$core$String$fromInt(value)))
			]));
};
var $author$project$Firestore$Encode$int = A2($elm$core$Basics$composeL, $author$project$Firestore$Encode$Field, $author$project$Firestore$Internals$Encode$int);
var $author$project$Firestore$Codec$int = A2($author$project$Firestore$Codec$Field, $author$project$Firestore$Decode$int, $author$project$Firestore$Encode$int);
var $author$project$Firestore$Decode$required = F3(
	function (name, _v0, _v1) {
		var fieldDecoder = _v0.a;
		var encoder = _v1.a;
		return $author$project$Firestore$Decode$Decoder(
			A3($NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required, name, fieldDecoder, encoder));
	});
var $author$project$Firestore$Codec$required = F4(
	function (name, getter, _v0, _v1) {
		var dField = _v0.a;
		var eField = _v0.b;
		var d = _v1.a;
		var e = _v1.b;
		return A2(
			$author$project$Firestore$Codec$Document,
			A3($author$project$Firestore$Decode$required, name, dField, d),
			function (value) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(
						name,
						eField(
							getter(value))),
					e(value));
			});
	});
var $author$project$Firestore$Decode$string = $author$project$Firestore$Decode$Field(
	A2($elm$json$Json$Decode$field, 'stringValue', $elm$json$Json$Decode$string));
var $author$project$Firestore$Internals$Encode$string = function (value) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'stringValue',
				$elm$json$Json$Encode$string(value))
			]));
};
var $author$project$Firestore$Encode$string = A2($elm$core$Basics$composeL, $author$project$Firestore$Encode$Field, $author$project$Firestore$Internals$Encode$string);
var $author$project$Firestore$Codec$string = A2($author$project$Firestore$Codec$Field, $author$project$Firestore$Decode$string, $author$project$Firestore$Encode$string);
var $author$project$Worker$codec = $author$project$Firestore$Codec$build(
	A4(
		$author$project$Firestore$Codec$required,
		'age',
		function ($) {
			return $.age;
		},
		$author$project$Firestore$Codec$int,
		A4(
			$author$project$Firestore$Codec$required,
			'name',
			function ($) {
				return $.name;
			},
			$author$project$Firestore$Codec$string,
			$author$project$Firestore$Codec$document($author$project$Worker$User))));
var $elm$parser$Parser$deadEndsToString = function (deadEnds) {
	return 'TODO deadEndsToString';
};
var $elm$parser$Parser$Advanced$Bad = F2(
	function (a, b) {
		return {$: 'Bad', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$Good = F3(
	function (a, b, c) {
		return {$: 'Good', a: a, b: b, c: c};
	});
var $elm$parser$Parser$Advanced$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var $elm$parser$Parser$Advanced$andThen = F2(
	function (callback, _v0) {
		var parseA = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parseA(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					var _v2 = callback(a);
					var parseB = _v2.a;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3($elm$parser$Parser$Advanced$Good, p1 || p2, b, s2);
					}
				}
			});
	});
var $elm$parser$Parser$andThen = $elm$parser$Parser$Advanced$andThen;
var $elm$parser$Parser$ExpectingEnd = {$: 'ExpectingEnd'};
var $elm$parser$Parser$Advanced$AddRight = F2(
	function (a, b) {
		return {$: 'AddRight', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$DeadEnd = F4(
	function (row, col, problem, contextStack) {
		return {col: col, contextStack: contextStack, problem: problem, row: row};
	});
var $elm$parser$Parser$Advanced$Empty = {$: 'Empty'};
var $elm$parser$Parser$Advanced$fromState = F2(
	function (s, x) {
		return A2(
			$elm$parser$Parser$Advanced$AddRight,
			$elm$parser$Parser$Advanced$Empty,
			A4($elm$parser$Parser$Advanced$DeadEnd, s.row, s.col, x, s.context));
	});
var $elm$core$String$length = _String_length;
var $elm$parser$Parser$Advanced$end = function (x) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return _Utils_eq(
				$elm$core$String$length(s.src),
				s.offset) ? A3($elm$parser$Parser$Advanced$Good, false, _Utils_Tuple0, s) : A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, x));
		});
};
var $elm$parser$Parser$end = $elm$parser$Parser$Advanced$end($elm$parser$Parser$ExpectingEnd);
var $elm$parser$Parser$Advanced$isSubChar = _Parser_isSubChar;
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $elm$parser$Parser$Advanced$chompWhileHelp = F5(
	function (isGood, offset, row, col, s0) {
		chompWhileHelp:
		while (true) {
			var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, offset, s0.src);
			if (_Utils_eq(newOffset, -1)) {
				return A3(
					$elm$parser$Parser$Advanced$Good,
					_Utils_cmp(s0.offset, offset) < 0,
					_Utils_Tuple0,
					{col: col, context: s0.context, indent: s0.indent, offset: offset, row: row, src: s0.src});
			} else {
				if (_Utils_eq(newOffset, -2)) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				} else {
					var $temp$isGood = isGood,
						$temp$offset = newOffset,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$chompWhile = function (isGood) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A5($elm$parser$Parser$Advanced$chompWhileHelp, isGood, s.offset, s.row, s.col, s);
		});
};
var $elm$parser$Parser$chompWhile = $elm$parser$Parser$Advanced$chompWhile;
var $elm$core$String$slice = _String_slice;
var $elm$parser$Parser$Advanced$mapChompedString = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						A2(
							func,
							A3($elm$core$String$slice, s0.offset, s1.offset, s0.src),
							a),
						s1);
				}
			});
	});
var $elm$parser$Parser$Advanced$getChompedString = function (parser) {
	return A2($elm$parser$Parser$Advanced$mapChompedString, $elm$core$Basics$always, parser);
};
var $elm$parser$Parser$getChompedString = $elm$parser$Parser$Advanced$getChompedString;
var $elm$parser$Parser$Problem = function (a) {
	return {$: 'Problem', a: a};
};
var $elm$parser$Parser$Advanced$problem = function (x) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, x));
		});
};
var $elm$parser$Parser$problem = function (msg) {
	return $elm$parser$Parser$Advanced$problem(
		$elm$parser$Parser$Problem(msg));
};
var $elm$core$Basics$round = _Basics_round;
var $elm$parser$Parser$Advanced$succeed = function (a) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$Good, false, a, s);
		});
};
var $elm$parser$Parser$succeed = $elm$parser$Parser$Advanced$succeed;
var $elm$core$String$toFloat = _String_toFloat;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$fractionsOfASecondInMs = A2(
	$elm$parser$Parser$andThen,
	function (str) {
		if ($elm$core$String$length(str) <= 9) {
			var _v0 = $elm$core$String$toFloat('0.' + str);
			if (_v0.$ === 'Just') {
				var floatVal = _v0.a;
				return $elm$parser$Parser$succeed(
					$elm$core$Basics$round(floatVal * 1000));
			} else {
				return $elm$parser$Parser$problem('Invalid float: \"' + (str + '\"'));
			}
		} else {
			return $elm$parser$Parser$problem(
				'Expected at most 9 digits, but got ' + $elm$core$String$fromInt(
					$elm$core$String$length(str)));
		}
	},
	$elm$parser$Parser$getChompedString(
		$elm$parser$Parser$chompWhile($elm$core$Char$isDigit)));
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$fromParts = F6(
	function (monthYearDayMs, hour, minute, second, ms, utcOffsetMinutes) {
		return $elm$time$Time$millisToPosix((((monthYearDayMs + (((hour * 60) * 60) * 1000)) + (((minute - utcOffsetMinutes) * 60) * 1000)) + (second * 1000)) + ms);
	});
var $elm$parser$Parser$Advanced$map2 = F3(
	function (func, _v0, _v1) {
		var parseA = _v0.a;
		var parseB = _v1.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v2 = parseA(s0);
				if (_v2.$ === 'Bad') {
					var p = _v2.a;
					var x = _v2.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v2.a;
					var a = _v2.b;
					var s1 = _v2.c;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3(
							$elm$parser$Parser$Advanced$Good,
							p1 || p2,
							A2(func, a, b),
							s2);
					}
				}
			});
	});
var $elm$parser$Parser$Advanced$ignorer = F2(
	function (keepParser, ignoreParser) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$always, keepParser, ignoreParser);
	});
var $elm$parser$Parser$ignorer = $elm$parser$Parser$Advanced$ignorer;
var $elm$parser$Parser$Advanced$keeper = F2(
	function (parseFunc, parseArg) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$apL, parseFunc, parseArg);
	});
var $elm$parser$Parser$keeper = $elm$parser$Parser$Advanced$keeper;
var $elm$parser$Parser$Advanced$Append = F2(
	function (a, b) {
		return {$: 'Append', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$oneOfHelp = F3(
	function (s0, bag, parsers) {
		oneOfHelp:
		while (true) {
			if (!parsers.b) {
				return A2($elm$parser$Parser$Advanced$Bad, false, bag);
			} else {
				var parse = parsers.a.a;
				var remainingParsers = parsers.b;
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var step = _v1;
					return step;
				} else {
					var step = _v1;
					var p = step.a;
					var x = step.b;
					if (p) {
						return step;
					} else {
						var $temp$s0 = s0,
							$temp$bag = A2($elm$parser$Parser$Advanced$Append, bag, x),
							$temp$parsers = remainingParsers;
						s0 = $temp$s0;
						bag = $temp$bag;
						parsers = $temp$parsers;
						continue oneOfHelp;
					}
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$oneOf = function (parsers) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$oneOfHelp, s, $elm$parser$Parser$Advanced$Empty, parsers);
		});
};
var $elm$parser$Parser$oneOf = $elm$parser$Parser$Advanced$oneOf;
var $elm$parser$Parser$Done = function (a) {
	return {$: 'Done', a: a};
};
var $elm$parser$Parser$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $elm$core$String$append = _String_append;
var $elm$parser$Parser$UnexpectedChar = {$: 'UnexpectedChar'};
var $elm$parser$Parser$Advanced$chompIf = F2(
	function (isGood, expecting) {
		return $elm$parser$Parser$Advanced$Parser(
			function (s) {
				var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, s.offset, s.src);
				return _Utils_eq(newOffset, -1) ? A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : (_Utils_eq(newOffset, -2) ? A3(
					$elm$parser$Parser$Advanced$Good,
					true,
					_Utils_Tuple0,
					{col: 1, context: s.context, indent: s.indent, offset: s.offset + 1, row: s.row + 1, src: s.src}) : A3(
					$elm$parser$Parser$Advanced$Good,
					true,
					_Utils_Tuple0,
					{col: s.col + 1, context: s.context, indent: s.indent, offset: newOffset, row: s.row, src: s.src}));
			});
	});
var $elm$parser$Parser$chompIf = function (isGood) {
	return A2($elm$parser$Parser$Advanced$chompIf, isGood, $elm$parser$Parser$UnexpectedChar);
};
var $elm$parser$Parser$Advanced$loopHelp = F4(
	function (p, state, callback, s0) {
		loopHelp:
		while (true) {
			var _v0 = callback(state);
			var parse = _v0.a;
			var _v1 = parse(s0);
			if (_v1.$ === 'Good') {
				var p1 = _v1.a;
				var step = _v1.b;
				var s1 = _v1.c;
				if (step.$ === 'Loop') {
					var newState = step.a;
					var $temp$p = p || p1,
						$temp$state = newState,
						$temp$callback = callback,
						$temp$s0 = s1;
					p = $temp$p;
					state = $temp$state;
					callback = $temp$callback;
					s0 = $temp$s0;
					continue loopHelp;
				} else {
					var result = step.a;
					return A3($elm$parser$Parser$Advanced$Good, p || p1, result, s1);
				}
			} else {
				var p1 = _v1.a;
				var x = _v1.b;
				return A2($elm$parser$Parser$Advanced$Bad, p || p1, x);
			}
		}
	});
var $elm$parser$Parser$Advanced$loop = F2(
	function (state, callback) {
		return $elm$parser$Parser$Advanced$Parser(
			function (s) {
				return A4($elm$parser$Parser$Advanced$loopHelp, false, state, callback, s);
			});
	});
var $elm$parser$Parser$Advanced$map = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						func(a),
						s1);
				} else {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				}
			});
	});
var $elm$parser$Parser$map = $elm$parser$Parser$Advanced$map;
var $elm$parser$Parser$Advanced$Done = function (a) {
	return {$: 'Done', a: a};
};
var $elm$parser$Parser$Advanced$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $elm$parser$Parser$toAdvancedStep = function (step) {
	if (step.$ === 'Loop') {
		var s = step.a;
		return $elm$parser$Parser$Advanced$Loop(s);
	} else {
		var a = step.a;
		return $elm$parser$Parser$Advanced$Done(a);
	}
};
var $elm$parser$Parser$loop = F2(
	function (state, callback) {
		return A2(
			$elm$parser$Parser$Advanced$loop,
			state,
			function (s) {
				return A2(
					$elm$parser$Parser$map,
					$elm$parser$Parser$toAdvancedStep,
					callback(s));
			});
	});
var $rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt = function (quantity) {
	var helper = function (str) {
		if (_Utils_eq(
			$elm$core$String$length(str),
			quantity)) {
			var _v0 = $elm$core$String$toInt(str);
			if (_v0.$ === 'Just') {
				var intVal = _v0.a;
				return A2(
					$elm$parser$Parser$map,
					$elm$parser$Parser$Done,
					$elm$parser$Parser$succeed(intVal));
			} else {
				return $elm$parser$Parser$problem('Invalid integer: \"' + (str + '\"'));
			}
		} else {
			return A2(
				$elm$parser$Parser$map,
				function (nextChar) {
					return $elm$parser$Parser$Loop(
						A2($elm$core$String$append, str, nextChar));
				},
				$elm$parser$Parser$getChompedString(
					$elm$parser$Parser$chompIf($elm$core$Char$isDigit)));
		}
	};
	return A2($elm$parser$Parser$loop, '', helper);
};
var $elm$parser$Parser$ExpectingSymbol = function (a) {
	return {$: 'ExpectingSymbol', a: a};
};
var $elm$parser$Parser$Advanced$Token = F2(
	function (a, b) {
		return {$: 'Token', a: a, b: b};
	});
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$parser$Parser$Advanced$isSubString = _Parser_isSubString;
var $elm$core$Basics$not = _Basics_not;
var $elm$parser$Parser$Advanced$token = function (_v0) {
	var str = _v0.a;
	var expecting = _v0.b;
	var progress = !$elm$core$String$isEmpty(str);
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v1 = A5($elm$parser$Parser$Advanced$isSubString, str, s.offset, s.row, s.col, s.src);
			var newOffset = _v1.a;
			var newRow = _v1.b;
			var newCol = _v1.c;
			return _Utils_eq(newOffset, -1) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : A3(
				$elm$parser$Parser$Advanced$Good,
				progress,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: newOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$Advanced$symbol = $elm$parser$Parser$Advanced$token;
var $elm$parser$Parser$symbol = function (str) {
	return $elm$parser$Parser$Advanced$symbol(
		A2(
			$elm$parser$Parser$Advanced$Token,
			str,
			$elm$parser$Parser$ExpectingSymbol(str)));
};
var $rtfeldman$elm_iso8601_date_strings$Iso8601$epochYear = 1970;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay = function (day) {
	return $elm$parser$Parser$problem(
		'Invalid day: ' + $elm$core$String$fromInt(day));
};
var $elm$core$Basics$modBy = _Basics_modBy;
var $elm$core$Basics$neq = _Utils_notEqual;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$isLeapYear = function (year) {
	return (!A2($elm$core$Basics$modBy, 4, year)) && ((!(!A2($elm$core$Basics$modBy, 100, year))) || (!A2($elm$core$Basics$modBy, 400, year)));
};
var $rtfeldman$elm_iso8601_date_strings$Iso8601$leapYearsBefore = function (y1) {
	var y = y1 - 1;
	return (((y / 4) | 0) - ((y / 100) | 0)) + ((y / 400) | 0);
};
var $rtfeldman$elm_iso8601_date_strings$Iso8601$msPerDay = 86400000;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$msPerYear = 31536000000;
var $rtfeldman$elm_iso8601_date_strings$Iso8601$yearMonthDay = function (_v0) {
	var year = _v0.a;
	var month = _v0.b;
	var dayInMonth = _v0.c;
	if (dayInMonth < 0) {
		return $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth);
	} else {
		var succeedWith = function (extraMs) {
			var yearMs = $rtfeldman$elm_iso8601_date_strings$Iso8601$msPerYear * (year - $rtfeldman$elm_iso8601_date_strings$Iso8601$epochYear);
			var days = ((month < 3) || (!$rtfeldman$elm_iso8601_date_strings$Iso8601$isLeapYear(year))) ? (dayInMonth - 1) : dayInMonth;
			var dayMs = $rtfeldman$elm_iso8601_date_strings$Iso8601$msPerDay * (days + ($rtfeldman$elm_iso8601_date_strings$Iso8601$leapYearsBefore(year) - $rtfeldman$elm_iso8601_date_strings$Iso8601$leapYearsBefore($rtfeldman$elm_iso8601_date_strings$Iso8601$epochYear)));
			return $elm$parser$Parser$succeed((extraMs + yearMs) + dayMs);
		};
		switch (month) {
			case 1:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(0);
			case 2:
				return ((dayInMonth > 29) || ((dayInMonth === 29) && (!$rtfeldman$elm_iso8601_date_strings$Iso8601$isLeapYear(year)))) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(2678400000);
			case 3:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(5097600000);
			case 4:
				return (dayInMonth > 30) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(7776000000);
			case 5:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(10368000000);
			case 6:
				return (dayInMonth > 30) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(13046400000);
			case 7:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(15638400000);
			case 8:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(18316800000);
			case 9:
				return (dayInMonth > 30) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(20995200000);
			case 10:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(23587200000);
			case 11:
				return (dayInMonth > 30) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(26265600000);
			case 12:
				return (dayInMonth > 31) ? $rtfeldman$elm_iso8601_date_strings$Iso8601$invalidDay(dayInMonth) : succeedWith(28857600000);
			default:
				return $elm$parser$Parser$problem(
					'Invalid month: \"' + ($elm$core$String$fromInt(month) + '\"'));
		}
	}
};
var $rtfeldman$elm_iso8601_date_strings$Iso8601$monthYearDayInMs = A2(
	$elm$parser$Parser$andThen,
	$rtfeldman$elm_iso8601_date_strings$Iso8601$yearMonthDay,
	A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				$elm$parser$Parser$succeed(
					F3(
						function (year, month, day) {
							return _Utils_Tuple3(year, month, day);
						})),
				$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(4)),
			$elm$parser$Parser$oneOf(
				_List_fromArray(
					[
						A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$succeed($elm$core$Basics$identity),
							$elm$parser$Parser$symbol('-')),
						$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
						$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)
					]))),
		$elm$parser$Parser$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$succeed($elm$core$Basics$identity),
						$elm$parser$Parser$symbol('-')),
					$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
					$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)
				]))));
var $rtfeldman$elm_iso8601_date_strings$Iso8601$utcOffsetInMinutes = function () {
	var utcOffsetMinutesFromParts = F3(
		function (multiplier, hours, minutes) {
			return (multiplier * (hours * 60)) + minutes;
		});
	return A2(
		$elm$parser$Parser$keeper,
		$elm$parser$Parser$succeed($elm$core$Basics$identity),
		$elm$parser$Parser$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$map,
					function (_v0) {
						return 0;
					},
					$elm$parser$Parser$symbol('Z')),
					A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$keeper,
							$elm$parser$Parser$succeed(utcOffsetMinutesFromParts),
							$elm$parser$Parser$oneOf(
								_List_fromArray(
									[
										A2(
										$elm$parser$Parser$map,
										function (_v1) {
											return 1;
										},
										$elm$parser$Parser$symbol('+')),
										A2(
										$elm$parser$Parser$map,
										function (_v2) {
											return -1;
										},
										$elm$parser$Parser$symbol('-'))
									]))),
						$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
					$elm$parser$Parser$oneOf(
						_List_fromArray(
							[
								A2(
								$elm$parser$Parser$keeper,
								A2(
									$elm$parser$Parser$ignorer,
									$elm$parser$Parser$succeed($elm$core$Basics$identity),
									$elm$parser$Parser$symbol(':')),
								$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
								$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2),
								$elm$parser$Parser$succeed(0)
							]))),
					A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed(0),
					$elm$parser$Parser$end)
				])));
}();
var $rtfeldman$elm_iso8601_date_strings$Iso8601$iso8601 = A2(
	$elm$parser$Parser$andThen,
	function (datePart) {
		return $elm$parser$Parser$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$keeper,
							A2(
								$elm$parser$Parser$keeper,
								A2(
									$elm$parser$Parser$keeper,
									A2(
										$elm$parser$Parser$ignorer,
										$elm$parser$Parser$succeed(
											$rtfeldman$elm_iso8601_date_strings$Iso8601$fromParts(datePart)),
										$elm$parser$Parser$symbol('T')),
									$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
								$elm$parser$Parser$oneOf(
									_List_fromArray(
										[
											A2(
											$elm$parser$Parser$keeper,
											A2(
												$elm$parser$Parser$ignorer,
												$elm$parser$Parser$succeed($elm$core$Basics$identity),
												$elm$parser$Parser$symbol(':')),
											$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
											$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)
										]))),
							$elm$parser$Parser$oneOf(
								_List_fromArray(
									[
										A2(
										$elm$parser$Parser$keeper,
										A2(
											$elm$parser$Parser$ignorer,
											$elm$parser$Parser$succeed($elm$core$Basics$identity),
											$elm$parser$Parser$symbol(':')),
										$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)),
										$rtfeldman$elm_iso8601_date_strings$Iso8601$paddedInt(2)
									]))),
						$elm$parser$Parser$oneOf(
							_List_fromArray(
								[
									A2(
									$elm$parser$Parser$keeper,
									A2(
										$elm$parser$Parser$ignorer,
										$elm$parser$Parser$succeed($elm$core$Basics$identity),
										$elm$parser$Parser$symbol('.')),
									$rtfeldman$elm_iso8601_date_strings$Iso8601$fractionsOfASecondInMs),
									$elm$parser$Parser$succeed(0)
								]))),
					A2($elm$parser$Parser$ignorer, $rtfeldman$elm_iso8601_date_strings$Iso8601$utcOffsetInMinutes, $elm$parser$Parser$end)),
					A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed(
						A6($rtfeldman$elm_iso8601_date_strings$Iso8601$fromParts, datePart, 0, 0, 0, 0, 0)),
					$elm$parser$Parser$end)
				]));
	},
	$rtfeldman$elm_iso8601_date_strings$Iso8601$monthYearDayInMs);
var $elm$parser$Parser$DeadEnd = F3(
	function (row, col, problem) {
		return {col: col, problem: problem, row: row};
	});
var $elm$parser$Parser$problemToDeadEnd = function (p) {
	return A3($elm$parser$Parser$DeadEnd, p.row, p.col, p.problem);
};
var $elm$parser$Parser$Advanced$bagToList = F2(
	function (bag, list) {
		bagToList:
		while (true) {
			switch (bag.$) {
				case 'Empty':
					return list;
				case 'AddRight':
					var bag1 = bag.a;
					var x = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$core$List$cons, x, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
				default:
					var bag1 = bag.a;
					var bag2 = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$parser$Parser$Advanced$bagToList, bag2, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
			}
		}
	});
var $elm$parser$Parser$Advanced$run = F2(
	function (_v0, src) {
		var parse = _v0.a;
		var _v1 = parse(
			{col: 1, context: _List_Nil, indent: 1, offset: 0, row: 1, src: src});
		if (_v1.$ === 'Good') {
			var value = _v1.b;
			return $elm$core$Result$Ok(value);
		} else {
			var bag = _v1.b;
			return $elm$core$Result$Err(
				A2($elm$parser$Parser$Advanced$bagToList, bag, _List_Nil));
		}
	});
var $elm$parser$Parser$run = F2(
	function (parser, source) {
		var _v0 = A2($elm$parser$Parser$Advanced$run, parser, source);
		if (_v0.$ === 'Ok') {
			var a = _v0.a;
			return $elm$core$Result$Ok(a);
		} else {
			var problems = _v0.a;
			return $elm$core$Result$Err(
				A2($elm$core$List$map, $elm$parser$Parser$problemToDeadEnd, problems));
		}
	});
var $rtfeldman$elm_iso8601_date_strings$Iso8601$toTime = function (str) {
	return A2($elm$parser$Parser$run, $rtfeldman$elm_iso8601_date_strings$Iso8601$iso8601, str);
};
var $rtfeldman$elm_iso8601_date_strings$Iso8601$decoder = A2(
	$elm$json$Json$Decode$andThen,
	function (str) {
		var _v0 = $rtfeldman$elm_iso8601_date_strings$Iso8601$toTime(str);
		if (_v0.$ === 'Err') {
			var deadEnds = _v0.a;
			return $elm$json$Json$Decode$fail(
				$elm$parser$Parser$deadEndsToString(deadEnds));
		} else {
			var time = _v0.a;
			return $elm$json$Json$Decode$succeed(time);
		}
	},
	$elm$json$Json$Decode$string);
var $author$project$Firestore$commitDecoder = A3(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
	'commitTime',
	$rtfeldman$elm_iso8601_date_strings$Iso8601$decoder,
	$elm$json$Json$Decode$succeed($elm$core$Basics$identity));
var $author$project$Firestore$Encode$encode = function (_v0) {
	var fields = _v0.a;
	return $elm$json$Json$Encode$object(
		A2(
			$elm$core$List$map,
			function (_v1) {
				var key = _v1.a;
				var field = _v1.b.a;
				return _Utils_Tuple2(key, field);
			},
			fields));
};
var $author$project$Firestore$commitDocumentEncoder = F2(
	function (name, encoder) {
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'name',
					$elm$json$Json$Encode$string(name)),
					_Utils_Tuple2(
					'fields',
					$author$project$Firestore$Encode$encode(encoder))
				]));
	});
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $author$project$Firestore$commitEncoder = F2(
	function (config, _v0) {
		var tId = _v0.a.a;
		var updates = _v0.b;
		var deletes = _v0.c;
		var withBasePath = function (name) {
			return A2(
				$elm$url$Url$Builder$relative,
				_List_fromArray(
					[
						$author$project$Firestore$Config$basePath(config),
						name
					]),
				_List_Nil);
		};
		var updates_ = A2(
			$elm$core$List$map,
			function (_v1) {
				var name = _v1.a;
				var document = _v1.b;
				return _Utils_Tuple2(
					'update',
					A2(
						$author$project$Firestore$commitDocumentEncoder,
						withBasePath(name),
						document));
			},
			$elm$core$Dict$toList(updates));
		var deletes_ = A2(
			$elm$core$List$map,
			function (name) {
				return _Utils_Tuple2(
					'delete',
					$elm$json$Json$Encode$string(
						withBasePath(name)));
			},
			$elm$core$Set$toList(deletes));
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'transaction',
					$elm$json$Json$Encode$string(tId)),
					_Utils_Tuple2(
					'writes',
					A2(
						$elm$json$Json$Encode$list,
						A2($elm$core$Basics$composeL, $elm$json$Json$Encode$object, $elm$core$List$singleton),
						_Utils_ap(deletes_, updates_)))
				]));
	});
var $author$project$Firestore$commit = F2(
	function (transaction, _v0) {
		var config = _v0.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					A2($author$project$Firestore$commitEncoder, config, transaction)),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'POST',
				resolver: $author$project$Firestore$jsonResolver($author$project$Firestore$commitDecoder),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_Nil,
					$author$project$Firestore$Config$Op('commit'),
					config)
			});
	});
var $author$project$Firestore$Query$CompositeFilter = F3(
	function (a, b, c) {
		return {$: 'CompositeFilter', a: a, b: b, c: c};
	});
var $author$project$Firestore$Query$compositeFilter = $author$project$Firestore$Query$CompositeFilter;
var $author$project$Firestore$Name = function (a) {
	return {$: 'Name', a: a};
};
var $author$project$Firestore$Config$Path = function (a) {
	return {$: 'Path', a: a};
};
var $author$project$Firestore$Internals$Document = F4(
	function (name, fields, createTime, updateTime) {
		return {createTime: createTime, fields: fields, name: name, updateTime: updateTime};
	});
var $author$project$Firestore$Decode$decode = function (_v0) {
	var decoder = _v0.a;
	return decoder;
};
var $author$project$Firestore$Internals$Name = F2(
	function (a, b) {
		return {$: 'Name', a: a, b: b};
	});
var $elm_community$list_extra$List$Extra$last = function (items) {
	last:
	while (true) {
		if (!items.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			if (!items.b.b) {
				var x = items.a;
				return $elm$core$Maybe$Just(x);
			} else {
				var rest = items.b;
				var $temp$items = rest;
				items = $temp$items;
				continue last;
			}
		}
	}
};
var $author$project$Firestore$Internals$nameDecoder = A2(
	$elm$json$Json$Decode$andThen,
	function (value) {
		return A2(
			$elm$core$Maybe$withDefault,
			$elm$json$Json$Decode$fail('Failed decoding name'),
			A2(
				$elm$core$Maybe$map,
				function (id_) {
					return $elm$json$Json$Decode$succeed(
						A2($author$project$Firestore$Internals$Name, id_, value));
				},
				$elm_community$list_extra$List$Extra$last(
					A2($elm$core$String$split, '/', value))));
	},
	$elm$json$Json$Decode$string);
var $author$project$Firestore$Internals$decodeOne = F2(
	function (namer, fieldDecoder) {
		return A3(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
			'updateTime',
			$rtfeldman$elm_iso8601_date_strings$Iso8601$decoder,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
				'createTime',
				$rtfeldman$elm_iso8601_date_strings$Iso8601$decoder,
				A3(
					$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
					'fields',
					$author$project$Firestore$Decode$decode(fieldDecoder),
					A3(
						$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
						'name',
						A2($elm$json$Json$Decode$map, namer, $author$project$Firestore$Internals$nameDecoder),
						$elm$json$Json$Decode$succeed($author$project$Firestore$Internals$Document)))));
	});
var $author$project$Firestore$documentEncoder = function (encoder) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'fields',
				$author$project$Firestore$Encode$encode(encoder))
			]));
};
var $author$project$Firestore$create = F3(
	function (fieldDecoder, params, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					$author$project$Firestore$documentEncoder(params.document)),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'POST',
				resolver: $author$project$Firestore$jsonResolver(
					A2($author$project$Firestore$Internals$decodeOne, $author$project$Firestore$Name, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_fromArray(
						[
							A2($elm$url$Url$Builder$string, 'documentId', params.id)
						]),
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Firestore$Options$List$Options = function (a) {
	return {$: 'Options', a: a};
};
var $author$project$Firestore$Options$List$default = $author$project$Firestore$Options$List$Options(
	{orderBy: _List_Nil, pageSize: $elm$core$Maybe$Nothing, pageToken: $elm$core$Maybe$Nothing});
var $elm$http$Http$emptyBody = _Http_emptyBody;
var $author$project$Firestore$emptyResolver = $elm$http$Http$stringResolver(
	function (response) {
		switch (response.$) {
			case 'BadUrl_':
				var url = response.a;
				return $elm$core$Result$Err(
					$author$project$Firestore$Http_(
						$elm$http$Http$BadUrl(url)));
			case 'Timeout_':
				return $elm$core$Result$Err(
					$author$project$Firestore$Http_($elm$http$Http$Timeout));
			case 'NetworkError_':
				return $elm$core$Result$Err(
					$author$project$Firestore$Http_($elm$http$Http$NetworkError));
			case 'BadStatus_':
				var metadata = response.a;
				return $elm$core$Result$Err(
					$author$project$Firestore$Http_(
						$elm$http$Http$BadStatus(metadata.statusCode)));
			default:
				return $elm$core$Result$Ok(_Utils_Tuple0);
		}
	});
var $author$project$Firestore$delete = function (_v0) {
	var path_ = _v0.a;
	var config = _v0.b.a;
	return $elm$http$Http$task(
		{
			body: $elm$http$Http$emptyBody,
			headers: $author$project$Firestore$Config$httpHeader(config),
			method: 'DELETE',
			resolver: $author$project$Firestore$emptyResolver,
			timeout: $elm$core$Maybe$Nothing,
			url: A3(
				$author$project$Firestore$Config$endpoint,
				_List_Nil,
				$author$project$Firestore$Config$Path(path_),
				config)
		});
};
var $author$project$Firestore$deleteExisting = function (_v0) {
	var path_ = _v0.a;
	var config = _v0.b.a;
	return $elm$http$Http$task(
		{
			body: $elm$http$Http$emptyBody,
			headers: $author$project$Firestore$Config$httpHeader(config),
			method: 'DELETE',
			resolver: $author$project$Firestore$emptyResolver,
			timeout: $elm$core$Maybe$Nothing,
			url: A3(
				$author$project$Firestore$Config$endpoint,
				_List_fromArray(
					[
						A2($elm$url$Url$Builder$string, 'currentDocument.exists', 'true')
					]),
				$author$project$Firestore$Config$Path(path_),
				config)
		});
};
var $author$project$Firestore$deleteTx = F2(
	function (path_, _v0) {
		var tId = _v0.a;
		var encoders = _v0.b;
		var deletes = _v0.c;
		return A3(
			$author$project$Firestore$Transaction,
			tId,
			encoders,
			A2($elm$core$Set$insert, path_, deletes));
	});
var $author$project$Firestore$Options$Patch$empty = $author$project$Firestore$Options$Patch$Options(
	{deletes: $elm$core$Set$empty, updateFields: $elm$core$Dict$empty, updates: $elm$core$Set$empty});
var $author$project$Firestore$Query$FieldFilter = F3(
	function (a, b, c) {
		return {$: 'FieldFilter', a: a, b: b, c: c};
	});
var $IzumiSy$elm_typed$Typed$writeOnly = $IzumiSy$elm_typed$Typed$Typed;
var $author$project$Firestore$Query$fieldFilter = function (fieldPath) {
	return $author$project$Firestore$Query$FieldFilter(
		$IzumiSy$elm_typed$Typed$writeOnly(fieldPath));
};
var $author$project$Firestore$Query$Query = function (a) {
	return {$: 'Query', a: a};
};
var $author$project$Firestore$Query$from = F2(
	function (collection, _v0) {
		var query = _v0.a;
		return $author$project$Firestore$Query$Query(
			_Utils_update(
				query,
				{
					from: A2($elm$core$Set$insert, collection, query.from)
				}));
	});
var $author$project$Firestore$getInternal = F3(
	function (params, fieldDecoder, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$emptyBody,
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'GET',
				resolver: $author$project$Firestore$jsonResolver(
					A2($author$project$Firestore$Internals$decodeOne, $author$project$Firestore$Name, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					params,
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Firestore$get = $author$project$Firestore$getInternal(_List_Nil);
var $author$project$Firestore$getTx = function (_v0) {
	var tId = _v0.a.a;
	return $author$project$Firestore$getInternal(
		_List_fromArray(
			[
				A2($elm$url$Url$Builder$string, 'transaction', tId)
			]));
};
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Firestore$id = function (_v0) {
	var _v1 = _v0.a;
	var value = _v1.a;
	return value;
};
var $author$project$Firestore$insert = F3(
	function (fieldDecoder, encoder, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					$author$project$Firestore$documentEncoder(encoder)),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'POST',
				resolver: $author$project$Firestore$jsonResolver(
					A2($author$project$Firestore$Internals$decodeOne, $author$project$Firestore$Name, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_Nil,
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Firestore$Query$Value = function (a) {
	return {$: 'Value', a: a};
};
var $author$project$Firestore$Query$int = A2($elm$core$Basics$composeL, $author$project$Firestore$Query$Value, $author$project$Firestore$Internals$Encode$int);
var $elm$json$Json$Encode$int = _Json_wrap;
var $author$project$Firestore$Query$limit = F2(
	function (value, _v0) {
		var query = _v0.a;
		return $author$project$Firestore$Query$Query(
			_Utils_update(
				query,
				{
					limit: $elm$core$Maybe$Just(value)
				}));
	});
var $author$project$Firestore$Internals$PageToken = function (a) {
	return {$: 'PageToken', a: a};
};
var $author$project$Firestore$Options$List$PageToken = function (a) {
	return {$: 'PageToken', a: a};
};
var $author$project$Firestore$Internals$Documents = F2(
	function (documents, nextPageToken) {
		return {documents: documents, nextPageToken: nextPageToken};
	});
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optionalDecoder = F3(
	function (pathDecoder, valDecoder, fallback) {
		var nullOr = function (decoder) {
			return $elm$json$Json$Decode$oneOf(
				_List_fromArray(
					[
						decoder,
						$elm$json$Json$Decode$null(fallback)
					]));
		};
		var handleResult = function (input) {
			var _v0 = A2($elm$json$Json$Decode$decodeValue, pathDecoder, input);
			if (_v0.$ === 'Ok') {
				var rawValue = _v0.a;
				var _v1 = A2(
					$elm$json$Json$Decode$decodeValue,
					nullOr(valDecoder),
					rawValue);
				if (_v1.$ === 'Ok') {
					var finalResult = _v1.a;
					return $elm$json$Json$Decode$succeed(finalResult);
				} else {
					var finalErr = _v1.a;
					return $elm$json$Json$Decode$fail(
						$elm$json$Json$Decode$errorToString(finalErr));
				}
			} else {
				return $elm$json$Json$Decode$succeed(fallback);
			}
		};
		return A2($elm$json$Json$Decode$andThen, handleResult, $elm$json$Json$Decode$value);
	});
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional = F4(
	function (key, valDecoder, fallback, decoder) {
		return A2(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optionalDecoder,
				A2($elm$json$Json$Decode$field, key, $elm$json$Json$Decode$value),
				valDecoder,
				fallback),
			decoder);
	});
var $author$project$Firestore$Internals$decodeList = F3(
	function (namer, pageTokener, fieldDecoder) {
		return A4(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
			'nextPageToken',
			A2(
				$elm$json$Json$Decode$map,
				A2($elm$core$Basics$composeR, pageTokener, $elm$core$Maybe$Just),
				$elm$json$Json$Decode$string),
			$elm$core$Maybe$Nothing,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
				'documents',
				$elm$json$Json$Decode$list(
					A2($author$project$Firestore$Internals$decodeOne, namer, fieldDecoder)),
				$elm$json$Json$Decode$succeed($author$project$Firestore$Internals$Documents)));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$url$Url$Builder$int = F2(
	function (key, value) {
		return A2(
			$elm$url$Url$Builder$QueryParameter,
			$elm$url$Url$percentEncode(key),
			$elm$core$String$fromInt(value));
	});
var $author$project$Firestore$Options$List$queryParameters = function (_v0) {
	var options = _v0.a;
	var orderBy_ = A3(
		$elm$core$List$foldl,
		F2(
			function (c, acc) {
				var _v2 = _Utils_Tuple2(c, acc);
				if (_v2.a.$ === 'Desc') {
					if (_v2.b.$ === 'Nothing') {
						var value = _v2.a.a;
						var _v3 = _v2.b;
						return $elm$core$Maybe$Just(value + ' desc');
					} else {
						var value = _v2.a.a;
						var s = _v2.b.a;
						return $elm$core$Maybe$Just(s + (', ' + (value + ' desc')));
					}
				} else {
					if (_v2.b.$ === 'Nothing') {
						var value = _v2.a.a;
						var _v4 = _v2.b;
						return $elm$core$Maybe$Just(value + ' asc');
					} else {
						var value = _v2.a.a;
						var s = _v2.b.a;
						return $elm$core$Maybe$Just(s + (', ' + (value + ' asc')));
					}
				}
			}),
		$elm$core$Maybe$Nothing,
		options.orderBy);
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		_List_fromArray(
			[
				A2(
				$elm$core$Maybe$map,
				$elm$url$Url$Builder$int('pageSize'),
				options.pageSize),
				A2(
				$elm$core$Maybe$map,
				$elm$url$Url$Builder$string('orderBy'),
				orderBy_),
				A2(
				$elm$core$Maybe$map,
				$elm$url$Url$Builder$string('pageToken'),
				A2(
					$elm$core$Maybe$map,
					function (_v1) {
						var value = _v1.a.a;
						return value;
					},
					options.pageToken))
			]));
};
var $author$project$Firestore$listInternal = F4(
	function (params, fieldDecoder, options, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$emptyBody,
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'GET',
				resolver: $author$project$Firestore$jsonResolver(
					A3(
						$author$project$Firestore$Internals$decodeList,
						$author$project$Firestore$Name,
						A2($elm$core$Basics$composeR, $author$project$Firestore$Internals$PageToken, $author$project$Firestore$Options$List$PageToken),
						fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_Utils_ap(
						$author$project$Firestore$Options$List$queryParameters(options),
						params),
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Firestore$list = $author$project$Firestore$listInternal(_List_Nil);
var $author$project$Firestore$listTx = function (_v0) {
	var tId = _v0.a.a;
	return $author$project$Firestore$listInternal(
		_List_fromArray(
			[
				A2($elm$url$Url$Builder$string, 'transaction', tId)
			]));
};
var $elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return $elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return $elm$core$Result$Err(e);
		}
	});
var $author$project$Firestore$Query$new = $author$project$Firestore$Query$Query(
	{from: $elm$core$Set$empty, limit: $elm$core$Maybe$Nothing, offset: $elm$core$Maybe$Nothing, orderBy: $elm$core$Dict$empty, where_: $elm$core$Maybe$Nothing});
var $elm$json$Json$Encode$bool = _Json_wrap;
var $author$project$Worker$ngValue = $elm$json$Json$Encode$object(
	_List_fromArray(
		[
			_Utils_Tuple2(
			'success',
			$elm$json$Json$Encode$bool(false))
		]));
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $author$project$Firestore$Query$offset = F2(
	function (value, _v0) {
		var query = _v0.a;
		return $author$project$Firestore$Query$Query(
			_Utils_update(
				query,
				{
					offset: $elm$core$Maybe$Just(value)
				}));
	});
var $author$project$Worker$okValue = function (value) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'success',
				$elm$json$Json$Encode$bool(true)),
				_Utils_Tuple2('value', value)
			]));
};
var $author$project$Firestore$Options$List$orderBy = F2(
	function (value, _v0) {
		var options = _v0.a;
		return $author$project$Firestore$Options$List$Options(
			_Utils_update(
				options,
				{
					orderBy: A2($elm$core$List$cons, value, options.orderBy)
				}));
	});
var $author$project$Firestore$Query$orderBy = F3(
	function (fieldPath, direction, _v0) {
		var query = _v0.a;
		return $author$project$Firestore$Query$Query(
			_Utils_update(
				query,
				{
					orderBy: A3($elm$core$Dict$insert, fieldPath, direction, query.orderBy)
				}));
	});
var $author$project$Firestore$Options$List$pageSize = F2(
	function (size, _v0) {
		var options = _v0.a;
		return $author$project$Firestore$Options$List$Options(
			_Utils_update(
				options,
				{
					pageSize: $elm$core$Maybe$Just(size)
				}));
	});
var $author$project$Firestore$Options$List$pageToken = F2(
	function (token, _v0) {
		var options = _v0.a;
		return $author$project$Firestore$Options$List$Options(
			_Utils_update(
				options,
				{
					pageToken: $elm$core$Maybe$Just(token)
				}));
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $author$project$Firestore$Options$Patch$queryParameters = function (_v0) {
	var options = _v0.a;
	return _Utils_Tuple2(
		$elm$core$List$concat(
			_List_fromArray(
				[
					A2(
					$elm$core$List$map,
					$elm$url$Url$Builder$string('updateMask.fieldPaths'),
					$elm$core$Set$toList(options.updates)),
					A2(
					$elm$core$List$map,
					$elm$url$Url$Builder$string('updateMask.fieldPaths'),
					$elm$core$Set$toList(options.deletes))
				])),
		$elm$core$Dict$toList(options.updateFields));
};
var $author$project$Firestore$patch = F3(
	function (fieldDecoder, options, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		var _v1 = $author$project$Firestore$Options$Patch$queryParameters(options);
		var params = _v1.a;
		var fields = _v1.b;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					$author$project$Firestore$documentEncoder(
						$author$project$Firestore$Encode$document(fields))),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'PATCH',
				resolver: $author$project$Firestore$jsonResolver(
					A2($author$project$Firestore$Internals$decodeOne, $author$project$Firestore$Name, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					params,
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Worker$PatchedUser = function (name) {
	return {name: name};
};
var $author$project$Worker$patchedCodec = $author$project$Firestore$Codec$build(
	A4(
		$author$project$Firestore$Codec$required,
		'name',
		function ($) {
			return $.name;
		},
		$author$project$Firestore$Codec$string,
		$author$project$Firestore$Codec$document($author$project$Worker$PatchedUser)));
var $author$project$Firestore$Path = F2(
	function (a, b) {
		return {$: 'Path', a: a, b: b};
	});
var $author$project$Firestore$path = F2(
	function (value, _v0) {
		var config = _v0.a;
		return A2(
			$author$project$Firestore$Path,
			value,
			$author$project$Firestore$Firestore(config));
	});
var $author$project$Firestore$Internals$Empty = function (a) {
	return {$: 'Empty', a: a};
};
var $author$project$Firestore$Internals$Filled = function (a) {
	return {$: 'Filled', a: a};
};
var $author$project$Firestore$Internals$EmptyBody = function (readTime) {
	return {readTime: readTime};
};
var $author$project$Firestore$Internals$decodeEmptyQuery = A3(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
	'readTime',
	$rtfeldman$elm_iso8601_date_strings$Iso8601$decoder,
	$elm$json$Json$Decode$succeed($author$project$Firestore$Internals$EmptyBody));
var $author$project$Firestore$Internals$FilledBody = F4(
	function (transaction, document, readTime, skippedResults) {
		return {document: document, readTime: readTime, skippedResults: skippedResults, transaction: transaction};
	});
var $author$project$Firestore$Internals$decodeFilledQuery = F3(
	function (namer, transactioner, fieldDecoder) {
		return A4(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
			'skippedResults',
			$elm$json$Json$Decode$int,
			0,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
				'readTime',
				$rtfeldman$elm_iso8601_date_strings$Iso8601$decoder,
				A3(
					$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
					'document',
					A2($author$project$Firestore$Internals$decodeOne, namer, fieldDecoder),
					A4(
						$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
						'transaction',
						A2(
							$elm$json$Json$Decode$map,
							A2($elm$core$Basics$composeR, transactioner, $elm$core$Maybe$Just),
							$elm$json$Json$Decode$string),
						$elm$core$Maybe$Nothing,
						$elm$json$Json$Decode$succeed($author$project$Firestore$Internals$FilledBody)))));
	});
var $author$project$Firestore$Internals$decodeQueries = F3(
	function (namer, transactioner, fieldDecoder) {
		return A2(
			$elm$json$Json$Decode$map,
			$elm$core$List$filterMap(
				function (result) {
					if (result.$ === 'Filled') {
						var body = result.a;
						return $elm$core$Maybe$Just(body);
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}),
			$elm$json$Json$Decode$list(
				$elm$json$Json$Decode$oneOf(
					_List_fromArray(
						[
							A2(
							$elm$json$Json$Decode$map,
							$author$project$Firestore$Internals$Filled,
							A3($author$project$Firestore$Internals$decodeFilledQuery, namer, transactioner, fieldDecoder)),
							A2($elm$json$Json$Decode$map, $author$project$Firestore$Internals$Empty, $author$project$Firestore$Internals$decodeEmptyQuery)
						]))));
	});
var $author$project$Firestore$Query$fromValue = A2(
	$elm$core$Basics$composeR,
	$elm$core$Set$toList,
	$elm$json$Json$Encode$list(
		function (value) {
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'collectionId',
						$elm$json$Json$Encode$string(value))
					]));
		}));
var $author$project$Firestore$Query$directionValue = function (value) {
	return $elm$json$Json$Encode$string(
		function () {
			switch (value.$) {
				case 'Unspecified':
					return 'DIRECTION_UNSPECIFIED';
				case 'Ascending':
					return 'ASCENDING';
				default:
					return 'DESCENDING';
			}
		}());
};
var $author$project$Firestore$Query$orderByValue = A2(
	$elm$core$Basics$composeR,
	$elm$core$Dict$toList,
	$elm$json$Json$Encode$list(
		function (_v0) {
			var field = _v0.a;
			var direction = _v0.b;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'field',
						$elm$json$Json$Encode$object(
							_List_fromArray(
								[
									_Utils_Tuple2(
									'fieldPath',
									$elm$json$Json$Encode$string(field))
								]))),
						_Utils_Tuple2(
						'direction',
						$author$project$Firestore$Query$directionValue(direction))
					]));
		}));
var $author$project$Firestore$Query$compositeOpValue = function (op) {
	return $elm$json$Json$Encode$string('AND');
};
var $IzumiSy$elm_typed$Typed$encode = F2(
	function (encoder, _v0) {
		var value_ = _v0.a;
		return encoder(value_);
	});
var $author$project$Firestore$Query$fieldOpValue = function (op) {
	return $elm$json$Json$Encode$string(
		function () {
			switch (op.$) {
				case 'LessThan':
					return 'LESS_THAN';
				case 'LessThanOrEqual':
					return 'LESS_THAN_OR_EQUAL';
				case 'GreaterThan':
					return 'GREATER_THAN';
				case 'GreaterThanOrEqual':
					return 'GREATER_THAN_OR_EQUAL';
				case 'Equal':
					return 'EQUAL';
				default:
					return 'NOT_EQUAL';
			}
		}());
};
var $author$project$Firestore$Query$unaryOpValue = function (op) {
	return $elm$json$Json$Encode$string(
		function () {
			switch (op.$) {
				case 'IsNaN':
					return 'IS_NAN';
				case 'IsNull':
					return 'IS_NULL';
				case 'IsNotNaN':
					return 'IS_NOT_NAN';
				default:
					return 'IS_NOT_NULL';
			}
		}());
};
var $author$project$Firestore$Query$whereValue = function (where__) {
	switch (where__.$) {
		case 'CompositeFilter':
			var op = where__.a;
			var filter = where__.b;
			var filters = where__.c;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'compositeFilter',
						$elm$json$Json$Encode$object(
							_List_fromArray(
								[
									_Utils_Tuple2(
									'op',
									$author$project$Firestore$Query$compositeOpValue(op)),
									_Utils_Tuple2(
									'filters',
									A2(
										$elm$json$Json$Encode$list,
										$author$project$Firestore$Query$whereValue,
										A2($elm$core$List$cons, filter, filters)))
								])))
					]));
		case 'FieldFilter':
			var fieldPath = where__.a;
			var op = where__.b;
			var value = where__.c.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'fieldFilter',
						$elm$json$Json$Encode$object(
							_List_fromArray(
								[
									_Utils_Tuple2(
									'op',
									$author$project$Firestore$Query$fieldOpValue(op)),
									_Utils_Tuple2(
									'field',
									$elm$json$Json$Encode$object(
										_List_fromArray(
											[
												_Utils_Tuple2(
												'fieldPath',
												A2($IzumiSy$elm_typed$Typed$encode, $elm$json$Json$Encode$string, fieldPath))
											]))),
									_Utils_Tuple2('value', value)
								])))
					]));
		default:
			var fieldPath = where__.a;
			var op = where__.b;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'unaryFilter',
						$elm$json$Json$Encode$object(
							_List_fromArray(
								[
									_Utils_Tuple2(
									'op',
									$author$project$Firestore$Query$unaryOpValue(op)),
									_Utils_Tuple2(
									'field',
									$elm$json$Json$Encode$object(
										_List_fromArray(
											[
												_Utils_Tuple2(
												'fieldPath',
												A2($IzumiSy$elm_typed$Typed$encode, $elm$json$Json$Encode$string, fieldPath))
											])))
								])))
					]));
	}
};
var $author$project$Firestore$Query$encode = function (_v0) {
	var query = _v0.a;
	return $elm$json$Json$Encode$object(
		A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			_List_fromArray(
				[
					$elm$core$Maybe$Just(
					_Utils_Tuple2(
						'where',
						A2(
							$elm$core$Maybe$withDefault,
							$elm$json$Json$Encode$object(_List_Nil),
							A2($elm$core$Maybe$map, $author$project$Firestore$Query$whereValue, query.where_)))),
					$elm$core$Maybe$Just(
					_Utils_Tuple2(
						'orderBy',
						$author$project$Firestore$Query$orderByValue(query.orderBy))),
					$elm$core$Maybe$Just(
					_Utils_Tuple2(
						'from',
						$author$project$Firestore$Query$fromValue(query.from))),
					A2(
					$elm$core$Maybe$map,
					function (value) {
						return _Utils_Tuple2(
							'offset',
							$elm$json$Json$Encode$int(value));
					},
					query.offset),
					A2(
					$elm$core$Maybe$map,
					function (value) {
						return _Utils_Tuple2(
							'limit',
							$elm$json$Json$Encode$int(value));
					},
					query.limit)
				])));
};
var $author$project$Firestore$runQueryInternal = F4(
	function (maybeTransaction, fieldDecoder, query, _v0) {
		var config = _v0.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					$elm$json$Json$Encode$object(
						A2(
							$elm$core$List$filterMap,
							$elm$core$Basics$identity,
							_List_fromArray(
								[
									$elm$core$Maybe$Just(
									_Utils_Tuple2(
										'structuredQuery',
										$author$project$Firestore$Query$encode(query))),
									A2(
									$elm$core$Maybe$map,
									function (_v1) {
										var tId = _v1.a.a;
										return _Utils_Tuple2(
											'transaction',
											$elm$json$Json$Encode$string(tId));
									},
									maybeTransaction)
								])))),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'POST',
				resolver: $author$project$Firestore$jsonResolver(
					A3($author$project$Firestore$Internals$decodeQueries, $author$project$Firestore$Name, $author$project$Firestore$TransactionId, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_Nil,
					$author$project$Firestore$Config$Op('runQuery'),
					config)
			});
	});
var $author$project$Firestore$runQuery = $author$project$Firestore$runQueryInternal($elm$core$Maybe$Nothing);
var $author$project$Firestore$runQueryTx = A2($elm$core$Basics$composeL, $author$project$Firestore$runQueryInternal, $elm$core$Maybe$Just);
var $author$project$Firestore$Query$string = A2($elm$core$Basics$composeL, $author$project$Firestore$Query$Value, $author$project$Firestore$Internals$Encode$string);
var $author$project$Worker$testCreateResult = _Platform_outgoingPort('testCreateResult', $elm$core$Basics$identity);
var $author$project$Worker$testDeleteExistingFailResult = _Platform_outgoingPort('testDeleteExistingFailResult', $elm$core$Basics$identity);
var $author$project$Worker$testDeleteExistingResult = _Platform_outgoingPort('testDeleteExistingResult', $elm$core$Basics$identity);
var $author$project$Worker$testDeleteResult = _Platform_outgoingPort('testDeleteResult', $elm$core$Basics$identity);
var $author$project$Worker$testGetResult = _Platform_outgoingPort('testGetResult', $elm$core$Basics$identity);
var $author$project$Worker$testGetTxResult = _Platform_outgoingPort('testGetTxResult', $elm$core$Basics$identity);
var $author$project$Worker$testInsertResult = _Platform_outgoingPort('testInsertResult', $elm$core$Basics$identity);
var $author$project$Worker$testListAscResult = _Platform_outgoingPort('testListAscResult', $elm$core$Basics$identity);
var $author$project$Worker$testListDescResult = _Platform_outgoingPort('testListDescResult', $elm$core$Basics$identity);
var $author$project$Worker$testListPageSizeResult = _Platform_outgoingPort('testListPageSizeResult', $elm$core$Basics$identity);
var $author$project$Worker$testListPageTokenResult = _Platform_outgoingPort('testListPageTokenResult', $elm$core$Basics$identity);
var $author$project$Worker$testListTxResult = _Platform_outgoingPort('testListTxResult', $elm$core$Basics$identity);
var $author$project$Worker$testPatchResult = _Platform_outgoingPort('testPatchResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryComplexResult = _Platform_outgoingPort('testQueryComplexResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryCompositeOpResult = _Platform_outgoingPort('testQueryCompositeOpResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryEmptyResult = _Platform_outgoingPort('testQueryEmptyResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryFieldOpResult = _Platform_outgoingPort('testQueryFieldOpResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryOrderByResult = _Platform_outgoingPort('testQueryOrderByResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryTxResult = _Platform_outgoingPort('testQueryTxResult', $elm$core$Basics$identity);
var $author$project$Worker$testQueryUnaryOpResult = _Platform_outgoingPort('testQueryUnaryOpResult', $elm$core$Basics$identity);
var $author$project$Worker$testTransactionResult = _Platform_outgoingPort('testTransactionResult', $elm$core$Basics$identity);
var $author$project$Worker$testUpsertExistingResult = _Platform_outgoingPort('testUpsertExistingResult', $elm$core$Basics$identity);
var $author$project$Worker$testUpsertResult = _Platform_outgoingPort('testUpsertResult', $elm$core$Basics$identity);
var $author$project$Firestore$Query$UnaryFilter = F2(
	function (a, b) {
		return {$: 'UnaryFilter', a: a, b: b};
	});
var $author$project$Firestore$Query$unaryFilter = function (fieldPath) {
	return $author$project$Firestore$Query$UnaryFilter(
		$IzumiSy$elm_typed$Typed$writeOnly(fieldPath));
};
var $author$project$Firestore$updateTx = F3(
	function (name, encoder, _v0) {
		var tId = _v0.a;
		var encoders = _v0.b;
		var deletes = _v0.c;
		return A3(
			$author$project$Firestore$Transaction,
			tId,
			A3($elm$core$Dict$insert, name, encoder, encoders),
			deletes);
	});
var $author$project$Firestore$upsert = F3(
	function (fieldDecoder, encoder, _v0) {
		var path_ = _v0.a;
		var config = _v0.b.a;
		return $elm$http$Http$task(
			{
				body: $elm$http$Http$jsonBody(
					$author$project$Firestore$documentEncoder(encoder)),
				headers: $author$project$Firestore$Config$httpHeader(config),
				method: 'PATCH',
				resolver: $author$project$Firestore$jsonResolver(
					A2($author$project$Firestore$Internals$decodeOne, $author$project$Firestore$Name, fieldDecoder)),
				timeout: $elm$core$Maybe$Nothing,
				url: A3(
					$author$project$Firestore$Config$endpoint,
					_List_Nil,
					$author$project$Firestore$Config$Path(path_),
					config)
			});
	});
var $author$project$Firestore$Query$where_ = F2(
	function (value_, _v0) {
		var query = _v0.a;
		return $author$project$Firestore$Query$Query(
			_Utils_update(
				query,
				{
					where_: $elm$core$Maybe$Just(value_)
				}));
	});
var $elm$core$Result$withDefault = F2(
	function (def, result) {
		if (result.$ === 'Ok') {
			var a = result.a;
			return a;
		} else {
			return def;
		}
	});
var $author$project$Worker$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'RunTestGet':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestGet,
						A2(
							$author$project$Firestore$get,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2($author$project$Firestore$path, 'users/user0', model))));
			case 'RanTestGet':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testGetResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.fields;
									},
									A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.name;
										},
										A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))),
								result))));
			case 'RunTestListPageSize':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestListPageSize,
						A3(
							$author$project$Firestore$list,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2($author$project$Firestore$Options$List$pageSize, 3, $author$project$Firestore$Options$List$default),
							A2($author$project$Firestore$path, 'users', model))));
			case 'RanTestListPageSize':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testListPageSizeResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.documents;
									},
									A2(
										$elm$core$Basics$composeR,
										$elm$core$List$length,
										A2($elm$core$Basics$composeR, $elm$json$Json$Encode$int, $author$project$Worker$okValue))),
								result))));
			case 'RunTestListPageToken':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestListPageToken,
						A2(
							$elm$core$Task$andThen,
							A2(
								$elm$core$Basics$composeR,
								$elm$core$Maybe$map(
									function (pageToken) {
										return A3(
											$author$project$Firestore$list,
											$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
											A2(
												$author$project$Firestore$Options$List$orderBy,
												$author$project$Firestore$Options$List$Desc('age'),
												A2(
													$author$project$Firestore$Options$List$pageSize,
													2,
													A2($author$project$Firestore$Options$List$pageToken, pageToken, $author$project$Firestore$Options$List$default))),
											A2($author$project$Firestore$path, 'users', model));
									}),
								$elm$core$Maybe$withDefault(
									$elm$core$Task$fail(
										$author$project$Firestore$Http_(
											$elm$http$Http$BadStatus(-1))))),
							A2(
								$elm$core$Task$map,
								function ($) {
									return $.nextPageToken;
								},
								A3(
									$author$project$Firestore$list,
									$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
									A2($author$project$Firestore$Options$List$pageSize, 2, $author$project$Firestore$Options$List$default),
									A2($author$project$Firestore$path, 'users', model))))));
			case 'RanTestListPageToken':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testListPageTokenResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.documents;
									},
									A2(
										$elm$core$Basics$composeR,
										$elm$core$List$head,
										A2(
											$elm$core$Basics$composeR,
											$elm$core$Maybe$map(
												A2(
													$elm$core$Basics$composeR,
													function ($) {
														return $.fields;
													},
													function ($) {
														return $.name;
													})),
											A2(
												$elm$core$Basics$composeR,
												$elm$core$Maybe$withDefault('unknown'),
												A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))))),
								result))));
			case 'RunTestListDesc':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestListDesc,
						A3(
							$author$project$Firestore$list,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Options$List$orderBy,
								$author$project$Firestore$Options$List$Desc('age'),
								$author$project$Firestore$Options$List$default),
							A2($author$project$Firestore$path, 'users', model))));
			case 'RanTestListDesc':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testListDescResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.documents;
									},
									A2(
										$elm$core$Basics$composeR,
										$elm$core$List$head,
										A2(
											$elm$core$Basics$composeR,
											$elm$core$Maybe$map(
												A2(
													$elm$core$Basics$composeR,
													function ($) {
														return $.fields;
													},
													function ($) {
														return $.name;
													})),
											A2(
												$elm$core$Basics$composeR,
												$elm$core$Maybe$withDefault('unknown'),
												A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))))),
								result))));
			case 'RunTestListAsc':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestListAsc,
						A3(
							$author$project$Firestore$list,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Options$List$orderBy,
								$author$project$Firestore$Options$List$Asc('age'),
								$author$project$Firestore$Options$List$default),
							A2($author$project$Firestore$path, 'users', model))));
			case 'RanTestListAsc':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testListAscResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.documents;
									},
									A2(
										$elm$core$Basics$composeR,
										$elm$core$List$head,
										A2(
											$elm$core$Basics$composeR,
											$elm$core$Maybe$map(
												A2(
													$elm$core$Basics$composeR,
													function ($) {
														return $.fields;
													},
													function ($) {
														return $.name;
													})),
											A2(
												$elm$core$Basics$composeR,
												$elm$core$Maybe$withDefault('unknown'),
												A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))))),
								result))));
			case 'RunTestQueryFieldOp':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryFieldOp,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A3(
									$author$project$Firestore$Query$fieldFilter,
									'age',
									$author$project$Firestore$Query$LessThanOrEqual,
									$author$project$Firestore$Query$int(20)),
								A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new)),
							model)));
			case 'RanTestQueryFieldOp':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryFieldOpResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$length,
									A2($elm$core$Basics$composeR, $elm$json$Json$Encode$int, $author$project$Worker$okValue)),
								result))));
			case 'RunTestQueryCompositeOp':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryCompositeOp,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A3(
									$author$project$Firestore$Query$compositeFilter,
									$author$project$Firestore$Query$And,
									A3(
										$author$project$Firestore$Query$fieldFilter,
										'age',
										$author$project$Firestore$Query$GreaterThanOrEqual,
										$author$project$Firestore$Query$int(10)),
									_List_fromArray(
										[
											A3(
											$author$project$Firestore$Query$fieldFilter,
											'age',
											$author$project$Firestore$Query$LessThan,
											$author$project$Firestore$Query$int(30))
										])),
								A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new)),
							model)));
			case 'RanTestQueryCompositeOp':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryCompositeOpResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$length,
									A2($elm$core$Basics$composeR, $elm$json$Json$Encode$int, $author$project$Worker$okValue)),
								result))));
			case 'RunTestQueryUnaryOp':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryUnaryOp,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A2($author$project$Firestore$Query$unaryFilter, 'name', $author$project$Firestore$Query$IsNull),
								A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new)),
							model)));
			case 'RanTestQueryUnaryOp':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryUnaryOpResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$length,
									A2($elm$core$Basics$composeR, $elm$json$Json$Encode$int, $author$project$Worker$okValue)),
								result))));
			case 'RunTestQueryOrderBy':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryOrderBy,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A3(
									$author$project$Firestore$Query$fieldFilter,
									'age',
									$author$project$Firestore$Query$GreaterThanOrEqual,
									$author$project$Firestore$Query$int(20)),
								A3(
									$author$project$Firestore$Query$orderBy,
									'age',
									$author$project$Firestore$Query$Descending,
									A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new))),
							model)));
			case 'RanTestQueryOrderBy':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryOrderByResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$head,
									A2(
										$elm$core$Basics$composeR,
										$elm$core$Maybe$map(
											A2(
												$elm$core$Basics$composeR,
												function ($) {
													return $.document;
												},
												A2(
													$elm$core$Basics$composeR,
													function ($) {
														return $.fields;
													},
													function ($) {
														return $.name;
													}))),
										A2(
											$elm$core$Basics$composeR,
											$elm$core$Maybe$withDefault('unknown'),
											A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue)))),
								result))));
			case 'RunTestQueryEmpty':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryEmpty,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A3(
									$author$project$Firestore$Query$fieldFilter,
									'name',
									$author$project$Firestore$Query$Equal,
									$author$project$Firestore$Query$string('name_not_found_on_seed')),
								A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new)),
							model)));
			case 'RanTestQueryEmpty':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryEmptyResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$length,
									A2($elm$core$Basics$composeR, $elm$json$Json$Encode$int, $author$project$Worker$okValue)),
								result))));
			case 'RunTestQueryComplex':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryComplex,
						A3(
							$author$project$Firestore$runQuery,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
							A2(
								$author$project$Firestore$Query$where_,
								A3(
									$author$project$Firestore$Query$compositeFilter,
									$author$project$Firestore$Query$And,
									A3(
										$author$project$Firestore$Query$fieldFilter,
										'age',
										$author$project$Firestore$Query$GreaterThanOrEqual,
										$author$project$Firestore$Query$int(10)),
									_List_fromArray(
										[
											A3(
											$author$project$Firestore$Query$fieldFilter,
											'age',
											$author$project$Firestore$Query$LessThanOrEqual,
											$author$project$Firestore$Query$int(40))
										])),
								A3(
									$author$project$Firestore$Query$orderBy,
									'age',
									$author$project$Firestore$Query$Descending,
									A2(
										$author$project$Firestore$Query$offset,
										2,
										A2(
											$author$project$Firestore$Query$limit,
											2,
											A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new))))),
							model)));
			case 'RanTestQueryComplex':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryComplexResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$head,
									A2(
										$elm$core$Basics$composeR,
										$elm$core$Maybe$map(
											A2(
												$elm$core$Basics$composeR,
												function ($) {
													return $.document;
												},
												A2(
													$elm$core$Basics$composeR,
													function ($) {
														return $.fields;
													},
													function ($) {
														return $.name;
													}))),
										A2(
											$elm$core$Basics$composeR,
											$elm$core$Maybe$withDefault('unknown'),
											A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue)))),
								result))));
			case 'RunTestInsert':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestInsert,
						A2(
							$elm$core$Task$map,
							function ($) {
								return $.name;
							},
							A3(
								$author$project$Firestore$insert,
								$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
								A2(
									$author$project$Firestore$Codec$asEncoder,
									$author$project$Worker$codec,
									{age: 26, name: 'thomas'}),
								A2($author$project$Firestore$path, 'users', model)))));
			case 'RanTestInsert':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testInsertResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v1) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
			case 'RunTestCreate':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestCreate,
						A2(
							$elm$core$Task$map,
							function ($) {
								return $.name;
							},
							A3(
								$author$project$Firestore$create,
								$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
								{
									document: A2(
										$author$project$Firestore$Codec$asEncoder,
										$author$project$Worker$codec,
										{age: 27, name: 'jessy'}),
									id: 'jessy'
								},
								A2($author$project$Firestore$path, 'users', model)))));
			case 'RanTestCreate':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testCreateResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeL,
									A2($elm$core$Basics$composeL, $author$project$Worker$okValue, $elm$json$Json$Encode$string),
									$author$project$Firestore$id),
								result))));
			case 'RunTestUpsert':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestUpsert,
						A2(
							$elm$core$Task$map,
							function ($) {
								return $.name;
							},
							A3(
								$author$project$Firestore$upsert,
								$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
								A2(
									$author$project$Firestore$Codec$asEncoder,
									$author$project$Worker$codec,
									{age: 21, name: 'jonathan'}),
								A2($author$project$Firestore$path, 'users/user10', model)))));
			case 'RanTestUpsert':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testUpsertResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeL,
									A2($elm$core$Basics$composeL, $author$project$Worker$okValue, $elm$json$Json$Encode$string),
									$author$project$Firestore$id),
								result))));
			case 'RunTestUpsertExisting':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestUpsertExisting,
						A2(
							$elm$core$Task$andThen,
							function (_v2) {
								return A2(
									$author$project$Firestore$get,
									$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
									A2($author$project$Firestore$path, 'users/user0', model));
							},
							A3(
								$author$project$Firestore$upsert,
								$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
								A2(
									$author$project$Firestore$Codec$asEncoder,
									$author$project$Worker$codec,
									{age: 0, name: 'user0updated'}),
								A2($author$project$Firestore$path, 'users/user0', model)))));
			case 'RanTestUpsertExisting':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testUpsertExistingResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.fields;
									},
									A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.name;
										},
										A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))),
								result))));
			case 'RunTestPatch':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestPatch,
						A3(
							$author$project$Firestore$patch,
							$author$project$Firestore$Codec$asDecoder($author$project$Worker$patchedCodec),
							A3(
								$author$project$Firestore$Options$Patch$addUpdate,
								'name',
								$author$project$Firestore$Encode$string('user0patched'),
								A2($author$project$Firestore$Options$Patch$addDelete, 'age', $author$project$Firestore$Options$Patch$empty)),
							A2($author$project$Firestore$path, 'users/user0', model))));
			case 'RanTestPatch':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testPatchResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								A2(
									$elm$core$Basics$composeR,
									function ($) {
										return $.fields;
									},
									A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.name;
										},
										A2($elm$core$Basics$composeR, $elm$json$Json$Encode$string, $author$project$Worker$okValue))),
								result))));
			case 'RunTestDelete':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestDelete,
						A2(
							$elm$core$Task$andThen,
							function (_v3) {
								return A2(
									$author$project$Firestore$get,
									$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
									A2($author$project$Firestore$path, 'users/user0', model));
							},
							$author$project$Firestore$delete(
								A2($author$project$Firestore$path, 'users/user0', model)))));
			case 'RanTestDelete':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testDeleteResult(
						function () {
							if ((result.$ === 'Err') && (result.a.$ === 'Response')) {
								var status = result.a.a.status;
								if (status === 'NOT_FOUND') {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								} else {
									return $author$project$Worker$ngValue;
								}
							} else {
								return $author$project$Worker$ngValue;
							}
						}()));
			case 'RunTestDeleteExisting':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestDeleteExisting,
						$author$project$Firestore$deleteExisting(
							A2($author$project$Firestore$path, 'users/user0', model))));
			case 'RanTestDeleteExisting':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testDeleteExistingResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v6) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
			case 'RunTestDeleteExistingFail':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestDeleteExistingFail,
						$author$project$Firestore$deleteExisting(
							A2($author$project$Firestore$path, 'users/no_user', model))));
			case 'RanTestDeleteExistingFail':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testDeleteExistingFailResult(
						function () {
							if ((((result.$ === 'Err') && (result.a.$ === 'Http_')) && (result.a.a.$ === 'BadStatus')) && (result.a.a.a === 404)) {
								return $author$project$Worker$okValue($elm$json$Json$Encode$null);
							} else {
								return $author$project$Worker$ngValue;
							}
						}()));
			case 'RunTestTransaction':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestTransaction,
						A2(
							$elm$core$Task$andThen,
							function (transaction) {
								return A2(
									$author$project$Firestore$commit,
									A2(
										$author$project$Firestore$deleteTx,
										'users/user3',
										A2(
											$author$project$Firestore$deleteTx,
											'users/user2',
											A3(
												$author$project$Firestore$updateTx,
												'users/user1',
												A2(
													$author$project$Firestore$Codec$asEncoder,
													$author$project$Worker$codec,
													{age: 10, name: 'user1updated'}),
												A3(
													$author$project$Firestore$updateTx,
													'users/user0',
													A2(
														$author$project$Firestore$Codec$asEncoder,
														$author$project$Worker$codec,
														{age: 0, name: 'user0updated'}),
													transaction)))),
									model);
							},
							$author$project$Firestore$begin(model))));
			case 'RanTestTransaction':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testTransactionResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v8) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
			case 'RunTestGetTx':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestGetTx,
						A2(
							$elm$core$Task$andThen,
							function (_v9) {
								var transaction = _v9.a;
								var fields = _v9.b.fields;
								return A2(
									$author$project$Firestore$commit,
									A3(
										$author$project$Firestore$updateTx,
										'users/user0',
										A2(
											$author$project$Firestore$Codec$asEncoder,
											$author$project$Worker$codec,
											{age: 0, name: fields.name + 'txUpdated'}),
										transaction),
									model);
							},
							A2(
								$elm$core$Task$andThen,
								function (transaction) {
									return A2(
										$elm$core$Task$map,
										function (result) {
											return _Utils_Tuple2(transaction, result);
										},
										A3(
											$author$project$Firestore$getTx,
											transaction,
											$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
											A2($author$project$Firestore$path, 'users/user0', model)));
								},
								$author$project$Firestore$begin(model)))));
			case 'RanTestGetTx':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testGetTxResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v10) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
			case 'RunTestListTx':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestListTx,
						A2(
							$elm$core$Task$andThen,
							function (_v12) {
								var transaction = _v12.a;
								var documents = _v12.b;
								return A2(
									$author$project$Firestore$commit,
									A3(
										$elm$core$List$foldr,
										function (_v13) {
											var name = _v13.name;
											var fields = _v13.fields;
											return A2(
												$author$project$Firestore$updateTx,
												'users/' + $author$project$Firestore$id(name),
												A2(
													$author$project$Firestore$Codec$asEncoder,
													$author$project$Worker$codec,
													{age: fields.age, name: fields.name + 'txUpdated'}));
										},
										transaction,
										documents),
									model);
							},
							A2(
								$elm$core$Task$andThen,
								function (transaction) {
									return A2(
										$elm$core$Task$map,
										function (_v11) {
											var documents = _v11.documents;
											return _Utils_Tuple2(transaction, documents);
										},
										A4(
											$author$project$Firestore$listTx,
											transaction,
											$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
											$author$project$Firestore$Options$List$default,
											A2($author$project$Firestore$path, 'users', model)));
								},
								$author$project$Firestore$begin(model)))));
			case 'RanTestListTx':
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testListTxResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v14) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
			case 'RunTestQueryTx':
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Task$attempt,
						$author$project$Worker$RanTestQueryTx,
						A2(
							$elm$core$Task$andThen,
							function (_v15) {
								var transaction = _v15.a;
								var results = _v15.b;
								return A2(
									$author$project$Firestore$commit,
									A3(
										$elm$core$List$foldr,
										function (_v16) {
											var document = _v16.document;
											return A2(
												$author$project$Firestore$updateTx,
												'users/' + $author$project$Firestore$id(document.name),
												A2(
													$author$project$Firestore$Codec$asEncoder,
													$author$project$Worker$codec,
													{age: document.fields.age, name: document.fields.name + 'txUpdated'}));
										},
										transaction,
										results),
									model);
							},
							A2(
								$elm$core$Task$andThen,
								function (transaction) {
									return A2(
										$elm$core$Task$map,
										function (results) {
											return _Utils_Tuple2(transaction, results);
										},
										A4(
											$author$project$Firestore$runQueryTx,
											transaction,
											$author$project$Firestore$Codec$asDecoder($author$project$Worker$codec),
											A2(
												$author$project$Firestore$Query$where_,
												A3(
													$author$project$Firestore$Query$fieldFilter,
													'age',
													$author$project$Firestore$Query$LessThanOrEqual,
													$author$project$Firestore$Query$int(20)),
												A2($author$project$Firestore$Query$from, 'users', $author$project$Firestore$Query$new)),
											model));
								},
								$author$project$Firestore$begin(model)))));
			default:
				var result = msg.a;
				return _Utils_Tuple2(
					model,
					$author$project$Worker$testQueryTxResult(
						A2(
							$elm$core$Result$withDefault,
							$author$project$Worker$ngValue,
							A2(
								$elm$core$Result$map,
								function (_v17) {
									return $author$project$Worker$okValue($elm$json$Json$Encode$null);
								},
								result))));
		}
	});
var $elm$core$Platform$worker = _Platform_worker;
var $author$project$Worker$main = $elm$core$Platform$worker(
	{init: $author$project$Worker$init, subscriptions: $author$project$Worker$subscriptions, update: $author$project$Worker$update});
_Platform_export({'Worker':{'init':$author$project$Worker$main(
	$elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));