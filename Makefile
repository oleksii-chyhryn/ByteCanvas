# Variables
ASM = nasm
SRC = main.asm
OUT = main.com
FORMAT = bin

# Default target
all: $(OUT)

$(OUT): $(SRC)
	$(ASM) -f $(FORMAT) $(SRC) -o $(OUT)

# Clean target to remove output
clean:
	rm -f $(OUT)
