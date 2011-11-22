
#pragma once

#include <stdio.h>
#include <boost/thread.hpp>
using namespace boost;

template <typename T>class Job{
 public:
  Job(){}
  virtual ~Job(){}

  Job& operator=(T* new_data){
#ifdef DEBUG
    if(data){
      printf("job overflow!\n");
    }
#endif

    unique_lock<mutex> lock(mut);
    data=&new_data;
    cond.notify_one();
    
    return *this;
  }

  Job& operator=(T& new_data){
    this->operator=(&new_data);
  }
  
  operator T& (){
    unique_lock<mutex> lock(mut);
    while(data==0){
      cond.wait(lock);
    }
    T* ret=data;
    data=0;
    return *ret;
  }
  
 private:
  T*                    data;
  mutex                 mut;
  condition_variable    cond;
};

