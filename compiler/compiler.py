""" Compiler for the assembler code, for the microprocessor. """

import sys

codeDict = {
    'addwf' : '100000',
    'addlw' : '110000',
    'incf'  : '100000101',
    'incfsz': '100000110',
    'infsnz': '100000111',
    'subwf' : '100001',
    'sublw' : '110001',
    'decf'  : '100001101',
    'decfsz': '100001110',
    'dcfsnz': '100001111',
    'mulwf' : '100010',
    'mullw' : '110010',
    'andwf' : '100011',
    'andlw' : '110011',
    'iorwf' : '100100',
    'iorlw' : '110100',
    'xorwf' : '100101',
    'xorlw' : '110101',
    'negf'  : '100110',
    'comf'  : '100111',
    'cpfseq': '101000001',
    'cpfsgt': '101000010',
    'cpfslt': '101000011',
    'tstfsz': '101001',
    'rlncf' : '101010',
    'rrncf' : '101011',
    'clrf'  : '101100',
    'setf'  : '101101',
    'swapf' : '101110',
    'movf'  : '101111111',
    'movwf' : '101111010',
    'movlw' : '111111001',
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
with open("contador.asm", "r") as file:
    i = 0
    for line in file:
        i += 1
        sLine = line.split()
        print(sLine)
        sLine[0] = sLine[0].lower()
        opcode = ''
        opcode = switch(sLine[0])
        nbit = ''
        if (len(opcode) > 6):
            if (opcode == "101111011"): #movwf
                s = list(opcode)
                s[7] = sLine[2]
                opcode[7] = "".join(s)
            nbit = sLine[1][1:]
        else:
            if (opcode == "001100" or opcode == "000110" or opcode == "001000"):	# GOTO, RESET, NOP
                nbit = "00000000000"
            elif (len(sLine) == 3):
                if (len(sLine[2]) == 3):
                    nbit = sLine[2] + sLine[1][1:]
                else:
                    nbit = sLine[2] + '0' + sLine[1]
            else:
								# Store literals on w
                if (opcode[0] == '1' and opcode[1] == '1'):
                    nbit = '00' + sLine[1]
                else:
                    nbit = '10' + sLine[1]
        opcode = opcode + nbit
        assert len(opcode) == 17, "Incorrect length: {0}, at line: {1}".format(opcode, i)
        binaryCode.append(opcode)

with open("rom.vhd", "w") as rom:
    rom.write("library ieee;\n")
    rom.write("use ieee.std_logic_1164.all;\n")
    rom.write("use ieee.numeric_std.all;\n")
    rom.write("\n")
    rom.write("entity ROM is\n")
    rom.write("\tport(\n")
    rom.write("\t\taddr : in std_logic_vector(8 downto 0);\n")
    rom.write("\t\tdata : out std_logic_vector(16 downto 0)\n")
    rom.write("\t\t);\n")
    rom.write("\tend ROM;\n")
    rom.write("\n")
    rom.write("architecture LUT of ROM is\n")
    rom.write("begin\n")
    rom.write("\tprocess(addr)\n")
    rom.write("\tbegin\n")
    rom.write("\t\tcase addr is\n");
    codeLen = len(binaryCode)
    for i in range(codeLen):
        rstr = "\t\t\twhen \"{0:09b}\" => data <= \"{1}\";\n".format(i, binaryCode[i])
        rom.write(rstr)
    if codeLen < 512:
        rom.write("\t\t\twhen others => data <= \"00000000000000000\";\n")
    rom.write("\t\tend case;\n")
    rom.write("\tend process;\n")
    rom.write("end LUT;\n")

