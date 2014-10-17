## travis-coredump

On travis you might see a cryptic error like:

    /home/travis/build.sh: line 41:  2300 Segmentation fault

Or:

    *** glibc detected *** ./test: double free or corruption (top): ***

Yay, your app segfaulted or hit a double-free. And you can't reproduce locally. And running your program in the gdb interpreter won't work on a remote machine. What now?

You have come to the right place.

This repo contains a demo of:

 - How to enable coredumps for linux (`ulimit -c unlimited`)
 - A c++ program that will simulate a crash
 - The `gdb` incantation to make the crash backtrace visible in the travis logs

See `.travis.yml` for detailed instructions you can copy into your own `.travis.yml`. See sample logs at <https://travis-ci.org/springmeyer/travis-coredump/>. This repo is configured so that with two runs in the travis matix:

  - One run tests a program that does not crash and therefore the build should cleanly pass
  - The other run tests a program that does crash, reports the backtrace, then exits the run with the same errorcode as generated by the crash.

The backtrace should reveal to you the file and line number of the bug:

```
Core was generated by `./test'.
Program terminated with signal 11, Segmentation fault.
#0  0x00007f438532302c in free () from /lib/x86_64-linux-gnu/libc.so.6
Thread 1 (LWP 2611):
#0  0x00007f438532302c in free () from /lib/x86_64-linux-gnu/libc.so.6
#1  0x00000000004005d6 in main () at might_crash.cpp:6
```

### Other platforms

If you are on OS X, you don't need to worry about these steps, just look inside:

    ~/Library/Logs/DiagnosticReports/

And a backtrace should be present for any program that just crashed.

If you are on Windows, let me know if you have tips on generating backtraces for crashes on the command line.