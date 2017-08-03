module wilcox;

import common;
import normal;
import gamma;

/*
** dmd wilcox.d common.d normal.d gamma.d && ./wilcox
*/

T dweibull(T)(T x, T shape, T scale, int give_log)
{
    T tmp1, tmp2;

    immutable(T) INF = T.infinity;
    
    if (isNaN(x) || isNaN(shape) || isNaN(scale))
	    return x + shape + scale;
    
    if (shape <= 0 || scale <= 0)
    	return T.nan;

    mixin R_D__0!give_log;

    if (x < 0)
    	return R_D__0;
    if (!isFinite(x))
    	return R_D__0;
    /* need to handle x == 0 separately */
    if(x == 0 && shape < 1)
    	return INF;
    tmp1 = pow(x / scale, shape - 1);
    tmp2 = tmp1 * (x / scale);
    /* These are incorrect if tmp1 == 0 */
    return  give_log ? -tmp2 + log(shape * tmp1 / scale) : shape * tmp1 * exp(-tmp2) / scale;
}


T pweibull(T)(T x, T shape, T scale, int lower_tail, int log_p)
{
    if(isNaN(x) || isNaN(shape) || isNaN(scale))
	    return x + shape + scale;
    
    if(shape <= 0 || scale <= 0)
    	return T.nan;

    if (x <= 0)
	    return R_DT_0!T(lower_tail, log_p);
    x = -pow(x / scale, shape);
    return lower_tail ? (log_p ? R_Log1_Exp!T(x) : -expm1(x)) : R_D_exp!T(x, log_p);
}

T qweibull(T)(T p, T shape, T scale, int lower_tail, int log_p)
{
    if(isNaN(p) || isNaN(shape) || isNaN(scale))
	return p + shape + scale;
    
    if(shape <= 0 || scale <= 0)
    	return T.nan;

    immutable(T) INF = T.infinity;
    mixin (R_Q_P01_boundaries!(p, 0, INF));

    return scale * pow(-R_DT_Clog!T(p, lower_tail, log_p), 1./shape);
}


T rweibull(T)(T shape, T scale)
{
    if (!isFinite(shape) || !isFinite(scale) || shape <= 0. || scale <= 0.) {
	    if(scale == 0.)
	    	return 0.;
	    /* else */
	        return T.nan;
    }

    return scale * pow(-log(unif_rand!T()), 1.0 / shape);
}


void main()
{
	import std.stdio: writeln;
	writeln("dweibull: ", dweibull(1., 2., 3., 0));
	writeln("pweibull: ", pweibull(1., 2., 3., 1, 0));
	writeln("qweibull: ", qweibull(0.7, 2., 3., 1, 0));
	writeln("rweibull: ", rweibull(2., 3.), ", rweibull: ", rweibull(2., 3.), ", rweibull: ", rweibull(2., 3.));
}

