Module["asm"] =  (function(global,env,buffer) {

 "almost asm";
 var a = global.Int8Array;
 var b = global.Int16Array;
 var c = global.Int32Array;
 var d = global.Uint8Array;
 var e = global.Uint16Array;
 var f = global.Uint32Array;
 var g = global.Float32Array;
 var h = global.Float64Array;
 var i = new a(buffer);
 var j = new b(buffer);
 var k = new c(buffer);
 var l = new d(buffer);
 var m = new e(buffer);
 var n = new f(buffer);
 var o = new g(buffer);
 var p = new h(buffer);
 var q = global.byteLength;
 var r = env.STACKTOP | 0;
 var s = env.STACK_MAX | 0;
 var t = env.tempDoublePtr | 0;
 var u = env.ABORT | 0;
 var v = 0;
 var w = 0;
 var x = 0;
 var y = 0;
 var z = global.NaN, A = global.Infinity;
 var B = 0, C = 0, D = 0, E = 0, F = 0.0, G = 0, H = 0, I = 0, J = 0.0;
 var K = 0;
 var L = 0;
 var M = 0;
 var N = 0;
 var O = 0;
 var P = 0;
 var Q = 0;
 var R = 0;
 var S = 0;
 var T = 0;
 var U = global.Math.floor;
 var V = global.Math.abs;
 var W = global.Math.sqrt;
 var X = global.Math.pow;
 var Y = global.Math.cos;
 var Z = global.Math.sin;
 var _ = global.Math.tan;
 var $ = global.Math.acos;
 var aa = global.Math.asin;
 var ba = global.Math.atan;
 var ca = global.Math.atan2;
 var da = global.Math.exp;
 var ea = global.Math.log;
 var fa = global.Math.ceil;
 var ga = global.Math.imul;
 var ha = global.Math.min;
 var ia = global.Math.clz32;
 var ja = env.abort;
 var ka = env.assert;
 var la = env.invoke_ii;
 var ma = env.invoke_iiii;
 var na = env.invoke_vi;
 var oa = env._pthread_cleanup_pop;
 var pa = env.___lock;
 var qa = env._abort;
 var ra = env._pthread_cleanup_push;
 var sa = env.___syscall6;
 var ta = env._sbrk;
 var ua = env.___syscall140;
 var va = env._emscripten_memcpy_big;
 var wa = env.___syscall54;
 var xa = env.___unlock;
 var ya = env.___syscall146;
 var za = 0.0;
 function Aa(newBuffer) {
  if (q(newBuffer) & 16777215 || q(newBuffer) <= 16777215 || q(newBuffer) > 2147483648) return false;
  i = new a(newBuffer);
  j = new b(newBuffer);
  k = new c(newBuffer);
  l = new d(newBuffer);
  m = new e(newBuffer);
  n = new f(newBuffer);
  o = new g(newBuffer);
  p = new h(newBuffer);
  buffer = newBuffer;
  return true;
 }
 
// EMSCRIPTEN_START_FUNCS

function eb(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0, i = 0, j = 0, l = 0, m = 0, n = 0, o = 0, p = 0, q = 0, s = 0, t = 0, u = 0, v = 0, w = 0, x = 0, y = 0, z = 0, A = 0, B = 0, C = 0, D = 0, E = 0, F = 0, G = 0, H = 0, I = 0, J = 0, K = 0, L = 0, M = 0, N = 0, O = 0, P = 0, Q = 0, R = 0, S = 0, T = 0, U = 0, V = 0, W = 0, X = 0, Y = 0, Z = 0, _ = 0, $ = 0, aa = 0, ba = 0, ca = 0, da = 0, ea = 0, fa = 0, ga = 0, ha = 0, ia = 0, ja = 0, ka = 0, la = 0, ma = 0, na = 0, oa = 0, pa = 0, ra = 0, sa = 0, ua = 0, va = 0, wa = 0, xa = 0, ya = 0, za = 0, Aa = 0, Ba = 0, Ca = 0, Da = 0, Ea = 0, Fa = 0, Ga = 0, Ha = 0, Ia = 0, Ja = 0, Ka = 0, La = 0, Ma = 0, Na = 0, Oa = 0, Pa = 0, Ra = 0, Sa = 0;
 b = r;
 r = r + 16 | 0;
 c = b;
 do if (a >>> 0 < 245) {
  d = a >>> 0 < 11 ? 16 : a + 11 & -8;
  e = d >>> 3;
  f = k[302] | 0;
  g = f >>> e;
  if (g & 3 | 0) {
   h = (g & 1 ^ 1) + e | 0;
   i = 1248 + (h << 1 << 2) | 0;
   j = i + 8 | 0;
   l = k[j >> 2] | 0;
   m = l + 8 | 0;
   n = k[m >> 2] | 0;
   do if ((i | 0) == (n | 0)) k[302] = f & ~(1 << h); else {
    if (n >>> 0 < (k[306] | 0) >>> 0) qa();
    o = n + 12 | 0;
    if ((k[o >> 2] | 0) == (l | 0)) {
     k[o >> 2] = i;
     k[j >> 2] = n;
     break;
    } else qa();
   } while (0);
   n = h << 3;
   k[l + 4 >> 2] = n | 3;
   j = l + n + 4 | 0;
   k[j >> 2] = k[j >> 2] | 1;
   p = m;
   r = b;
   return p | 0;
  }
  j = k[304] | 0;
  if (d >>> 0 > j >>> 0) {
   if (g | 0) {
    n = 2 << e;
    i = g << e & (n | 0 - n);
    n = (i & 0 - i) + -1 | 0;
    i = n >>> 12 & 16;
    o = n >>> i;
    n = o >>> 5 & 8;
    q = o >>> n;
    o = q >>> 2 & 4;
    s = q >>> o;
    q = s >>> 1 & 2;
    t = s >>> q;
    s = t >>> 1 & 1;
    u = (n | i | o | q | s) + (t >>> s) | 0;
    s = 1248 + (u << 1 << 2) | 0;
    t = s + 8 | 0;
    q = k[t >> 2] | 0;
    o = q + 8 | 0;
    i = k[o >> 2] | 0;
    do if ((s | 0) == (i | 0)) {
     k[302] = f & ~(1 << u);
     v = j;
    } else {
     if (i >>> 0 < (k[306] | 0) >>> 0) qa();
     n = i + 12 | 0;
     if ((k[n >> 2] | 0) == (q | 0)) {
      k[n >> 2] = s;
      k[t >> 2] = i;
      v = k[304] | 0;
      break;
     } else qa();
    } while (0);
    i = (u << 3) - d | 0;
    k[q + 4 >> 2] = d | 3;
    t = q + d | 0;
    k[t + 4 >> 2] = i | 1;
    k[t + i >> 2] = i;
    if (v | 0) {
     s = k[307] | 0;
     j = v >>> 3;
     f = 1248 + (j << 1 << 2) | 0;
     e = k[302] | 0;
     g = 1 << j;
     if (!(e & g)) {
      k[302] = e | g;
      w = f + 8 | 0;
      x = f;
     } else {
      g = f + 8 | 0;
      e = k[g >> 2] | 0;
      if (e >>> 0 < (k[306] | 0) >>> 0) qa(); else {
       w = g;
       x = e;
      }
     }
     k[w >> 2] = s;
     k[x + 12 >> 2] = s;
     k[s + 8 >> 2] = x;
     k[s + 12 >> 2] = f;
    }
    k[304] = i;
    k[307] = t;
    p = o;
    r = b;
    return p | 0;
   }
   t = k[303] | 0;
   if (!t) y = d; else {
    i = (t & 0 - t) + -1 | 0;
    t = i >>> 12 & 16;
    f = i >>> t;
    i = f >>> 5 & 8;
    s = f >>> i;
    f = s >>> 2 & 4;
    e = s >>> f;
    s = e >>> 1 & 2;
    g = e >>> s;
    e = g >>> 1 & 1;
    j = k[1512 + ((i | t | f | s | e) + (g >>> e) << 2) >> 2] | 0;
    e = (k[j + 4 >> 2] & -8) - d | 0;
    g = j;
    s = j;
    while (1) {
     j = k[g + 16 >> 2] | 0;
     if (!j) {
      f = k[g + 20 >> 2] | 0;
      if (!f) {
       z = e;
       A = s;
       break;
      } else B = f;
     } else B = j;
     j = (k[B + 4 >> 2] & -8) - d | 0;
     f = j >>> 0 < e >>> 0;
     e = f ? j : e;
     g = B;
     s = f ? B : s;
    }
    s = k[306] | 0;
    if (A >>> 0 < s >>> 0) qa();
    g = A + d | 0;
    if (A >>> 0 >= g >>> 0) qa();
    e = k[A + 24 >> 2] | 0;
    o = k[A + 12 >> 2] | 0;
    do if ((o | 0) == (A | 0)) {
     q = A + 20 | 0;
     u = k[q >> 2] | 0;
     if (!u) {
      f = A + 16 | 0;
      j = k[f >> 2] | 0;
      if (!j) {
       C = 0;
       break;
      } else {
       D = j;
       E = f;
      }
     } else {
      D = u;
      E = q;
     }
     while (1) {
      q = D + 20 | 0;
      u = k[q >> 2] | 0;
      if (u | 0) {
       D = u;
       E = q;
       continue;
      }
      q = D + 16 | 0;
      u = k[q >> 2] | 0;
      if (!u) {
       F = D;
       G = E;
       break;
      } else {
       D = u;
       E = q;
      }
     }
     if (G >>> 0 < s >>> 0) qa(); else {
      k[G >> 2] = 0;
      C = F;
      break;
     }
    } else {
     q = k[A + 8 >> 2] | 0;
     if (q >>> 0 < s >>> 0) qa();
     u = q + 12 | 0;
     if ((k[u >> 2] | 0) != (A | 0)) qa();
     f = o + 8 | 0;
     if ((k[f >> 2] | 0) == (A | 0)) {
      k[u >> 2] = o;
      k[f >> 2] = q;
      C = o;
      break;
     } else qa();
    } while (0);
    do if (e | 0) {
     o = k[A + 28 >> 2] | 0;
     s = 1512 + (o << 2) | 0;
     if ((A | 0) == (k[s >> 2] | 0)) {
      k[s >> 2] = C;
      if (!C) {
       k[303] = k[303] & ~(1 << o);
       break;
      }
     } else {
      if (e >>> 0 < (k[306] | 0) >>> 0) qa();
      o = e + 16 | 0;
      if ((k[o >> 2] | 0) == (A | 0)) k[o >> 2] = C; else k[e + 20 >> 2] = C;
      if (!C) break;
     }
     o = k[306] | 0;
     if (C >>> 0 < o >>> 0) qa();
     k[C + 24 >> 2] = e;
     s = k[A + 16 >> 2] | 0;
     do if (s | 0) if (s >>> 0 < o >>> 0) qa(); else {
      k[C + 16 >> 2] = s;
      k[s + 24 >> 2] = C;
      break;
     } while (0);
     s = k[A + 20 >> 2] | 0;
     if (s | 0) if (s >>> 0 < (k[306] | 0) >>> 0) qa(); else {
      k[C + 20 >> 2] = s;
      k[s + 24 >> 2] = C;
      break;
     }
    } while (0);
    if (z >>> 0 < 16) {
     e = z + d | 0;
     k[A + 4 >> 2] = e | 3;
     s = A + e + 4 | 0;
     k[s >> 2] = k[s >> 2] | 1;
    } else {
     k[A + 4 >> 2] = d | 3;
     k[g + 4 >> 2] = z | 1;
     k[g + z >> 2] = z;
     s = k[304] | 0;
     if (s | 0) {
      e = k[307] | 0;
      o = s >>> 3;
      s = 1248 + (o << 1 << 2) | 0;
      q = k[302] | 0;
      f = 1 << o;
      if (!(q & f)) {
       k[302] = q | f;
       H = s + 8 | 0;
       I = s;
      } else {
       f = s + 8 | 0;
       q = k[f >> 2] | 0;
       if (q >>> 0 < (k[306] | 0) >>> 0) qa(); else {
        H = f;
        I = q;
       }
      }
      k[H >> 2] = e;
      k[I + 12 >> 2] = e;
      k[e + 8 >> 2] = I;
      k[e + 12 >> 2] = s;
     }
     k[304] = z;
     k[307] = g;
    }
    p = A + 8 | 0;
    r = b;
    return p | 0;
   }
  } else y = d;
 } else if (a >>> 0 > 4294967231) y = -1; else {
  s = a + 11 | 0;
  e = s & -8;
  q = k[303] | 0;
  if (!q) y = e; else {
   f = 0 - e | 0;
   o = s >>> 8;
   if (!o) J = 0; else if (e >>> 0 > 16777215) J = 31; else {
    s = (o + 1048320 | 0) >>> 16 & 8;
    u = o << s;
    o = (u + 520192 | 0) >>> 16 & 4;
    j = u << o;
    u = (j + 245760 | 0) >>> 16 & 2;
    t = 14 - (o | s | u) + (j << u >>> 15) | 0;
    J = e >>> (t + 7 | 0) & 1 | t << 1;
   }
   t = k[1512 + (J << 2) >> 2] | 0;
   a : do if (!t) {
    K = f;
    L = 0;
    M = 0;
    N = 86;
   } else {
    u = f;
    j = 0;
    s = e << ((J | 0) == 31 ? 0 : 25 - (J >>> 1) | 0);
    o = t;
    i = 0;
    while (1) {
     m = k[o + 4 >> 2] & -8;
     l = m - e | 0;
     if (l >>> 0 < u >>> 0) if ((m | 0) == (e | 0)) {
      O = l;
      P = o;
      Q = o;
      N = 90;
      break a;
     } else {
      R = l;
      S = o;
     } else {
      R = u;
      S = i;
     }
     l = k[o + 20 >> 2] | 0;
     o = k[o + 16 + (s >>> 31 << 2) >> 2] | 0;
     m = (l | 0) == 0 | (l | 0) == (o | 0) ? j : l;
     l = (o | 0) == 0;
     if (l) {
      K = R;
      L = m;
      M = S;
      N = 86;
      break;
     } else {
      u = R;
      j = m;
      s = s << (l & 1 ^ 1);
      i = S;
     }
    }
   } while (0);
   if ((N | 0) == 86) {
    if ((L | 0) == 0 & (M | 0) == 0) {
     t = 2 << J;
     f = q & (t | 0 - t);
     if (!f) {
      y = e;
      break;
     }
     t = (f & 0 - f) + -1 | 0;
     f = t >>> 12 & 16;
     d = t >>> f;
     t = d >>> 5 & 8;
     g = d >>> t;
     d = g >>> 2 & 4;
     i = g >>> d;
     g = i >>> 1 & 2;
     s = i >>> g;
     i = s >>> 1 & 1;
     T = k[1512 + ((t | f | d | g | i) + (s >>> i) << 2) >> 2] | 0;
    } else T = L;
    if (!T) {
     U = K;
     V = M;
    } else {
     O = K;
     P = T;
     Q = M;
     N = 90;
    }
   }
   if ((N | 0) == 90) while (1) {
    N = 0;
    i = (k[P + 4 >> 2] & -8) - e | 0;
    s = i >>> 0 < O >>> 0;
    g = s ? i : O;
    i = s ? P : Q;
    s = k[P + 16 >> 2] | 0;
    if (s | 0) {
     O = g;
     P = s;
     Q = i;
     N = 90;
     continue;
    }
    P = k[P + 20 >> 2] | 0;
    if (!P) {
     U = g;
     V = i;
     break;
    } else {
     O = g;
     Q = i;
     N = 90;
    }
   }
   if (!V) y = e; else if (U >>> 0 < ((k[304] | 0) - e | 0) >>> 0) {
    q = k[306] | 0;
    if (V >>> 0 < q >>> 0) qa();
    i = V + e | 0;
    if (V >>> 0 >= i >>> 0) qa();
    g = k[V + 24 >> 2] | 0;
    s = k[V + 12 >> 2] | 0;
    do if ((s | 0) == (V | 0)) {
     d = V + 20 | 0;
     f = k[d >> 2] | 0;
     if (!f) {
      t = V + 16 | 0;
      j = k[t >> 2] | 0;
      if (!j) {
       W = 0;
       break;
      } else {
       X = j;
       Y = t;
      }
     } else {
      X = f;
      Y = d;
     }
     while (1) {
      d = X + 20 | 0;
      f = k[d >> 2] | 0;
      if (f | 0) {
       X = f;
       Y = d;
       continue;
      }
      d = X + 16 | 0;
      f = k[d >> 2] | 0;
      if (!f) {
       Z = X;
       _ = Y;
       break;
      } else {
       X = f;
       Y = d;
      }
     }
     if (_ >>> 0 < q >>> 0) qa(); else {
      k[_ >> 2] = 0;
      W = Z;
      break;
     }
    } else {
     d = k[V + 8 >> 2] | 0;
     if (d >>> 0 < q >>> 0) qa();
     f = d + 12 | 0;
     if ((k[f >> 2] | 0) != (V | 0)) qa();
     t = s + 8 | 0;
     if ((k[t >> 2] | 0) == (V | 0)) {
      k[f >> 2] = s;
      k[t >> 2] = d;
      W = s;
      break;
     } else qa();
    } while (0);
    do if (g | 0) {
     s = k[V + 28 >> 2] | 0;
     q = 1512 + (s << 2) | 0;
     if ((V | 0) == (k[q >> 2] | 0)) {
      k[q >> 2] = W;
      if (!W) {
       k[303] = k[303] & ~(1 << s);
       break;
      }
     } else {
      if (g >>> 0 < (k[306] | 0) >>> 0) qa();
      s = g + 16 | 0;
      if ((k[s >> 2] | 0) == (V | 0)) k[s >> 2] = W; else k[g + 20 >> 2] = W;
      if (!W) break;
     }
     s = k[306] | 0;
     if (W >>> 0 < s >>> 0) qa();
     k[W + 24 >> 2] = g;
     q = k[V + 16 >> 2] | 0;
     do if (q | 0) if (q >>> 0 < s >>> 0) qa(); else {
      k[W + 16 >> 2] = q;
      k[q + 24 >> 2] = W;
      break;
     } while (0);
     q = k[V + 20 >> 2] | 0;
     if (q | 0) if (q >>> 0 < (k[306] | 0) >>> 0) qa(); else {
      k[W + 20 >> 2] = q;
      k[q + 24 >> 2] = W;
      break;
     }
    } while (0);
    do if (U >>> 0 < 16) {
     g = U + e | 0;
     k[V + 4 >> 2] = g | 3;
     q = V + g + 4 | 0;
     k[q >> 2] = k[q >> 2] | 1;
    } else {
     k[V + 4 >> 2] = e | 3;
     k[i + 4 >> 2] = U | 1;
     k[i + U >> 2] = U;
     q = U >>> 3;
     if (U >>> 0 < 256) {
      g = 1248 + (q << 1 << 2) | 0;
      s = k[302] | 0;
      d = 1 << q;
      if (!(s & d)) {
       k[302] = s | d;
       $ = g + 8 | 0;
       aa = g;
      } else {
       d = g + 8 | 0;
       s = k[d >> 2] | 0;
       if (s >>> 0 < (k[306] | 0) >>> 0) qa(); else {
        $ = d;
        aa = s;
       }
      }
      k[$ >> 2] = i;
      k[aa + 12 >> 2] = i;
      k[i + 8 >> 2] = aa;
      k[i + 12 >> 2] = g;
      break;
     }
     g = U >>> 8;
     if (!g) ba = 0; else if (U >>> 0 > 16777215) ba = 31; else {
      s = (g + 1048320 | 0) >>> 16 & 8;
      d = g << s;
      g = (d + 520192 | 0) >>> 16 & 4;
      q = d << g;
      d = (q + 245760 | 0) >>> 16 & 2;
      t = 14 - (g | s | d) + (q << d >>> 15) | 0;
      ba = U >>> (t + 7 | 0) & 1 | t << 1;
     }
     t = 1512 + (ba << 2) | 0;
     k[i + 28 >> 2] = ba;
     d = i + 16 | 0;
     k[d + 4 >> 2] = 0;
     k[d >> 2] = 0;
     d = k[303] | 0;
     q = 1 << ba;
     if (!(d & q)) {
      k[303] = d | q;
      k[t >> 2] = i;
      k[i + 24 >> 2] = t;
      k[i + 12 >> 2] = i;
      k[i + 8 >> 2] = i;
      break;
     }
     q = U << ((ba | 0) == 31 ? 0 : 25 - (ba >>> 1) | 0);
     d = k[t >> 2] | 0;
     while (1) {
      if ((k[d + 4 >> 2] & -8 | 0) == (U | 0)) {
       ca = d;
       N = 148;
       break;
      }
      t = d + 16 + (q >>> 31 << 2) | 0;
      s = k[t >> 2] | 0;
      if (!s) {
       da = t;
       ea = d;
       N = 145;
       break;
      } else {
       q = q << 1;
       d = s;
      }
     }
     if ((N | 0) == 145) if (da >>> 0 < (k[306] | 0) >>> 0) qa(); else {
      k[da >> 2] = i;
      k[i + 24 >> 2] = ea;
      k[i + 12 >> 2] = i;
      k[i + 8 >> 2] = i;
      break;
     } else if ((N | 0) == 148) {
      d = ca + 8 | 0;
      q = k[d >> 2] | 0;
      s = k[306] | 0;
      if (q >>> 0 >= s >>> 0 & ca >>> 0 >= s >>> 0) {
       k[q + 12 >> 2] = i;
       k[d >> 2] = i;
       k[i + 8 >> 2] = q;
       k[i + 12 >> 2] = ca;
       k[i + 24 >> 2] = 0;
       break;
      } else qa();
     }
    } while (0);
    p = V + 8 | 0;
    r = b;
    return p | 0;
   } else y = e;
  }
 } while (0);
 V = k[304] | 0;
 if (V >>> 0 >= y >>> 0) {
  ca = V - y | 0;
  ea = k[307] | 0;
  if (ca >>> 0 > 15) {
   da = ea + y | 0;
   k[307] = da;
   k[304] = ca;
   k[da + 4 >> 2] = ca | 1;
   k[da + ca >> 2] = ca;
   k[ea + 4 >> 2] = y | 3;
  } else {
   k[304] = 0;
   k[307] = 0;
   k[ea + 4 >> 2] = V | 3;
   ca = ea + V + 4 | 0;
   k[ca >> 2] = k[ca >> 2] | 1;
  }
  p = ea + 8 | 0;
  r = b;
  return p | 0;
 }
 ea = k[305] | 0;
 if (ea >>> 0 > y >>> 0) {
  ca = ea - y | 0;
  k[305] = ca;
  ea = k[308] | 0;
  V = ea + y | 0;
  k[308] = V;
  k[V + 4 >> 2] = ca | 1;
  k[ea + 4 >> 2] = y | 3;
  p = ea + 8 | 0;
  r = b;
  return p | 0;
 }
 if (!(k[420] | 0)) {
  k[422] = 4096;
  k[421] = 4096;
  k[423] = -1;
  k[424] = -1;
  k[425] = 0;
  k[413] = 0;
  ea = c & -16 ^ 1431655768;
  k[c >> 2] = ea;
  k[420] = ea;
 }
 ea = y + 48 | 0;
 c = k[422] | 0;
 ca = y + 47 | 0;
 V = c + ca | 0;
 da = 0 - c | 0;
 c = V & da;
 if (c >>> 0 <= y >>> 0) {
  p = 0;
  r = b;
  return p | 0;
 }
 U = k[412] | 0;
 if (U | 0) {
  ba = k[410] | 0;
  aa = ba + c | 0;
  if (aa >>> 0 <= ba >>> 0 | aa >>> 0 > U >>> 0) {
   p = 0;
   r = b;
   return p | 0;
  }
 }
 b : do if (!(k[413] & 4)) {
  U = k[308] | 0;
  c : do if (!U) N = 171; else {
   aa = 1656;
   while (1) {
    ba = k[aa >> 2] | 0;
    if (ba >>> 0 <= U >>> 0) {
     $ = aa + 4 | 0;
     if ((ba + (k[$ >> 2] | 0) | 0) >>> 0 > U >>> 0) {
      fa = aa;
      ga = $;
      break;
     }
    }
    aa = k[aa + 8 >> 2] | 0;
    if (!aa) {
     N = 171;
     break c;
    }
   }
   aa = V - (k[305] | 0) & da;
   if (aa >>> 0 < 2147483647) {
    $ = ta(aa | 0) | 0;
    if (($ | 0) == ((k[fa >> 2] | 0) + (k[ga >> 2] | 0) | 0)) {
     if (($ | 0) != (-1 | 0)) {
      ha = $;
      ia = aa;
      N = 191;
      break b;
     }
    } else {
     ja = $;
     ka = aa;
     N = 181;
    }
   }
  } while (0);
  do if ((N | 0) == 171) {
   U = ta(0) | 0;
   if ((U | 0) != (-1 | 0)) {
    e = U;
    aa = k[421] | 0;
    $ = aa + -1 | 0;
    if (!($ & e)) la = c; else la = c - e + ($ + e & 0 - aa) | 0;
    aa = k[410] | 0;
    e = aa + la | 0;
    if (la >>> 0 > y >>> 0 & la >>> 0 < 2147483647) {
     $ = k[412] | 0;
     if ($ | 0) if (e >>> 0 <= aa >>> 0 | e >>> 0 > $ >>> 0) break;
     $ = ta(la | 0) | 0;
     if (($ | 0) == (U | 0)) {
      ha = U;
      ia = la;
      N = 191;
      break b;
     } else {
      ja = $;
      ka = la;
      N = 181;
     }
    }
   }
  } while (0);
  d : do if ((N | 0) == 181) {
   $ = 0 - ka | 0;
   do if (ea >>> 0 > ka >>> 0 & (ka >>> 0 < 2147483647 & (ja | 0) != (-1 | 0))) {
    U = k[422] | 0;
    e = ca - ka + U & 0 - U;
    if (e >>> 0 < 2147483647) if ((ta(e | 0) | 0) == (-1 | 0)) {
     ta($ | 0) | 0;
     break d;
    } else {
     ma = e + ka | 0;
     break;
    } else ma = ka;
   } else ma = ka; while (0);
   if ((ja | 0) != (-1 | 0)) {
    ha = ja;
    ia = ma;
    N = 191;
    break b;
   }
  } while (0);
  k[413] = k[413] | 4;
  N = 188;
 } else N = 188; while (0);
 if ((N | 0) == 188) if (c >>> 0 < 2147483647) {
  ma = ta(c | 0) | 0;
  c = ta(0) | 0;
  if (ma >>> 0 < c >>> 0 & ((ma | 0) != (-1 | 0) & (c | 0) != (-1 | 0))) {
   ja = c - ma | 0;
   if (ja >>> 0 > (y + 40 | 0) >>> 0) {
    ha = ma;
    ia = ja;
    N = 191;
   }
  }
 }
 if ((N | 0) == 191) {
  ja = (k[410] | 0) + ia | 0;
  k[410] = ja;
  if (ja >>> 0 > (k[411] | 0) >>> 0) k[411] = ja;
  ja = k[308] | 0;
  do if (!ja) {
   ma = k[306] | 0;
   if ((ma | 0) == 0 | ha >>> 0 < ma >>> 0) k[306] = ha;
   k[414] = ha;
   k[415] = ia;
   k[417] = 0;
   k[311] = k[420];
   k[310] = -1;
   ma = 0;
   do {
    c = 1248 + (ma << 1 << 2) | 0;
    k[c + 12 >> 2] = c;
    k[c + 8 >> 2] = c;
    ma = ma + 1 | 0;
   } while ((ma | 0) != 32);
   ma = ha + 8 | 0;
   c = (ma & 7 | 0) == 0 ? 0 : 0 - ma & 7;
   ma = ha + c | 0;
   ka = ia + -40 - c | 0;
   k[308] = ma;
   k[305] = ka;
   k[ma + 4 >> 2] = ka | 1;
   k[ma + ka + 4 >> 2] = 40;
   k[309] = k[424];
  } else {
   ka = 1656;
   do {
    ma = k[ka >> 2] | 0;
    c = ka + 4 | 0;
    ca = k[c >> 2] | 0;
    if ((ha | 0) == (ma + ca | 0)) {
     na = ma;
     oa = c;
     pa = ca;
     ra = ka;
     N = 201;
     break;
    }
    ka = k[ka + 8 >> 2] | 0;
   } while ((ka | 0) != 0);
   if ((N | 0) == 201) if (!(k[ra + 12 >> 2] & 8)) if (ja >>> 0 < ha >>> 0 & ja >>> 0 >= na >>> 0) {
    k[oa >> 2] = pa + ia;
    ka = ja + 8 | 0;
    ca = (ka & 7 | 0) == 0 ? 0 : 0 - ka & 7;
    ka = ja + ca | 0;
    c = ia - ca + (k[305] | 0) | 0;
    k[308] = ka;
    k[305] = c;
    k[ka + 4 >> 2] = c | 1;
    k[ka + c + 4 >> 2] = 40;
    k[309] = k[424];
    break;
   }
   c = k[306] | 0;
   if (ha >>> 0 < c >>> 0) {
    k[306] = ha;
    sa = ha;
   } else sa = c;
   c = ha + ia | 0;
   ka = 1656;
   while (1) {
    if ((k[ka >> 2] | 0) == (c | 0)) {
     ua = ka;
     va = ka;
     N = 209;
     break;
    }
    ka = k[ka + 8 >> 2] | 0;
    if (!ka) {
     wa = 1656;
     break;
    }
   }
   if ((N | 0) == 209) if (!(k[va + 12 >> 2] & 8)) {
    k[ua >> 2] = ha;
    ka = va + 4 | 0;
    k[ka >> 2] = (k[ka >> 2] | 0) + ia;
    ka = ha + 8 | 0;
    ca = ha + ((ka & 7 | 0) == 0 ? 0 : 0 - ka & 7) | 0;
    ka = c + 8 | 0;
    ma = c + ((ka & 7 | 0) == 0 ? 0 : 0 - ka & 7) | 0;
    ka = ca + y | 0;
    ea = ma - ca - y | 0;
    k[ca + 4 >> 2] = y | 3;
    do if ((ma | 0) == (ja | 0)) {
     la = (k[305] | 0) + ea | 0;
     k[305] = la;
     k[308] = ka;
     k[ka + 4 >> 2] = la | 1;
    } else {
     if ((ma | 0) == (k[307] | 0)) {
      la = (k[304] | 0) + ea | 0;
      k[304] = la;
      k[307] = ka;
      k[ka + 4 >> 2] = la | 1;
      k[ka + la >> 2] = la;
      break;
     }
     la = k[ma + 4 >> 2] | 0;
     if ((la & 3 | 0) == 1) {
      ga = la & -8;
      fa = la >>> 3;
      e : do if (la >>> 0 < 256) {
       da = k[ma + 8 >> 2] | 0;
       V = k[ma + 12 >> 2] | 0;
       $ = 1248 + (fa << 1 << 2) | 0;
       do if ((da | 0) != ($ | 0)) {
        if (da >>> 0 < sa >>> 0) qa();
        if ((k[da + 12 >> 2] | 0) == (ma | 0)) break;
        qa();
       } while (0);
       if ((V | 0) == (da | 0)) {
        k[302] = k[302] & ~(1 << fa);
        break;
       }
       do if ((V | 0) == ($ | 0)) xa = V + 8 | 0; else {
        if (V >>> 0 < sa >>> 0) qa();
        e = V + 8 | 0;
        if ((k[e >> 2] | 0) == (ma | 0)) {
         xa = e;
         break;
        }
        qa();
       } while (0);
       k[da + 12 >> 2] = V;
       k[xa >> 2] = da;
      } else {
       $ = k[ma + 24 >> 2] | 0;
       e = k[ma + 12 >> 2] | 0;
       do if ((e | 0) == (ma | 0)) {
        U = ma + 16 | 0;
        aa = U + 4 | 0;
        ba = k[aa >> 2] | 0;
        if (!ba) {
         W = k[U >> 2] | 0;
         if (!W) {
          ya = 0;
          break;
         } else {
          za = W;
          Aa = U;
         }
        } else {
         za = ba;
         Aa = aa;
        }
        while (1) {
         aa = za + 20 | 0;
         ba = k[aa >> 2] | 0;
         if (ba | 0) {
          za = ba;
          Aa = aa;
          continue;
         }
         aa = za + 16 | 0;
         ba = k[aa >> 2] | 0;
         if (!ba) {
          Ba = za;
          Ca = Aa;
          break;
         } else {
          za = ba;
          Aa = aa;
         }
        }
        if (Ca >>> 0 < sa >>> 0) qa(); else {
         k[Ca >> 2] = 0;
         ya = Ba;
         break;
        }
       } else {
        aa = k[ma + 8 >> 2] | 0;
        if (aa >>> 0 < sa >>> 0) qa();
        ba = aa + 12 | 0;
        if ((k[ba >> 2] | 0) != (ma | 0)) qa();
        U = e + 8 | 0;
        if ((k[U >> 2] | 0) == (ma | 0)) {
         k[ba >> 2] = e;
         k[U >> 2] = aa;
         ya = e;
         break;
        } else qa();
       } while (0);
       if (!$) break;
       e = k[ma + 28 >> 2] | 0;
       da = 1512 + (e << 2) | 0;
       do if ((ma | 0) == (k[da >> 2] | 0)) {
        k[da >> 2] = ya;
        if (ya | 0) break;
        k[303] = k[303] & ~(1 << e);
        break e;
       } else {
        if ($ >>> 0 < (k[306] | 0) >>> 0) qa();
        V = $ + 16 | 0;
        if ((k[V >> 2] | 0) == (ma | 0)) k[V >> 2] = ya; else k[$ + 20 >> 2] = ya;
        if (!ya) break e;
       } while (0);
       e = k[306] | 0;
       if (ya >>> 0 < e >>> 0) qa();
       k[ya + 24 >> 2] = $;
       da = ma + 16 | 0;
       V = k[da >> 2] | 0;
       do if (V | 0) if (V >>> 0 < e >>> 0) qa(); else {
        k[ya + 16 >> 2] = V;
        k[V + 24 >> 2] = ya;
        break;
       } while (0);
       V = k[da + 4 >> 2] | 0;
       if (!V) break;
       if (V >>> 0 < (k[306] | 0) >>> 0) qa(); else {
        k[ya + 20 >> 2] = V;
        k[V + 24 >> 2] = ya;
        break;
       }
      } while (0);
      Da = ma + ga | 0;
      Ea = ga + ea | 0;
     } else {
      Da = ma;
      Ea = ea;
     }
     fa = Da + 4 | 0;
     k[fa >> 2] = k[fa >> 2] & -2;
     k[ka + 4 >> 2] = Ea | 1;
     k[ka + Ea >> 2] = Ea;
     fa = Ea >>> 3;
     if (Ea >>> 0 < 256) {
      la = 1248 + (fa << 1 << 2) | 0;
      V = k[302] | 0;
      e = 1 << fa;
      do if (!(V & e)) {
       k[302] = V | e;
       Fa = la + 8 | 0;
       Ga = la;
      } else {
       fa = la + 8 | 0;
       $ = k[fa >> 2] | 0;
       if ($ >>> 0 >= (k[306] | 0) >>> 0) {
        Fa = fa;
        Ga = $;
        break;
       }
       qa();
      } while (0);
      k[Fa >> 2] = ka;
      k[Ga + 12 >> 2] = ka;
      k[ka + 8 >> 2] = Ga;
      k[ka + 12 >> 2] = la;
      break;
     }
     e = Ea >>> 8;
     do if (!e) Ha = 0; else {
      if (Ea >>> 0 > 16777215) {
       Ha = 31;
       break;
      }
      V = (e + 1048320 | 0) >>> 16 & 8;
      ga = e << V;
      $ = (ga + 520192 | 0) >>> 16 & 4;
      fa = ga << $;
      ga = (fa + 245760 | 0) >>> 16 & 2;
      aa = 14 - ($ | V | ga) + (fa << ga >>> 15) | 0;
      Ha = Ea >>> (aa + 7 | 0) & 1 | aa << 1;
     } while (0);
     e = 1512 + (Ha << 2) | 0;
     k[ka + 28 >> 2] = Ha;
     la = ka + 16 | 0;
     k[la + 4 >> 2] = 0;
     k[la >> 2] = 0;
     la = k[303] | 0;
     aa = 1 << Ha;
     if (!(la & aa)) {
      k[303] = la | aa;
      k[e >> 2] = ka;
      k[ka + 24 >> 2] = e;
      k[ka + 12 >> 2] = ka;
      k[ka + 8 >> 2] = ka;
      break;
     }
     aa = Ea << ((Ha | 0) == 31 ? 0 : 25 - (Ha >>> 1) | 0);
     la = k[e >> 2] | 0;
     while (1) {
      if ((k[la + 4 >> 2] & -8 | 0) == (Ea | 0)) {
       Ia = la;
       N = 279;
       break;
      }
      e = la + 16 + (aa >>> 31 << 2) | 0;
      ga = k[e >> 2] | 0;
      if (!ga) {
       Ja = e;
       Ka = la;
       N = 276;
       break;
      } else {
       aa = aa << 1;
       la = ga;
      }
     }
     if ((N | 0) == 276) if (Ja >>> 0 < (k[306] | 0) >>> 0) qa(); else {
      k[Ja >> 2] = ka;
      k[ka + 24 >> 2] = Ka;
      k[ka + 12 >> 2] = ka;
      k[ka + 8 >> 2] = ka;
      break;
     } else if ((N | 0) == 279) {
      la = Ia + 8 | 0;
      aa = k[la >> 2] | 0;
      ga = k[306] | 0;
      if (aa >>> 0 >= ga >>> 0 & Ia >>> 0 >= ga >>> 0) {
       k[aa + 12 >> 2] = ka;
       k[la >> 2] = ka;
       k[ka + 8 >> 2] = aa;
       k[ka + 12 >> 2] = Ia;
       k[ka + 24 >> 2] = 0;
       break;
      } else qa();
     }
    } while (0);
    p = ca + 8 | 0;
    r = b;
    return p | 0;
   } else wa = 1656;
   while (1) {
    ka = k[wa >> 2] | 0;
    if (ka >>> 0 <= ja >>> 0) {
     ea = ka + (k[wa + 4 >> 2] | 0) | 0;
     if (ea >>> 0 > ja >>> 0) {
      La = ea;
      break;
     }
    }
    wa = k[wa + 8 >> 2] | 0;
   }
   ca = La + -47 | 0;
   ea = ca + 8 | 0;
   ka = ca + ((ea & 7 | 0) == 0 ? 0 : 0 - ea & 7) | 0;
   ea = ja + 16 | 0;
   ca = ka >>> 0 < ea >>> 0 ? ja : ka;
   ka = ca + 8 | 0;
   ma = ha + 8 | 0;
   c = (ma & 7 | 0) == 0 ? 0 : 0 - ma & 7;
   ma = ha + c | 0;
   aa = ia + -40 - c | 0;
   k[308] = ma;
   k[305] = aa;
   k[ma + 4 >> 2] = aa | 1;
   k[ma + aa + 4 >> 2] = 40;
   k[309] = k[424];
   aa = ca + 4 | 0;
   k[aa >> 2] = 27;
   k[ka >> 2] = k[414];
   k[ka + 4 >> 2] = k[415];
   k[ka + 8 >> 2] = k[416];
   k[ka + 12 >> 2] = k[417];
   k[414] = ha;
   k[415] = ia;
   k[417] = 0;
   k[416] = ka;
   ka = ca + 24 | 0;
   do {
    ka = ka + 4 | 0;
    k[ka >> 2] = 7;
   } while ((ka + 4 | 0) >>> 0 < La >>> 0);
   if ((ca | 0) != (ja | 0)) {
    ka = ca - ja | 0;
    k[aa >> 2] = k[aa >> 2] & -2;
    k[ja + 4 >> 2] = ka | 1;
    k[ca >> 2] = ka;
    ma = ka >>> 3;
    if (ka >>> 0 < 256) {
     c = 1248 + (ma << 1 << 2) | 0;
     la = k[302] | 0;
     ga = 1 << ma;
     if (!(la & ga)) {
      k[302] = la | ga;
      Ma = c + 8 | 0;
      Na = c;
     } else {
      ga = c + 8 | 0;
      la = k[ga >> 2] | 0;
      if (la >>> 0 < (k[306] | 0) >>> 0) qa(); else {
       Ma = ga;
       Na = la;
      }
     }
     k[Ma >> 2] = ja;
     k[Na + 12 >> 2] = ja;
     k[ja + 8 >> 2] = Na;
     k[ja + 12 >> 2] = c;
     break;
    }
    c = ka >>> 8;
    if (!c) Oa = 0; else if (ka >>> 0 > 16777215) Oa = 31; else {
     la = (c + 1048320 | 0) >>> 16 & 8;
     ga = c << la;
     c = (ga + 520192 | 0) >>> 16 & 4;
     ma = ga << c;
     ga = (ma + 245760 | 0) >>> 16 & 2;
     e = 14 - (c | la | ga) + (ma << ga >>> 15) | 0;
     Oa = ka >>> (e + 7 | 0) & 1 | e << 1;
    }
    e = 1512 + (Oa << 2) | 0;
    k[ja + 28 >> 2] = Oa;
    k[ja + 20 >> 2] = 0;
    k[ea >> 2] = 0;
    ga = k[303] | 0;
    ma = 1 << Oa;
    if (!(ga & ma)) {
     k[303] = ga | ma;
     k[e >> 2] = ja;
     k[ja + 24 >> 2] = e;
     k[ja + 12 >> 2] = ja;
     k[ja + 8 >> 2] = ja;
     break;
    }
    ma = ka << ((Oa | 0) == 31 ? 0 : 25 - (Oa >>> 1) | 0);
    ga = k[e >> 2] | 0;
    while (1) {
     if ((k[ga + 4 >> 2] & -8 | 0) == (ka | 0)) {
      Pa = ga;
      N = 305;
      break;
     }
     e = ga + 16 + (ma >>> 31 << 2) | 0;
     la = k[e >> 2] | 0;
     if (!la) {
      Ra = e;
      Sa = ga;
      N = 302;
      break;
     } else {
      ma = ma << 1;
      ga = la;
     }
    }
    if ((N | 0) == 302) if (Ra >>> 0 < (k[306] | 0) >>> 0) qa(); else {
     k[Ra >> 2] = ja;
     k[ja + 24 >> 2] = Sa;
     k[ja + 12 >> 2] = ja;
     k[ja + 8 >> 2] = ja;
     break;
    } else if ((N | 0) == 305) {
     ga = Pa + 8 | 0;
     ma = k[ga >> 2] | 0;
     ka = k[306] | 0;
     if (ma >>> 0 >= ka >>> 0 & Pa >>> 0 >= ka >>> 0) {
      k[ma + 12 >> 2] = ja;
      k[ga >> 2] = ja;
      k[ja + 8 >> 2] = ma;
      k[ja + 12 >> 2] = Pa;
      k[ja + 24 >> 2] = 0;
      break;
     } else qa();
    }
   }
  } while (0);
  ja = k[305] | 0;
  if (ja >>> 0 > y >>> 0) {
   Pa = ja - y | 0;
   k[305] = Pa;
   ja = k[308] | 0;
   N = ja + y | 0;
   k[308] = N;
   k[N + 4 >> 2] = Pa | 1;
   k[ja + 4 >> 2] = y | 3;
   p = ja + 8 | 0;
   r = b;
   return p | 0;
  }
 }
 ja = Qa() | 0;
 k[ja >> 2] = 12;
 p = 0;
 r = b;
 return p | 0;
}

function fb(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0, i = 0, j = 0, l = 0, m = 0, n = 0, o = 0, p = 0, q = 0, r = 0, s = 0, t = 0, u = 0, v = 0, w = 0, x = 0, y = 0, z = 0, A = 0, B = 0, C = 0, D = 0, E = 0, F = 0, G = 0, H = 0, I = 0, J = 0, K = 0, L = 0;
 if (!a) return;
 b = a + -8 | 0;
 c = k[306] | 0;
 if (b >>> 0 < c >>> 0) qa();
 d = k[a + -4 >> 2] | 0;
 a = d & 3;
 if ((a | 0) == 1) qa();
 e = d & -8;
 f = b + e | 0;
 do if (!(d & 1)) {
  g = k[b >> 2] | 0;
  if (!a) return;
  h = b + (0 - g) | 0;
  i = g + e | 0;
  if (h >>> 0 < c >>> 0) qa();
  if ((h | 0) == (k[307] | 0)) {
   j = f + 4 | 0;
   l = k[j >> 2] | 0;
   if ((l & 3 | 0) != 3) {
    m = h;
    n = i;
    break;
   }
   k[304] = i;
   k[j >> 2] = l & -2;
   k[h + 4 >> 2] = i | 1;
   k[h + i >> 2] = i;
   return;
  }
  l = g >>> 3;
  if (g >>> 0 < 256) {
   g = k[h + 8 >> 2] | 0;
   j = k[h + 12 >> 2] | 0;
   o = 1248 + (l << 1 << 2) | 0;
   if ((g | 0) != (o | 0)) {
    if (g >>> 0 < c >>> 0) qa();
    if ((k[g + 12 >> 2] | 0) != (h | 0)) qa();
   }
   if ((j | 0) == (g | 0)) {
    k[302] = k[302] & ~(1 << l);
    m = h;
    n = i;
    break;
   }
   if ((j | 0) == (o | 0)) p = j + 8 | 0; else {
    if (j >>> 0 < c >>> 0) qa();
    o = j + 8 | 0;
    if ((k[o >> 2] | 0) == (h | 0)) p = o; else qa();
   }
   k[g + 12 >> 2] = j;
   k[p >> 2] = g;
   m = h;
   n = i;
   break;
  }
  g = k[h + 24 >> 2] | 0;
  j = k[h + 12 >> 2] | 0;
  do if ((j | 0) == (h | 0)) {
   o = h + 16 | 0;
   l = o + 4 | 0;
   q = k[l >> 2] | 0;
   if (!q) {
    r = k[o >> 2] | 0;
    if (!r) {
     s = 0;
     break;
    } else {
     t = r;
     u = o;
    }
   } else {
    t = q;
    u = l;
   }
   while (1) {
    l = t + 20 | 0;
    q = k[l >> 2] | 0;
    if (q | 0) {
     t = q;
     u = l;
     continue;
    }
    l = t + 16 | 0;
    q = k[l >> 2] | 0;
    if (!q) {
     v = t;
     w = u;
     break;
    } else {
     t = q;
     u = l;
    }
   }
   if (w >>> 0 < c >>> 0) qa(); else {
    k[w >> 2] = 0;
    s = v;
    break;
   }
  } else {
   l = k[h + 8 >> 2] | 0;
   if (l >>> 0 < c >>> 0) qa();
   q = l + 12 | 0;
   if ((k[q >> 2] | 0) != (h | 0)) qa();
   o = j + 8 | 0;
   if ((k[o >> 2] | 0) == (h | 0)) {
    k[q >> 2] = j;
    k[o >> 2] = l;
    s = j;
    break;
   } else qa();
  } while (0);
  if (!g) {
   m = h;
   n = i;
  } else {
   j = k[h + 28 >> 2] | 0;
   l = 1512 + (j << 2) | 0;
   if ((h | 0) == (k[l >> 2] | 0)) {
    k[l >> 2] = s;
    if (!s) {
     k[303] = k[303] & ~(1 << j);
     m = h;
     n = i;
     break;
    }
   } else {
    if (g >>> 0 < (k[306] | 0) >>> 0) qa();
    j = g + 16 | 0;
    if ((k[j >> 2] | 0) == (h | 0)) k[j >> 2] = s; else k[g + 20 >> 2] = s;
    if (!s) {
     m = h;
     n = i;
     break;
    }
   }
   j = k[306] | 0;
   if (s >>> 0 < j >>> 0) qa();
   k[s + 24 >> 2] = g;
   l = h + 16 | 0;
   o = k[l >> 2] | 0;
   do if (o | 0) if (o >>> 0 < j >>> 0) qa(); else {
    k[s + 16 >> 2] = o;
    k[o + 24 >> 2] = s;
    break;
   } while (0);
   o = k[l + 4 >> 2] | 0;
   if (!o) {
    m = h;
    n = i;
   } else if (o >>> 0 < (k[306] | 0) >>> 0) qa(); else {
    k[s + 20 >> 2] = o;
    k[o + 24 >> 2] = s;
    m = h;
    n = i;
    break;
   }
  }
 } else {
  m = b;
  n = e;
 } while (0);
 if (m >>> 0 >= f >>> 0) qa();
 e = f + 4 | 0;
 b = k[e >> 2] | 0;
 if (!(b & 1)) qa();
 if (!(b & 2)) {
  if ((f | 0) == (k[308] | 0)) {
   s = (k[305] | 0) + n | 0;
   k[305] = s;
   k[308] = m;
   k[m + 4 >> 2] = s | 1;
   if ((m | 0) != (k[307] | 0)) return;
   k[307] = 0;
   k[304] = 0;
   return;
  }
  if ((f | 0) == (k[307] | 0)) {
   s = (k[304] | 0) + n | 0;
   k[304] = s;
   k[307] = m;
   k[m + 4 >> 2] = s | 1;
   k[m + s >> 2] = s;
   return;
  }
  s = (b & -8) + n | 0;
  c = b >>> 3;
  do if (b >>> 0 < 256) {
   v = k[f + 8 >> 2] | 0;
   w = k[f + 12 >> 2] | 0;
   u = 1248 + (c << 1 << 2) | 0;
   if ((v | 0) != (u | 0)) {
    if (v >>> 0 < (k[306] | 0) >>> 0) qa();
    if ((k[v + 12 >> 2] | 0) != (f | 0)) qa();
   }
   if ((w | 0) == (v | 0)) {
    k[302] = k[302] & ~(1 << c);
    break;
   }
   if ((w | 0) == (u | 0)) x = w + 8 | 0; else {
    if (w >>> 0 < (k[306] | 0) >>> 0) qa();
    u = w + 8 | 0;
    if ((k[u >> 2] | 0) == (f | 0)) x = u; else qa();
   }
   k[v + 12 >> 2] = w;
   k[x >> 2] = v;
  } else {
   v = k[f + 24 >> 2] | 0;
   w = k[f + 12 >> 2] | 0;
   do if ((w | 0) == (f | 0)) {
    u = f + 16 | 0;
    t = u + 4 | 0;
    p = k[t >> 2] | 0;
    if (!p) {
     a = k[u >> 2] | 0;
     if (!a) {
      y = 0;
      break;
     } else {
      z = a;
      A = u;
     }
    } else {
     z = p;
     A = t;
    }
    while (1) {
     t = z + 20 | 0;
     p = k[t >> 2] | 0;
     if (p | 0) {
      z = p;
      A = t;
      continue;
     }
     t = z + 16 | 0;
     p = k[t >> 2] | 0;
     if (!p) {
      B = z;
      C = A;
      break;
     } else {
      z = p;
      A = t;
     }
    }
    if (C >>> 0 < (k[306] | 0) >>> 0) qa(); else {
     k[C >> 2] = 0;
     y = B;
     break;
    }
   } else {
    t = k[f + 8 >> 2] | 0;
    if (t >>> 0 < (k[306] | 0) >>> 0) qa();
    p = t + 12 | 0;
    if ((k[p >> 2] | 0) != (f | 0)) qa();
    u = w + 8 | 0;
    if ((k[u >> 2] | 0) == (f | 0)) {
     k[p >> 2] = w;
     k[u >> 2] = t;
     y = w;
     break;
    } else qa();
   } while (0);
   if (v | 0) {
    w = k[f + 28 >> 2] | 0;
    i = 1512 + (w << 2) | 0;
    if ((f | 0) == (k[i >> 2] | 0)) {
     k[i >> 2] = y;
     if (!y) {
      k[303] = k[303] & ~(1 << w);
      break;
     }
    } else {
     if (v >>> 0 < (k[306] | 0) >>> 0) qa();
     w = v + 16 | 0;
     if ((k[w >> 2] | 0) == (f | 0)) k[w >> 2] = y; else k[v + 20 >> 2] = y;
     if (!y) break;
    }
    w = k[306] | 0;
    if (y >>> 0 < w >>> 0) qa();
    k[y + 24 >> 2] = v;
    i = f + 16 | 0;
    h = k[i >> 2] | 0;
    do if (h | 0) if (h >>> 0 < w >>> 0) qa(); else {
     k[y + 16 >> 2] = h;
     k[h + 24 >> 2] = y;
     break;
    } while (0);
    h = k[i + 4 >> 2] | 0;
    if (h | 0) if (h >>> 0 < (k[306] | 0) >>> 0) qa(); else {
     k[y + 20 >> 2] = h;
     k[h + 24 >> 2] = y;
     break;
    }
   }
  } while (0);
  k[m + 4 >> 2] = s | 1;
  k[m + s >> 2] = s;
  if ((m | 0) == (k[307] | 0)) {
   k[304] = s;
   return;
  } else D = s;
 } else {
  k[e >> 2] = b & -2;
  k[m + 4 >> 2] = n | 1;
  k[m + n >> 2] = n;
  D = n;
 }
 n = D >>> 3;
 if (D >>> 0 < 256) {
  b = 1248 + (n << 1 << 2) | 0;
  e = k[302] | 0;
  s = 1 << n;
  if (!(e & s)) {
   k[302] = e | s;
   E = b + 8 | 0;
   F = b;
  } else {
   s = b + 8 | 0;
   e = k[s >> 2] | 0;
   if (e >>> 0 < (k[306] | 0) >>> 0) qa(); else {
    E = s;
    F = e;
   }
  }
  k[E >> 2] = m;
  k[F + 12 >> 2] = m;
  k[m + 8 >> 2] = F;
  k[m + 12 >> 2] = b;
  return;
 }
 b = D >>> 8;
 if (!b) G = 0; else if (D >>> 0 > 16777215) G = 31; else {
  F = (b + 1048320 | 0) >>> 16 & 8;
  E = b << F;
  b = (E + 520192 | 0) >>> 16 & 4;
  e = E << b;
  E = (e + 245760 | 0) >>> 16 & 2;
  s = 14 - (b | F | E) + (e << E >>> 15) | 0;
  G = D >>> (s + 7 | 0) & 1 | s << 1;
 }
 s = 1512 + (G << 2) | 0;
 k[m + 28 >> 2] = G;
 k[m + 20 >> 2] = 0;
 k[m + 16 >> 2] = 0;
 E = k[303] | 0;
 e = 1 << G;
 do if (!(E & e)) {
  k[303] = E | e;
  k[s >> 2] = m;
  k[m + 24 >> 2] = s;
  k[m + 12 >> 2] = m;
  k[m + 8 >> 2] = m;
 } else {
  F = D << ((G | 0) == 31 ? 0 : 25 - (G >>> 1) | 0);
  b = k[s >> 2] | 0;
  while (1) {
   if ((k[b + 4 >> 2] & -8 | 0) == (D | 0)) {
    H = b;
    I = 130;
    break;
   }
   n = b + 16 + (F >>> 31 << 2) | 0;
   y = k[n >> 2] | 0;
   if (!y) {
    J = n;
    K = b;
    I = 127;
    break;
   } else {
    F = F << 1;
    b = y;
   }
  }
  if ((I | 0) == 127) if (J >>> 0 < (k[306] | 0) >>> 0) qa(); else {
   k[J >> 2] = m;
   k[m + 24 >> 2] = K;
   k[m + 12 >> 2] = m;
   k[m + 8 >> 2] = m;
   break;
  } else if ((I | 0) == 130) {
   b = H + 8 | 0;
   F = k[b >> 2] | 0;
   i = k[306] | 0;
   if (F >>> 0 >= i >>> 0 & H >>> 0 >= i >>> 0) {
    k[F + 12 >> 2] = m;
    k[b >> 2] = m;
    k[m + 8 >> 2] = F;
    k[m + 12 >> 2] = H;
    k[m + 24 >> 2] = 0;
    break;
   } else qa();
  }
 } while (0);
 m = (k[310] | 0) + -1 | 0;
 k[310] = m;
 if (!m) L = 1664; else return;
 while (1) {
  m = k[L >> 2] | 0;
  if (!m) break; else L = m + 8 | 0;
 }
 k[310] = -1;
 return;
}

function Ra(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0, e = 0, f = 0, g = 0, h = 0, i = 0, j = 0, l = 0, m = 0, n = 0, o = 0, p = 0, q = 0, s = 0, t = 0, u = 0, v = 0, w = 0, x = 0, y = 0, z = 0;
 d = r;
 r = r + 48 | 0;
 e = d + 16 | 0;
 f = d;
 g = d + 32 | 0;
 h = a + 28 | 0;
 i = k[h >> 2] | 0;
 k[g >> 2] = i;
 j = a + 20 | 0;
 l = (k[j >> 2] | 0) - i | 0;
 k[g + 4 >> 2] = l;
 k[g + 8 >> 2] = b;
 k[g + 12 >> 2] = c;
 b = a + 60 | 0;
 i = a + 44 | 0;
 m = g;
 g = 2;
 n = l + c | 0;
 while (1) {
  if (!(k[290] | 0)) {
   k[e >> 2] = k[b >> 2];
   k[e + 4 >> 2] = m;
   k[e + 8 >> 2] = g;
   o = Pa(ya(146, e | 0) | 0) | 0;
  } else {
   ra(1, a | 0);
   k[f >> 2] = k[b >> 2];
   k[f + 4 >> 2] = m;
   k[f + 8 >> 2] = g;
   l = Pa(ya(146, f | 0) | 0) | 0;
   oa(0);
   o = l;
  }
  if ((n | 0) == (o | 0)) {
   p = 6;
   break;
  }
  if ((o | 0) < 0) {
   q = m;
   s = g;
   p = 8;
   break;
  }
  l = n - o | 0;
  t = k[m + 4 >> 2] | 0;
  if (o >>> 0 > t >>> 0) {
   u = k[i >> 2] | 0;
   k[h >> 2] = u;
   k[j >> 2] = u;
   v = k[m + 12 >> 2] | 0;
   w = o - t | 0;
   x = m + 8 | 0;
   y = g + -1 | 0;
  } else if ((g | 0) == 2) {
   k[h >> 2] = (k[h >> 2] | 0) + o;
   v = t;
   w = o;
   x = m;
   y = 2;
  } else {
   v = t;
   w = o;
   x = m;
   y = g;
  }
  k[x >> 2] = (k[x >> 2] | 0) + w;
  k[x + 4 >> 2] = v - w;
  m = x;
  g = y;
  n = l;
 }
 if ((p | 0) == 6) {
  n = k[i >> 2] | 0;
  k[a + 16 >> 2] = n + (k[a + 48 >> 2] | 0);
  i = n;
  k[h >> 2] = i;
  k[j >> 2] = i;
  z = c;
 } else if ((p | 0) == 8) {
  k[a + 16 >> 2] = 0;
  k[h >> 2] = 0;
  k[j >> 2] = 0;
  k[a >> 2] = k[a >> 2] | 32;
  if ((s | 0) == 2) z = 0; else z = c - (k[q + 4 >> 2] | 0) | 0;
 }
 r = d;
 return z | 0;
}

function Wa(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0, e = 0, f = 0, g = 0, h = 0, j = 0, l = 0, m = 0, n = 0, o = 0, p = 0, q = 0;
 d = c + 16 | 0;
 e = k[d >> 2] | 0;
 if (!e) if (!(Xa(c) | 0)) {
  f = k[d >> 2] | 0;
  g = 5;
 } else h = 0; else {
  f = e;
  g = 5;
 }
 a : do if ((g | 0) == 5) {
  e = c + 20 | 0;
  d = k[e >> 2] | 0;
  j = d;
  if ((f - d | 0) >>> 0 < b >>> 0) {
   h = Ca[k[c + 36 >> 2] & 3](c, a, b) | 0;
   break;
  }
  b : do if ((i[c + 75 >> 0] | 0) > -1) {
   d = b;
   while (1) {
    if (!d) {
     l = b;
     m = a;
     n = j;
     o = 0;
     break b;
    }
    p = d + -1 | 0;
    if ((i[a + p >> 0] | 0) == 10) {
     q = d;
     break;
    } else d = p;
   }
   if ((Ca[k[c + 36 >> 2] & 3](c, a, q) | 0) >>> 0 < q >>> 0) {
    h = q;
    break a;
   }
   l = b - q | 0;
   m = a + q | 0;
   n = k[e >> 2] | 0;
   o = q;
  } else {
   l = b;
   m = a;
   n = j;
   o = 0;
  } while (0);
  jb(n | 0, m | 0, l | 0) | 0;
  k[e >> 2] = (k[e >> 2] | 0) + l;
  h = o + l | 0;
 } while (0);
 return h | 0;
}

function Za(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0, j = 0, l = 0, m = 0;
 b = a;
 a : do if (!(b & 3)) {
  c = a;
  d = 4;
 } else {
  e = a;
  f = b;
  while (1) {
   if (!(i[e >> 0] | 0)) {
    g = f;
    break a;
   }
   h = e + 1 | 0;
   f = h;
   if (!(f & 3)) {
    c = h;
    d = 4;
    break;
   } else e = h;
  }
 } while (0);
 if ((d | 0) == 4) {
  d = c;
  while (1) {
   c = k[d >> 2] | 0;
   if (!((c & -2139062144 ^ -2139062144) & c + -16843009)) d = d + 4 | 0; else {
    j = c;
    l = d;
    break;
   }
  }
  if (!((j & 255) << 24 >> 24)) m = l; else {
   j = l;
   while (1) {
    l = j + 1 | 0;
    if (!(i[l >> 0] | 0)) {
     m = l;
     break;
    } else j = l;
   }
  }
  g = m;
 }
 return g - b | 0;
}

function _a(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
 do if (!a) {
  if (!(k[285] | 0)) b = 0; else b = _a(k[285] | 0) | 0;
  pa(1188);
  c = k[296] | 0;
  if (!c) d = b; else {
   e = c;
   c = b;
   while (1) {
    if ((k[e + 76 >> 2] | 0) > -1) f = Ya(e) | 0; else f = 0;
    if ((k[e + 20 >> 2] | 0) >>> 0 > (k[e + 28 >> 2] | 0) >>> 0) g = $a(e) | 0 | c; else g = c;
    if (f | 0) Ta(e);
    e = k[e + 56 >> 2] | 0;
    if (!e) {
     d = g;
     break;
    } else c = g;
   }
  }
  xa(1188);
  h = d;
 } else {
  if ((k[a + 76 >> 2] | 0) <= -1) {
   h = $a(a) | 0;
   break;
  }
  c = (Ya(a) | 0) == 0;
  e = $a(a) | 0;
  if (c) h = e; else {
   Ta(a);
   h = e;
  }
 } while (0);
 return h | 0;
}

function ab(a, b) {
 a = a | 0;
 b = b | 0;
 var c = 0, d = 0, e = 0, f = 0, g = 0, h = 0, j = 0, m = 0, n = 0;
 c = r;
 r = r + 16 | 0;
 d = c;
 e = b & 255;
 i[d >> 0] = e;
 f = a + 16 | 0;
 g = k[f >> 2] | 0;
 if (!g) if (!(Xa(a) | 0)) {
  h = k[f >> 2] | 0;
  j = 4;
 } else m = -1; else {
  h = g;
  j = 4;
 }
 do if ((j | 0) == 4) {
  g = a + 20 | 0;
  f = k[g >> 2] | 0;
  if (f >>> 0 < h >>> 0) {
   n = b & 255;
   if ((n | 0) != (i[a + 75 >> 0] | 0)) {
    k[g >> 2] = f + 1;
    i[f >> 0] = e;
    m = n;
    break;
   }
  }
  if ((Ca[k[a + 36 >> 2] & 3](a, d, 1) | 0) == 1) m = l[d >> 0] | 0; else m = -1;
 } while (0);
 r = c;
 return m | 0;
}

function $a(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
 b = a + 20 | 0;
 c = a + 28 | 0;
 if ((k[b >> 2] | 0) >>> 0 > (k[c >> 2] | 0) >>> 0) {
  Ca[k[a + 36 >> 2] & 3](a, 0, 0) | 0;
  if (!(k[b >> 2] | 0)) d = -1; else e = 3;
 } else e = 3;
 if ((e | 0) == 3) {
  e = a + 4 | 0;
  f = k[e >> 2] | 0;
  g = a + 8 | 0;
  h = k[g >> 2] | 0;
  if (f >>> 0 < h >>> 0) Ca[k[a + 40 >> 2] & 3](a, f - h | 0, 1) | 0;
  k[a + 16 >> 2] = 0;
  k[c >> 2] = 0;
  k[b >> 2] = 0;
  k[g >> 2] = 0;
  k[e >> 2] = 0;
  d = 0;
 }
 return d | 0;
}

function jb(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0;
 if ((c | 0) >= 4096) return va(a | 0, b | 0, c | 0) | 0;
 d = a | 0;
 if ((a & 3) == (b & 3)) {
  while (a & 3) {
   if (!c) return d | 0;
   i[a >> 0] = i[b >> 0] | 0;
   a = a + 1 | 0;
   b = b + 1 | 0;
   c = c - 1 | 0;
  }
  while ((c | 0) >= 4) {
   k[a >> 2] = k[b >> 2];
   a = a + 4 | 0;
   b = b + 4 | 0;
   c = c - 4 | 0;
  }
 }
 while ((c | 0) > 0) {
  i[a >> 0] = i[b >> 0] | 0;
  a = a + 1 | 0;
  b = b + 1 | 0;
  c = c - 1 | 0;
 }
 return d | 0;
}

function gb() {}
function hb(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0, e = 0, f = 0, g = 0;
 d = a + c | 0;
 if ((c | 0) >= 20) {
  b = b & 255;
  e = a & 3;
  f = b | b << 8 | b << 16 | b << 24;
  g = d & ~3;
  if (e) {
   e = a + 4 - e | 0;
   while ((a | 0) < (e | 0)) {
    i[a >> 0] = b;
    a = a + 1 | 0;
   }
  }
  while ((a | 0) < (g | 0)) {
   k[a >> 2] = f;
   a = a + 4 | 0;
  }
 }
 while ((a | 0) < (d | 0)) {
  i[a >> 0] = b;
  a = a + 1 | 0;
 }
 return a - c | 0;
}

function db(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0, e = 0, f = 0;
 b = k[256] | 0;
 if ((k[b + 76 >> 2] | 0) > -1) c = Ya(b) | 0; else c = 0;
 do if ((cb(a, b) | 0) < 0) d = 1; else {
  if ((i[b + 75 >> 0] | 0) != 10) {
   e = b + 20 | 0;
   f = k[e >> 2] | 0;
   if (f >>> 0 < (k[b + 16 >> 2] | 0) >>> 0) {
    k[e >> 2] = f + 1;
    i[f >> 0] = 10;
    d = 0;
    break;
   }
  }
  d = (ab(b, 10) | 0) < 0;
 } while (0);
 if (c | 0) Ta(b);
 return d << 31 >> 31 | 0;
}

function Xa(a) {
 a = a | 0;
 var b = 0, c = 0, d = 0;
 b = a + 74 | 0;
 c = i[b >> 0] | 0;
 i[b >> 0] = c + 255 | c;
 c = k[a >> 2] | 0;
 if (!(c & 8)) {
  k[a + 8 >> 2] = 0;
  k[a + 4 >> 2] = 0;
  b = k[a + 44 >> 2] | 0;
  k[a + 28 >> 2] = b;
  k[a + 20 >> 2] = b;
  k[a + 16 >> 2] = b + (k[a + 48 >> 2] | 0);
  d = 0;
 } else {
  k[a >> 2] = c | 32;
  d = -1;
 }
 return d | 0;
}

function bb(a, b, c, d) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 d = d | 0;
 var e = 0, f = 0, g = 0, h = 0, i = 0;
 e = ga(c, b) | 0;
 if ((k[d + 76 >> 2] | 0) > -1) {
  f = (Ya(d) | 0) == 0;
  g = Wa(a, e, d) | 0;
  if (f) h = g; else {
   Ta(d);
   h = g;
  }
 } else h = Wa(a, e, d) | 0;
 if ((h | 0) == (e | 0)) i = c; else i = (h >>> 0) / (b >>> 0) | 0;
 return i | 0;
}

function Ua(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0, e = 0, f = 0, g = 0;
 d = r;
 r = r + 32 | 0;
 e = d;
 f = d + 20 | 0;
 k[e >> 2] = k[a + 60 >> 2];
 k[e + 4 >> 2] = 0;
 k[e + 8 >> 2] = b;
 k[e + 12 >> 2] = f;
 k[e + 16 >> 2] = c;
 if ((Pa(ua(140, e | 0) | 0) | 0) < 0) {
  k[f >> 2] = -1;
  g = -1;
 } else g = k[f >> 2] | 0;
 r = d;
 return g | 0;
}

function Va(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 var d = 0, e = 0;
 d = r;
 r = r + 80 | 0;
 e = d;
 k[a + 36 >> 2] = 3;
 if (!(k[a >> 2] & 64)) {
  k[e >> 2] = k[a + 60 >> 2];
  k[e + 4 >> 2] = 21505;
  k[e + 8 >> 2] = d + 12;
  if (wa(54, e | 0) | 0) i[a + 75 >> 0] = -1;
 }
 e = Ra(a, b, c) | 0;
 r = d;
 return e | 0;
}

function Ka(a) {
 a = a | 0;
 i[t >> 0] = i[a >> 0];
 i[t + 1 >> 0] = i[a + 1 >> 0];
 i[t + 2 >> 0] = i[a + 2 >> 0];
 i[t + 3 >> 0] = i[a + 3 >> 0];
 i[t + 4 >> 0] = i[a + 4 >> 0];
 i[t + 5 >> 0] = i[a + 5 >> 0];
 i[t + 6 >> 0] = i[a + 6 >> 0];
 i[t + 7 >> 0] = i[a + 7 >> 0];
}

function Oa(a) {
 a = a | 0;
 var b = 0, c = 0;
 b = r;
 r = r + 16 | 0;
 c = b;
 k[c >> 2] = k[a + 60 >> 2];
 a = Pa(sa(6, c | 0) | 0) | 0;
 r = b;
 return a | 0;
}

function Pa(a) {
 a = a | 0;
 var b = 0, c = 0;
 if (a >>> 0 > 4294963200) {
  b = Qa() | 0;
  k[b >> 2] = 0 - a;
  c = -1;
 } else c = a;
 return c | 0;
}

function Ja(a) {
 a = a | 0;
 i[t >> 0] = i[a >> 0];
 i[t + 1 >> 0] = i[a + 1 >> 0];
 i[t + 2 >> 0] = i[a + 2 >> 0];
 i[t + 3 >> 0] = i[a + 3 >> 0];
}

function Qa() {
 var a = 0, b = 0;
 if (!(k[290] | 0)) a = 1204; else {
  b = (ib() | 0) + 64 | 0;
  a = k[b >> 2] | 0;
 }
 return a | 0;
}

function lb(a, b, c, d) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 d = d | 0;
 return Ca[a & 3](b | 0, c | 0, d | 0) | 0;
}
function Ea(a) {
 a = a | 0;
 var b = 0;
 b = r;
 r = r + a | 0;
 r = r + 15 & -16;
 return b | 0;
}

