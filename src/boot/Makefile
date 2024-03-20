
all: nasm image

clean:
	rm -rf *.bin *.img

nasm: boot.asm
	nasm -f bin boot.asm -o boot.bin

image:
	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img
	dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc

