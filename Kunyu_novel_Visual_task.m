%新异刺激对视觉搜索任务的影响——任务难度以的调节作用
%自变量：听觉刺激（新异/标准）；知觉难度（难/易）；间隔时间（0/100ms/200ms）%
%因变量：反应时/正确率；
%设计：两   因素被试内设计；
  
clear all;clc;
Screen('Preference', 'SkipSyncTests', 2);

%%
 % 收集被试的基本信息
 prompt = {'被试编号','性别[1 = 男, 2 = 女]','年龄'}; % 想要收集的信息
 title = '被试基本信息'; % 对话框标题
 definput = {'','',''}; % 默认信息，不填则为空值
 % 使用inputdlg函数收集信息，并写入“data”数组
 subinfo(1,1:3) = inputdlg(prompt,title,[1, 50],definput)';

%%
%刺激顺序矩阵
%trail num
block=10;
trialnum=180;
sti=zeros(trialnum,1);

%第1列 block；
k=(1:18:trialnum);
for i=1:length(k)
    sti(k(i):k(i)+17,1)=i;
end

%rowsti 
k1=(1:6:18);
for u=1:length(k1)
    rowsti(k1(u):k1(u)+5,1)=u;
end
rowsti(:,2)=repmat([1;1;2;2;3;3],3,1);
rowsti(:,3)=repmat([1;2],9,1);

%real sti
A=[];
for h=1:block
    %循环把打乱的刺激组合按block叠起来；
    A=[A; rowsti(randperm(size(rowsti,1)),:)];
