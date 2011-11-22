#pragma once

#define __align__(n)	__attribute__((aligned(n)))
template <typename T> class __align__(sizeof(T)*2) complex{
public:
  T	r;
  T	i;
public:
  complex(T nr=0, T ni=0)
      :r(nr), i(ni)
  {}

  complex& operator=(const complex& c){
    r=c.r;
    i=c.i;
    return *this;
  }

  complex& operator=(T t){
    r=t;
    t=0;
    return *this;
  }

  complex operator-() const {
    return complex(-r,-i);
  }
  
  // complex [+,-,*,/]= type
  template <typename E>complex& operator +=(E t){
    r+=t;
    return *this;
  }
  
  template <typename E>complex& operator -=(E t){
    r-=t;
    return *this;
  }
  
  template <typename E>complex& operator *=(E t){
    r*=t;
    i*=t;
    return *this;
  }
  
  template <typename E>complex& operator /=(E t){
    r/=t;
    i/=t;
    return *this;
  }

  // complex [+,-,*,/]= complex
  complex& operator+=(complex z){
    r+=z.r;
    i+=z.i;
    return *this;
  }
  complex& operator-=(complex z){
    r-=z.r;
    i-=z.i;
    return *this;
  }
  complex& operator*=(complex z){
    const T _r = r*z.r - i*z.i;
    i = r*z.i + i*z.r;
    r = _r;
    return *this;
  }
  complex& operator/=(complex z){
    const T _r = r*z.r + i*z.i;
    const T _n = z.r*z.r + z.i*z.i;
    i = (i*z.r - r*z.i)/_n;
    r = _r / _n;
    return *this;
  }
};

template <typename T, typename E>inline complex<T> operator+(const complex<T> &x, const E &y){
  complex<T> z=x;
  z+=y;
  return z;
}
template <typename T, typename E>inline complex<T> operator-(const complex<T> &x, const E &y){
  complex<T> z=x;
  z-=y;
  return z;
}
template <typename T, typename E>inline complex<T> operator*(const complex<T> &x, const E &y){
  complex<T> z=x;
  z*=y;
  return z;
}
template <typename T, typename E>inline complex<T> operator/(const complex<T> &x, const E &y){
  complex<T> z=x;
  z/=y;
  return z;
}


template <typename T, typename E>inline complex<T> operator+(const E &x, const complex<T> &y){
  complex<T> z=y;
  y+=x;
  return z;
}

template <typename T, typename E>inline complex<T> operator-(const E &x, const complex<T> &y){
  complex<T> z(x-y.r, -y.i);
  return z;
}

template <typename T, typename E>inline complex<T> operator*(const E &x, const complex<T> &y){
  complex<T> z=y;
  z*=x;
  return z;
}

template <typename T, typename E>inline complex<T> operator/(const E &x, const complex<T> &y){
  const T	_n = y.r*y.r + y.i*y.i;
  complex<T> z(x*y.r/_n, -x*y.i/_n);
  return z;
}



template <typename T>inline complex<T> operator+(const complex<T> &x, const complex<T> &y){
  complex<T> z=x;
  z+=y;
  return z;
}
template <typename T>inline complex<T> operator-(const complex<T> &x, const complex<T> &y){
  complex<T> z=x;
  z-=y;
  return z;
}
template <typename T>inline complex<T> operator*(const complex<T> &x, const complex<T> &y){
  complex<T> z=x;
  z*=y;
  return z;
}
template <typename T>inline complex<T> operator/(const complex<T> &x, const complex<T> &y){
  complex<T> z=x;
  z/=y;
  return z;
}

typedef complex<int>	cint;
typedef complex<float>	cfloat;

