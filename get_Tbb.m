function BB_temperature_aver = get_Tbb()
    [filename,filepath]=uigetfile('*.txt','打开黑体温度文件');
    complete_file = strcat(filepath,filename);
    fidin = fopen(complete_file,'r+');
    lineNum = 0;timeNum = 0;
    fileStruct = dir(complete_file);
    sizeofFile = fileStruct.bytes;
    splitNum = ceil(sizeofFile/1024);
    format_data = '';
    for i = 1:1:86
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
            for i = 1:4
                Blackbody_T(lineNum,i) = sourceData{1,40+i};%41-44对应黑体1-4
            end
            for i = 1:4
                BB_temperature_aver(lineNum) = mean(Blackbody_T(lineNum,1:4))+273.17;
            end
        else
                continue;
        end%对应外圈的if
    end%对应while循环
    fclose(fidin);
end