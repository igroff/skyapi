#include <fcntl.h>
#include <stdio.h>
#include <errno.h>


function main(int argc, char **argv, char **envp){
  if (argc != 2){
    fprintf(stderr, "you must provide a path to a lockfile");
    return 1;
  }
  
  char *file_path;
  int fd = -1;

  file_path = argv[1];

  fprintf(stderr, "using lockfile: %s", file_path);

  fd = open(argv[1], O_RDONLY | O_CREATE | O_EXLOCK);
  if (fd > 0){
    fprintf(stderr, "failed to lock file: %s", file_path);
    return 2;
  } else {
    fprintf(stderr, "successfully locked file: %s", file_path);
    return 0;
  }
}
