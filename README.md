# VSOS
## Table of contents
- [VSOS](#vsos)
  - [Future plans](#Future-plans)
  - [How did I implement it, step by step](#Implementation)

## Future plans
- Deploy on browser using https://copy.sh/v86/

## Implementation
### Step 1: Setting up the development environment
- Ubuntu 22.04 LTS, I'm running it on WSL
- NASM 
  - If you are running Ubuntu, you can install it by running `sudo apt install nasm` or you can download it from [here](https://www.nasm.us/) and compile it yourself.
- Bochs
  - If you are running Ubuntu, you can install it by running `sudo apt install bochs-x` or you can download it from [here](https://bochs.sourceforge.io/) and compile it yourself.
### Step 2: Writing the bootloader
- If you are familiar with any instruction set, NASM x86 should be easy to understand. [Here](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html) is a good reference I found.
- Resources on FAT16 specification can be found [here](http://www.maverick-os.dk/FileSystemFormats/FAT16_FileSystem.html).
- A good YT video for writing an x86 bootloader from scratch can be found [here](https://www.youtube.com/watch?v=xFrMXzKCXIc).
- After finishing the assembly code, you can compile it by running `nasm -f bin boot.asm -o boot.bin` under the same directory as the `boot.asm` file.
### Step 3: Create a disk image and write the bootloader to it
- You can create a disk image by running `bximage -q -mode=create -hd=16 -sectsize=512 -imgmode=flat master.img`. Then run `dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc` to write the bootloader to the disk image.



