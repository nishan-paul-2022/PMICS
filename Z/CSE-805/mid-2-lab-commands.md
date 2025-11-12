Volatility 2.6
---------
	note: put all file in one folder
	demo: volatility.exe -f /home/kali/memorydump/dump.vmem imageinfo

Imageinfo
---------
	volatility.exe -f dump.vmem imageinfo


pslist	(profile=WinXPSP2x86,WinXPSP3x86)
-----------------------------------------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 pslist


psscan
------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 psscan

PStree
------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 pstree

DLLList
-------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 dlllist -p 788

DLLDump
-------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 dlldump --dump-dir <the path you wants to pest>

	volatility.exe -f dump.vmem --profile=WinXPSP2x86 dlldump --dump-dir C:\Users\Ayan\Desktop\volatility\ramdump


Handles
-------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 handles

Netscan
-------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 netscan

Timeliner
---------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 timeliner

HashDump
--------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 hashdump

Cmdscan
--------
	volatility.exe -f dump.vmem --profile=WinXPSP2x86 cmdscan
