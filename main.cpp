#include <systemc>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

using namespace sc_core;
using namespace std;


class MODULE_B : public sc_module {
    public:
        MODULE_B(sc_module_name name, int argc, char* argv[])
            :sc_module(name)
        {
            param = (char**)malloc(sizeof(char*) * (argc));
            param[0] = (char*)malloc(sizeof(char) * strlen(path));
            strcpy(param[0], path);
            for(int i = 1; i < argc; i++){
                param[i] = (char*)malloc(sizeof(char) * strlen(argv[i])+1);
                strcpy(param[i], argv[i]);
                strcat(param[i], "\0");
            }
            // pipe(pipe1);
            SC_THREAD(onnsim);
        }

        void onnsim(){
            // int fd;
            // fd = open("try.txt",O_RDWR|O_CREAT);
            // dup2(fd, 1);
            execvp(param[0], param);
        }

        SC_HAS_PROCESS(MODULE_B);
    private:
        const char path[256] = "/umbrella/skymizer-master-toplevel/bin/precision_simulator.cortex_m";
        char** param;
        int pipe1[2];
};


int sc_main(int argc, char* argv[]){
    MODULE_B module_b("mod_b", argc, argv);
    sc_start();
    return 0;
}
