Features
Shows the current active Windows power plan
Shows current Processor Performance Boost Mode for:
Plugged in / AC power
Battery / DC power
Lets you change PPBM from a simple command-line menu
Supports changing:
AC only
DC only
Both AC and DC
No installation required
Uses built-in Windows powercfg commands
Available Modes
Number	Mode
0	Disabled
1	Enabled
2	Aggressive
3	Efficient Enabled
4	Efficient Aggressive
5	Aggressive at Guaranteed
6	Efficient Aggressive at Guaranteed
Recommended Starting Settings

For gaming laptops, a good starting point is:

Power State	Recommended Mode
Plugged in / AC	Efficient Aggressive
Battery / DC	Efficient Enabled or Disabled

Efficient Aggressive is usually a good balance between performance and lower CPU heat.

How to Use
Download PPBM_Manager_FIXED.bat.
Right-click the file.
Choose Run as administrator.
Check your current PPBM setting.
Choose whether you want to change it.
Select the target:
Plugged in only
Battery only
Both
Choose your preferred boost mode.
Example Output

=====================================================
  Processor Performance Boost Mode (PPBM) Manager
=====================================================

Active power plan: Balanced

Current PPBM:
  Plugged in (AC): Efficient Aggressive  [4]
  
  Battery    (DC): Disabled              [0]

Change it? [Y,N]?


Notes
This tool changes the setting for the current active Windows power plan.
Some systems may require administrator permission.
If the setting does not apply, run the batch file as administrator.
This does not overclock your CPU. It only changes an existing Windows power setting.
Lower boost modes can reduce CPU temperature and fan noise, but may also reduce performance.
Requirements
Windows 10 or Windows 11
powercfg, which is already included in Windows
Disclaimer

Use this tool at your own risk. The script only uses Windows built-in power configuration commands, but you should still understand what each mode does before changing your settings.