function cb(a, b) {
 a = a | 0;
 b = b | 0;
 return (bb(a, Za(a) | 0, 1, b) | 0) + -1 | 0;
}

function ob(a, b, c) {
 a = a | 0;
 b = b | 0;
 c = c | 0;
 ja(1);
 return 0;
}

function Ia(a, b) {
 a = a | 0;
 b = b | 0;
 if (!v) {
  v = a;
  w = b;
 }
}

function kb(a, b) {
 a = a | 0;
 b = b | 0;
 return Ba[a & 1](b | 0) | 0;
}

function Sa(a) {
 a = a | 0;
 if (!(k[a + 68 >> 2] | 0)) Ta(a);
 return;
}

function mb(a, b) {
 a = a | 0;
 b = b | 0;
 Da[a & 1](b | 0);
}

function Ha(a, b) {
 a = a | 0;
 b = b | 0;
 r = a;
 s = b;
}

function nb(a) {
 a = a | 0;
 ja(0);
 return 0;
}

function Na() {
 db(1144) | 0;
 return 0;
}

function Ya(a) {
 a = a | 0;
 return 0;
}

function Ta(a) {
 a = a | 0;
 return;
}

function pb(a) {
 a = a | 0;
 ja(2);
}

function La(a) {
 a = a | 0;
 K = a;
}

function Ga(a) {
 a = a | 0;
 r = a;
}

function Ma() {
 return K | 0;
}

function Fa() {
 return r | 0;
}

function ib() {
 return 0;
}

// EMSCRIPTEN_END_FUNCS

 var Ba = [ nb, Oa ];
 var Ca = [ ob, Va, Ua, Ra ];
 var Da = [ pb, Sa ];
 return {
  _free: fb,
  _main: Na,
  _pthread_self: ib,
  _memset: hb,
  _malloc: eb,
  _memcpy: jb,
  _fflush: _a,
  ___errno_location: Qa,
  runPostSets: gb,
  _emscripten_replace_memory: Aa,
  stackAlloc: Ea,
  stackSave: Fa,
  stackRestore: Ga,
  establishStackSpace: Ha,
  setThrew: Ia,
  setTempRet0: La,
  getTempRet0: Ma,
  dynCall_ii: kb,
  dynCall_iiii: lb,
  dynCall_vi: mb
 };
})


;