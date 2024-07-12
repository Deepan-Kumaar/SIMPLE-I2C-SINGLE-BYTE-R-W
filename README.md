# SIMPLE-I2C-SINGLE-BYTE-R-W
This is a VerilogHDL implementation of the Inter-Intergrated Circuit(I2C) to READ or WRITE  a single byte of data on or off of  a single slave and a single master.

# NEW-I2C:
The SDA is an inout type and is a single line which will send the data one bit per cycle.
The acknowledge is routed to the SDA and will be triggered only through the SDA.
https://github.com/Deepan-Kumaar/SIMPLE-I2C-SINGLE-BYTE-R-W/tree/bf4c4adee09d0ce2d810d79bb75ae5d693c59bde/NEW_I2C

# OLD-I2C:
Has multiple SDA line for output and input for both slave and master. 
Also SDA is a 8 bit vector which will send the data all at once
The acknowledge is not routed through the SDA instead has a individual pin.
