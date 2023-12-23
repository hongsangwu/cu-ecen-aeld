#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>

int main(int argc, char *argv[]) {

    openlog(NULL, 0, LOG_USER);
    if (argc != 3) {
        fprintf(stderr, "Usage: writer <file> <string>\n");
        syslog(LOG_ERR, "Usage: writer <file> <string>\n");
        closelog();
        exit(EXIT_FAILURE);
    }


    const char *file = argv[1];
    const char *string = argv[2];


    FILE *fp = fopen(file, "w");
    if (fp == NULL) {
        syslog(LOG_ERR, "Failed to open file: %s", file);
        closelog();
        exit(EXIT_FAILURE);
    }

    fprintf(fp, "%s", string);
    fclose(fp);

    syslog(LOG_DEBUG, "Writing %s to %s", string, file);

    closelog();

    return EXIT_SUCCESS;

}
