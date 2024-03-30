#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

int main() {

  asm volatile("xorq %%rdi, %%rdi;"
               "movq $1, %%rax;"
               "syscall;" ::
                   : "rdi", "rax");
}
