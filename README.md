# GF3-RTC-based-on-RPC
![image](https://user-images.githubusercontent.com/40664903/227858718-59542645-f2d5-4346-b516-5ae309fd8f38.png)

The above program supports radiometric terrain correction (RTC) processing of SAR data based on the rational polynomial coefficient (RPC) model. Based on the RPC file provided by GF3 satellite, users can use the code provided by us to implement geocoding of terrain correction (GTC) and RTC processing of SAR data without solving the RD positioning model. The above program is mainly IDL source code, with a small number of compiled executable files. Part of the executable program exe is derived from the well-known open source radar processing software PolSARpro.

# How to use the program:

（1）The current version of the program is based on IDL 8.2 and relies on some ENVI functions. Therefore, users need to install IDL/ENVI software to use this program. The recommended version is IDL 8.0/ENVI 5.0 or higher. 

（2）Please download the above code and place it in the same IDL workspace, as shown in the following figure.
<img width="965" alt="1680159393405" src="https://user-images.githubusercontent.com/40664903/228754326-603caae2-04c3-4e80-8281-ea3372e2ef07.png">

（3）Open the main program “Main_Program.pro”, modify input and output parameters, compile, and run.

# Description of individual procedures:

“gf3_data_reader_for_polsarpro.sav”： Input the L1A level SLC product of GF3 satellite and output SAR data in PolSARpro file format (ENVI format). Taking full polarization SAR data as an example, the output is the S2 matrix directly available to PolSARpro.

More details: https://mp.weixin.qq.com/s/zQH3lWOCUyuXSwwQ5_wWBA

“GF3_PolSAR_PAR_Reader.exe”： Convert the metadata file (*.XML) of GF3's SAR data into the *.par format of Gamma software, and then users can use Gamma software to process GF3 data.

More details: https://mp.weixin.qq.com/s/-0VpLbxfeZGNM6H_WcQc8Q

# Developer
Developed by the Institute of Forest Resource Information Techniques, Chinese Academy of Forestry.
Lei Zhao (zhaolei@ifrit.ac.cn), Erxue Chen (chenerx@ifrit.ac.cn), Zengyuan Li (zengyuan.li@ifrit.ac.cn).

# citation
Zhao, L.; Chen, E.; Li, Z.; Fan, Y.; Xu, K. Radiometric Terrain Correction Method Based on RPC Model for Polarimetric SAR Data. Remote Sens. 2023, 15, 1909. https://doi.org/10.3390/rs15071909

https://www.mdpi.com/2228380
