(start)
	//clear screen
0:	@12  //ASCII code for form feed  0000 0000 0000 1100 0x000c
1:	D=A                         	 1000 1100 0001 0000 0x8c10
2:	@0   //address of tty      	 0000 0000 0000 0000 0x0000
3:	M=D  //write to tty        	 1000 0011 0000 1000 0x8308
	
	//write "KEY:" on tty
4:	@78  //ASCII code for 'K'        0000 0000 0100 1011 0x004b
5:	D=A                        	 1000 1100 0001 0000 0x8c10
6:	@0   //address of tty      	 0000 0000 0000 0000 0x0000
7:	M=D  //write to tty        	 1000 0011 0000 1000 0x8308
8:	@79  //ASCII code for 'E'  	 0000 0000 0100 0101 0x0045
9:	D=A                        	 1000 1100 0001 0000 0x8c10
10:	@0   //address of tty      	 0000 0000 0000 0000 0x0000
11:	M=D  //write to tty        	 1000 0011 0000 1000 0x8308
12:	@77  //ASCII code for 'Y'  	 0000 0000 0101 1001 0x0059
13:	D=A                        	 1000 1100 0001 0000 0x8c10
14:	@0   //address of tty      	 0000 0000 0000 0000 0x0000
15:	M=D  //write to tty        	 1000 0011 0000 1000 0x8308
16:	@58  //ASCII code for ':'  	 0000 0000 0011 1010 0x003a
17:	D=A                        	 1000 1100 0001 0000 0x8c10
18:	@0   //address of tty      	 0000 0000 0000 0000 0x0000
19:	M=D  //write to tty        	 1000 0011 0000 1000 0x8308

	//busy waiting for a key pressed on keyboard
(wait)
20:     @2     //address of keyboard state    0000 0000 0000 0010 0x0002
21:	D=M    //D contains state             1001 1100 0001 0000 0x9c10
22:	@wait  	   	    		      0000 0000 0001 0100 0x0014
23:	D;JEQ  //if state = 0 then goto wait  1000 0011 0000 0010 0x8302

	//save key at address 0x0003 in data memory (0x0003 is the first available address in data memory)
24:     @1     //address of key	     	      0000 0000 0000 0001 0x0001
25:	D=M    //D contains key		      1001 1100 0001 0000 0x9c10
26:	@3     //address in data memory	      0000 0000 0000 0011 0x0003
27:	M=D    //save key in data memory      1000 0011 0000 1000 0x8308

	//display all ASCII character on screen from saved key to ASCII 32 included
(loop)        
	//write newline on tty
28:	@10    //ASCII for newline            0000 0000 0000 1010 0x000a
29:	D=A                        	      1000 1100 0001 0000 0x8c10
30:	@0     //address of tty      	      0000 0000 0000 0000 0x0000
31:	M=D    //write to tty        	      1000 0011 0000 1000 0x8308

	//display one character
32:	@3					0000 0000 0000 0011 0x0003
33:	D=M  //get saved character from M[3]	1001 1100 0001 0000 0x9c10
34:	@0   //address of tty	   		0000 0000 0000 0000 0x0000
35:	M=D  //write to tty	  		1000 0011 0000 1000 0x8308

	//save D-1 at address 0x0003 in data memory
36:	@3            	      	     0000 0000 0000 0011 0x0003
37:	M=D-1  //M[3] = M[3] - 1     1000 0011 1000 1000 0x8388

	//if D <= 32 then goto start
38:	@32    	  0000 0000 0010 0000 0x0020
39:	D=D-A	  1000 0100 1101 0000 0x84d0
40:	@start	  0000 0000 0000 0000 0x0000
41:	D;JLE	  1000 0011 0000 0110 0x8306

	//goto loop
42:	@loop	  0000 0000 0001 1100 0x001c
43:	0;JMP	  1000 1010 1000 0111 0x8a87
