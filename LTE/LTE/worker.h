
#pragma once

#include <boost/thread.hpp>
#include <boost/smart_ptr.hpp>
using namespace boost;


class Worker{
 public:
  typedef void(Functor)();
  
  Worker(){}
  virtual ~Worker(){}
  
  void run( Functor *func){
    unit.reset(new thread(callback, func));
  }

  static void callback( Functor* func){
    while(true){
      func();
    }
  }
 private:
  shared_ptr<thread>    unit;
};
