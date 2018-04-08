clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开亮温文件');
complete_file = strcat(filepath,filename);
fidin = fopen(complete_file,'r+');
lineNum = 0;timeNum = 0;
fileStruct = dir(complete_file);
sizeofFile = fileStruct.bytes;
splitNum = ceil(sizeofFile*1.2/1024);
format_data = '';
for i = 1:1:22
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %判断是否为文件末尾
    tline = fgetl(fidin);         %从文件读行   
    tline = strtrim(tline);
    if isempty(tline)
        continue;
    end
    if ~contains(tline,'#')
        lineNum = lineNum + 1;
        sourceData = textscan(tline , format_data);
        if lineNum == 1
            year = sourceData{1,1};
            month = sourceData{1,2};
            day = sourceData{1,3};
        end
        if mod(lineNum,splitNum)==1
            timeNum = timeNum + 1;
            hour(timeNum) = sourceData{1,4};
            minute(timeNum) = sourceData{1,5}; 
            second(timeNum) = sourceData{1,6};
        end
        for i = 1:8
            K_Brt(lineNum,i) = sourceData{1,6+i};%亮温
            V_Brt(lineNum,i) = sourceData{1,14+i};%亮温
        end
    else
            continue;
    end%对应外圈的if
end%对应while循环
fclose(fidin);
save('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
global dateStr;global xlsFilePath;
dateStr = [num2str(year,'%02d'),num2str(month,'%02d'),num2str(day,'%02d')];
xlsFilePath = [num2str(year,'%02d'),num2str(month,'%02d'),'_deltaTBB'];
for i = 1:timeNum
    xlabel_vol_str = [num2str(hour(i),'%02d'),':',num2str(minute(i),'%02d')];
    xticklabel{i} = xlabel_vol_str;
end
save checkdata_xtick.mat xticklabel
%获取黑体温度
Tbb = get_Tbb();
%画亮温曲线
global figure_num;figure_num = 0;
plot_brt(K_Brt,Tbb,'K');
plot_brt(V_Brt,Tbb,'V');
%把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
global sheetNum;
global positionRowNum;
sheetNum = 1;
positionRowNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%清除产生的mat文件
delete_mat();
close all;%关闭所有图像窗口