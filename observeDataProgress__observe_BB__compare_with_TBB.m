clear all;clc;
close all;%�ر�����figure����
[filename,filepath]=uigetfile('*.txt','�������ļ�');
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
while ~feof(fidin)         %�ж��Ƿ�Ϊ�ļ�ĩβ
    tline = fgetl(fidin);         %���ļ�����   
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
            K_Brt(lineNum,i) = sourceData{1,6+i};%����
            V_Brt(lineNum,i) = sourceData{1,14+i};%����
        end
    else
            continue;
    end%��Ӧ��Ȧ��if
end%��Ӧwhileѭ��
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
%��ȡ�����¶�
Tbb = get_Tbb();
%����������
global figure_num;figure_num = 0;
plot_brt(K_Brt,Tbb,'K');
plot_brt(V_Brt,Tbb,'V');
%�ѱ�񱣴浽excel��ע��excel�ļ�̫��190KB���ң����ܵ�������д����ȥ�����
global sheetNum;
global positionRowNum;
sheetNum = 1;
positionRowNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%���������mat�ļ�
delete_mat();
close all;%�ر�����ͼ�񴰿