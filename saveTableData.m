function saveTableData()
    global xlsFilePath;
    global dateStr;
    global sheetNum;
    global rnames;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %保存黑体亮温与黑体温度差值数据表格
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('delta_T.mat','data_deltaT_K','data_deltaT_V');
    for i = 1:8
        cnames(i) = {['通道',num2str(i)]};
    end
    title = ['波段接收机各通道亮温与黑体温度差值(测量日期:',dateStr,'）'];
    rnames = {'均值/K','标准差/K','峰峰值/K'};%修改单位
    write2xls(xlsFilePath,['K',title],cnames,data_deltaT_K,length(cnames));
    write2xls(xlsFilePath,['V',title],cnames,data_deltaT_V,length(cnames));
    sheetNum = sheetNum + 1;
end