end
sti(:,2:4)=A;  %get √
%%
%第2列 sound condition:novel为1,normal为2，无声音为3；
%第3列 ISI condition：0s为1，100ms为2，300ms为3；
%第4列 difficulty condition：1难，2简单；
%第5列 配置具体听力材料
sti(find(sti(:,2)==1),5)=[randperm(12)';randperm(12)';randperm(12)';randperm(12)';randperm(12)'];
sti(find(sti(:,2)==2),5)=[randperm(12)'+12;randperm(12)'+12;randperm(12)'+12;randperm(12)'+12;randperm(12)'+12];    
sti(find(sti(:,2)==3),5)=[randperm(12)'+24;randperm(12)'+24;randperm(12)'+24;randperm(12)'+24;randperm(12)'+24];
%sti(find(sti(:,2)==4),5)=[randperm(30)'+90;randperm(30)'+90];

%第6列 配置具体难度材料
sti(find(sti(:,4)==1),6)=[randperm(90)'];
sti(find(sti(:,4)==2),6)=[randperm(90)'+90];    

%第7列 N(78) or X(98)
for i=1:length(sti)
    if sti(i,6)<=45
        sti(i,7)=1;
    elseif sti(i,6)>45 & sti(i,6)<=90
        sti(i,7)=2;
    elseif sti(i,6)>90 & sti(i,6)<=135
        sti(i,7)=1;
    elseif sti(i,6)>135 & sti(i,6)<=180
        sti(i,7)=2;
    end
end

%第8列 具体操纵时间time : 0/1/2
for i=1:length(sti)
    if sti(i,3)==1
        sti(i,8)=0;
    elseif sti(i,3)==2
        sti(i,8)=1;
    elseif sti(i,3)==3
        sti(i,8)=2;
    end
end
%%
%第9列 具体条件
%1-111; 2-112; 3-121; 4-122; 5-131; 6-132; 
%7-211; 8-212; 9-221; 10-222; 11-231; 12-232;
%13-311; 14-312; 15-321; 16-322; 17-331; 18-332;
cod1=[1:3]';
cod2=[1:3]';
cod3=[1:2]';
cd=0;

for u=1:18
    cod(1:10,u)=u;
end

for c1=1:length(cod1)
    for c2=1:length(cod2)
        for c3=1:length(cod3)
            cd=cd+1;
            sti(find(sti(:,2)==c1 & sti(:,3)==c2 & sti(:,4)==c3),9)=cod(10,cd);
        end
    end
end

%%
%读入图片
picpath='C:\Users\KunyuZou\Desktop\视觉搜索任务\pic2\';
for i=1:trialnum
    Picread{i}=imread([picpath,num2str(i),'.jpg']);
end
blackread=imread('black.jpg');
endread=imread('end.jpg');
restread=imread('rest.jpg');
continue_task_read=imread('continue_task.jpg');
instread=imread('instruction.jpg');
cross_read=imread('cross.jpg');

%%
%%定义按键，打开界面

%非全屏
%win=Screen('OpenWindow',0,[0 0 0],[100,100,1200,800]);%在100，100位置打开一个800*600的黑色窗口，准备呈现刺激

%全屏
win=Screen('OpenWindow',0,[0 0 0],[]);
KbName('UnifyKeyNames'); 
escapeKey=KbName('ESCAPE'); 
rest_continueKey=KbName('s');
nKey=KbName('a');
xKey=KbName('l');
startKey=('SPACE');

%呈现指导语
inst_textureIndex=Screen('MakeTexture',win,instread); %以纹理图片的方式装载
Screen('DrawTexture',win,inst_textureIndex);%将图片刺激入缓冲器
Screen('Flip',win,0);
KbStrokeWait;%等待按键反应；

%%
audio_filepath='C:\Users\KunyuZou\Desktop\视觉搜索任务\wav文件新异声音';

for k=1:length(sti)
    %准备听力刺激
    [snd,fs]=audioread([audio_filepath,'\',num2str(sti(k,5)),'.wav']);
    last_time(k,1)=length(snd)/fs;
    
    %呈现注视点 + %播放听力刺激
%     WaitSecs(1);    
    cross_textureIndex=Screen('MakeTexture',win,cross_read); %以纹理图片的方式装载
    Screen('DrawTexture',win,cross_textureIndex);%将图片刺激入缓冲器
    Screen('Flip',win);  sound(snd,fs);
   
    %注视点呈现声音刺激的时间
    WaitSecs(last_time(k,1));
%     pause(last_time(k,1));

    %操纵呈现时间
    black_textureIndex=Screen('MakeTexture',win,blackread); %以纹理图片的方式装载
    Screen('DrawTexture',win,black_textureIndex);%将图片刺激入缓冲器
    Screen('Flip',win); 
    WaitSecs(sti(k,8));
    
    %选择字母刺激 第六列
    hard_textureIndex=Screen('MakeTexture',win,Picread{sti(k,6)}); %以纹理图片的方式装载
    Screen('DrawTexture',win,hard_textureIndex);%将图片刺激入缓冲器
    Screen('Flip',win,0)
    
    %按键反应
    % 记录反应信息，如果在1s之内反应，则记录按键和反应时
    t0 = GetSecs; %获取刺激开始呈现的时间
    
    %所有条件记录
    subData(k,1)=str2num(subinfo{1,1});%编号
    subData(k,2)=str2num(subinfo{1,2});%性别
    subData(k,3)=str2num(subinfo{1,3});%年龄
    subData(k,4)=sti(k,2);             %声音条件
    subData(k,5)=sti(k,3);             %ISI
    subData(k,6)=sti(k,4);             %知觉难度
    subData(k,7)=sti(k,7);             %标准按键反应 N-1 / L-2；
    subData(k,11)=sti(k,9);             %12个条件中的具体条件
    % subData(k,8)                     %被试的反应
    % subData(k,9)                     %ACC
    % subData(k,10)                    %RT
    
    while GetSecs - t0 < 3 % 在3s内可以反应
        [keyisdown, secs, keycode] = KbCheck;
        if keycode(escapeKey)
            sca;
            return
        elseif keycode(nKey)
            subData(k,8) = 1; %被试的按键为N
            subData(k,10)= GetSecs - t0;  %被试的反应时
            if sti(k,7)==1;    %被试的按键是否正确
                subData(k,9)=1;
            else
                subData(k,9)=0;
            end
            break
        elseif keycode(xKey)
            subData(k,8) = 2; %被试的按键为X
            subData(k,10)= GetSecs - t0;  %被试的反应时
            if sti(k,7)==2;    %被试的按键是否正确
                subData(k,9)=1;
            else
                subData(k,9)=0;
            end
            break
        else
            subData(k,8)=999;
            subData(k,9)=999;
            subData(k,10)=999;
        end
    end
    
    black_textureIndex=Screen('MakeTexture',win,blackread); %以纹理图片的方式装载
    Screen('DrawTexture',win,black_textureIndex);%将图片刺激入缓冲器
    Screen('Flip',win); 
    WaitSecs(0.5);
    
    %break1 休息时间
    if k==length(sti)/3
        rest_textureIndex=Screen('MakeTexture',win,restread);
        Screen('DrawTexture', win, rest_textureIndex);
        Screen('Flip',win);
        WaitSecs(10);
        
        continue_task_textureIndex=Screen('MakeTexture',win,continue_task_read);
        Screen('DrawTexture', win, continue_task_textureIndex);
        Screen('Flip',win);
        
        t1 = GetSecs; 

        while GetSecs - t1 < 10   %在10s内作出反应，继续试验；
            [keylsDown,t,keyCode]=KbCheck;
            if keyCode(rest_continueKey)
                break;
            end
        end
    end
    
    %break2 休息时间
    if k==(length(sti)/3)*2
        rest_textureIndex=Screen('MakeTexture',win,restread);
        Screen('DrawTexture', win, rest_textureIndex);
        Screen('Flip',win);
        WaitSecs(10);
        
        continue_task_textureIndex=Screen('MakeTexture',win,continue_task_read);
        Screen('DrawTexture', win, continue_task_textureIndex);
        Screen('Flip',win);
        
        t2 = GetSecs; 

        while GetSecs - t2 < 10   %在10s内作出反应，继续试验；
            [keylsDown,t,keyCode]=KbCheck;
            if keyCode(rest_continueKey)
                break;
            end
        end
    end
end

%结束语
end_textureIndex=Screen('MakeTexture',win,endread);
Screen('DrawTexture', win, end_textureIndex);
Screen('Flip',win,0);
WaitSecs(2);
sca;

%整理数据
% 将数据整理至一个表格中
%cellData=mat2cell(subData,length(sti)/20,[1,1,1,1,1]);
% data_table = cell2table(cellData, 'VariableNames', header);
header = {'SubjectNumber','Gender','Age','Audio','ISI','Perceptual_Difficulty',...
    'standard_Resp', 'Real_Resp', 'ACC', 'RT','Cond'};
result_table=table(subData(:,1),subData(:,2),subData(:,3),subData(:,4),...
    subData(:,5),subData(:,6),subData(:,7),subData(:,8),...
    subData(:,9),subData(:,10),subData(:,11),'VariableNames',header);

% 根据变量名创建一个csv文件，用于保存数据
exp_data = (['data_novelsound\', 'exp_example_', char(subinfo{1,1}), '_', date, '.csv']);
writetable(result_table, exp_data);

%save subdata_mat
mat_filepath='C:\Users\KunyuZou\Desktop\视觉搜索任务\data_novelsound\';
save([mat_filepath,['submat',char(subinfo{1,1})]], 'subData');

%实验结束
disp('Succeed!');