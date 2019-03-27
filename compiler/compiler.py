""" Compiler for the assembler code, for the microprocessor. """

import sys

codeDict = {
    'addwf' : '100000',
    'addlw' : '110000',
    'incf'  : '100000100',
    'incfsz': '100000010',
    'infsnz': '100000001',
    'subwf' : '100001',
    'sublf' : '110000',
    'decf'  : '100000100',
    'decfsz': '100000010',
    'dcfsnz': '100000001',
    'mulwf' : '100010',
    'mullf' : '110010',
    'andwf' : '100011',
    'andlf' : '110011',
    'iorwf' : '100100',
    'iorlf' : '110100',
    'xorwf' : '100101',
    'xorlf' : '110101',
    'negf'  : '100110',
    'comf'  : '100111',
    'cpfseq': '101000100',
    'cpfsgt': '101000010',
    'cpfslt': '101000001',
    'tstfsz': '101001',
    'rlncf' : '101010',
    'rrncf' : '101011',
    'clrf'  : '101100',
    'setf'  : '101101',
    'swapf' : '101110',
    'movf'  : '101111011',
    'movwf' : '101111010',
    'movlf' : '101111001',
    'bcf'   : '010001',
    'bsf'   : '010010',
    'btfsc' : '010011',
    'btfss' : '010100',
    'btg'   : '010101',
    'call'  : '000010',
    'goto'  : '000100',
    'nop'   : '000110',
    'reset' : '001000',
    'retlw' : '001010',
    'return': '001100'
}

def switch(x):
    return codeDict.get(x, "000000")

binaryCode = []
with open("codigo.asm", "r") as file:
    for line in file:
        sLine = line.split()
        sLine[0] = sLine[0].lower()
        opcode = ''
        opcode = switch(sLine[0])
        nbit = ''
        if (len(opcode) > 6):
            if (opcode == "101111011"):
                opcode[7] = sLine[2]
            nbit = sLine[1][1:8]
        else:
            if (opcode == "001100" or opcode == "000110" or opcode == "001000"):
                nbit = "00000000000"
            elif (len(sLine) == 3):
                if (len(sLine[2]) == 3):
                    nbit = sLine[2] + sLine[1][1:8]
                else:
                    nbit = sLine[2] + '0' + sLine[1]
            else:
                nbit = '00' + sLine[1]
        opcode = opcode + nbit
        binaryCode.append(opcode)

with open("rom.vhd", "w") as rom:
    rom.write("library ieee;\n")
    rom.write("use ieee.std_logic_1164.all;\n")
    rom.write("use ieee.numeric_std.all;\n")
    rom.write("\n")
    rom.write("entity ROM is\n")
    rom.write("\tgeneric(\n")
    rom.write("\t\tnbitsaddr : integer := 9;\n")
    rom.write("\t\tnbitsdata : integer := 17\n")
    rom.write("\t\t);\n")
    rom.write("\tport(\n")
    rom.write("\t\taddr : in std_logic_vector(nbitsaddr - 1 downto 0);\n")
    rom.write("\t\tdata : out std_logic_vector(nbitsdata - 1 downto 0)\n")
    rom.write("\t\t);\n")
    rom.write("\tend ROM;\n")
    rom.write("\n")
    rom.write("architecture LUT of ROM is\n")
    rom.write("\ttype mem is array(0 to 2**nbitsaddr - 1) of std_logic_vector(nbitsdata - 1 downto 0);\n")
    rom.write("\tsignal rom1 : mem := (\n")
    codeLen = len(binaryCode)
    rstr = "\t\t{0} => \"{1}\"".format(0, binaryCode[0])
    rom.write(rstr)
    for i in range(1, codeLen):
        rstr = ",\n\t\t{0} => \"{1}\"".format(i, binaryCode[i])
        rom.write(rstr)
    print(codeLen)
    if codeLen < 512:
        for i in range(codeLen, 512):
            rstr = ",\n\t\t{0} => \"{1}\"".format(i, "00000000000000000")
            rom.write(rstr)
    rom.write("\t\t);\n")
    rom.write("begin\n")
    rom.write("\tprocess(addr)\n")
    rom.write("\tbegin\n")
    rom.write("\t\tdata <= rom1(to_integer(unsigned(addr)));\n")
    rom.write("\tend process;\n")
    rom.write("end LUT;\n")

