// Jacob Laney 2016
//
// Provides an application that compares to strings
// I wrote this program in order to practice combining
// NASM x86 with C  

#include <stdio.h>
#include "jpl_string.h"

// compares to strings and then prints their relationship
void test_jpl_strcmp(char * str1, char * str2) {

    int x = jpl_strcmp(str1, str2);

    printf("\n");

    printf("\"%s\" ", str1);
    if (x > 0) {
        printf("> ");
    }
    else if (x < 0) {
        printf("< ");
    }
    else {
        printf("== ");
    }
    printf("\"%s\" ", str2);

    printf("\n\n");

    return;
}

int main(int argc, char ** argv) {
    // make sure even number of arguments
    if (argc < 3 || (argc - 1) % 2 != 0) {
        puts("! USAGE: <string 1>  <string 2>");
        return 0;
    }

    // run comparisons
    int compares = argc - 1 / 2;
    for (int i = 1; i < compares; i += 2) {
        test_jpl_strcmp(argv[i], argv[i + 1]);
    }
    return 0;
}
