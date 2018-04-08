function plot_brt(brt,Tbb,receiver_name)
    load checkdata_xtick.mat xticklabel
    load('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
    global dateStr;global figure_num;
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),receiver_name,'-亮温曲线']);
        for fig_num = 1 : 4
            subplot(2,2,fig_num);
            channel_num = channel_num + 1;
            delta_T(:,channel_num) = brt(:,channel_num) - Tbb(:);
            average_value(channel_num) = mean(delta_T(:,channel_num));
            std_value(channel_num) = std(delta_T(:,channel_num));
            pp_value(channel_num) = max(delta_T(:,channel_num)) - min(delta_T(:,channel_num));
            yyaxis left
            plot(1:1:lineNum ,brt(:,channel_num));
            v_gca(fig_num) = gca;
            %set(gca,'xtick',MIN_VALUE:T_STEP:MAX_VALUE);
            minValue = floor(min(brt(:,channel_num))*10)/10;maxValue= ceil(max(brt(:,channel_num)));
            if maxValue - minValue <= 2
                maxValue = minValue + 1;
                set(gca,'ytick',minValue:0.2:maxValue);
            end
            ylim = [minValue maxValue];
            set(gca, 'Ylim',ylim );
            xlabel('时间/(时:分)');
            %ylabel('亮温/K');
            yyaxis right
            plot(1:1:lineNum ,Tbb(:));
            %ylabel('黑体温度/K');
            if maxValue - minValue <= 2
                set(gca,'ytick',minValue:0.2:maxValue);
            end
            set(gca, 'Ylim',ylim );
            set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
            set(gca,'xticklabel',xticklabel);
            title(['通道',num2str(channel_num)]);
            set(gca,'FontSize',14);
            grid on;
            hold on;
            legend('亮温','黑体温度');
        end
        suptitle([dateStr,' ',receiver_name,...
            '波段接收机各通道的亮温曲线','亮温(左)与黑体温度(右)曲线[单位:K]']);
        set (gcf,'Position',[80,80,1080,700], 'color','w');
        hold off;
        figure_num = figure_num + 1;
        save2word([dateStr,'brt_temp_report.doc'],['-f',num2str(figure_num)]);
    end
    if receiver_name == 'k' || receiver_name == 'K'
        data_deltaT_K =  [average_value;std_value;pp_value];
        save('delta_T.mat','data_deltaT_K');
    else
        data_deltaT_V =  [average_value;std_value;pp_value];
        save('delta_T.mat','data_deltaT_V','-append');
    end
end