function saveTableData()
    global xlsFilePath;
    global dateStr;
    global sheetNum;
    global rnames;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�����������������¶Ȳ�ֵ���ݱ��
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('delta_T.mat','data_deltaT_K','data_deltaT_V');
    for i = 1:8
        cnames(i) = {['ͨ��',num2str(i)]};
    end
    title = ['���ν��ջ���ͨ������������¶Ȳ�ֵ(��������:',dateStr,'��'];
    rnames = {'��ֵ/K','��׼��/K','���ֵ/K'};%�޸ĵ�λ
    write2xls(xlsFilePath,['K',title],cnames,data_deltaT_K,length(cnames));
    write2xls(xlsFilePath,['V',title],cnames,data_deltaT_V,length(cnames));
    sheetNum = sheetNum + 1;
end