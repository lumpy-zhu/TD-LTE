#pragma once

#include <unistd.h>
#include <map>
#include <string>

class Options{
 public:

  Options(const char* opt):
      mode(opt)
  {}
  
  void parse(int argc, char* const argv[]){
    int ret;
    while ((ret=getopt(argc, argv, mode))!=-1){
      switch(ret){
        case -1:
          break;
          
        case '?':
          break;
          
        case ':':
          break;

        default:
          if(optarg)
            options[ret] = optarg;
          else
            options[ret] = "";
          break;
      }
    }
  }

  bool has_key(char id){
    return options.find(id)!=options.end();
  }
  
  std::string& operator[](char id){
    return options[id];
  }
  
 private:
  const char*                   mode;
  std::map<char,std::string>    options;
};
