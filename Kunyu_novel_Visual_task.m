%����̼����Ӿ����������Ӱ�졪�������Ѷ��Եĵ�������
%�Ա����������̼�������/��׼����֪���Ѷȣ���/�ף������ʱ�䣨0/100ms/200ms��%
%���������Ӧʱ/��ȷ�ʣ�
%��ƣ���   ���ر�������ƣ�
  
clear all;clc;
Screen('Preference', 'SkipSyncTests', 2);

%%
 % �ռ����ԵĻ�����Ϣ
 prompt = {'���Ա��','�Ա�[1 = ��, 2 = Ů]','����'}; % ��Ҫ�ռ�����Ϣ
 title = '���Ի�����Ϣ'; % �Ի������
 definput = {'','',''}; % Ĭ����Ϣ��������Ϊ��ֵ
 % ʹ��inputdlg�����ռ���Ϣ����д�롰data������
 subinfo(1,1:3) = inputdlg(prompt,title,[1, 50],definput)';

%%
%�̼�˳�����
%trail num
block=10;
trialnum=180;
sti=zeros(trialnum,1);

%��1�� block��
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
    %ѭ���Ѵ��ҵĴ̼���ϰ�block��������
    A=[A; rowsti(randperm(size(rowsti,1)),:)];
end
sti(:,2:4)=A;  %get ��
%%
%��2�� sound condition:novelΪ1,normalΪ2��������Ϊ3��
%��3�� ISI condition��0sΪ1��100msΪ2��300msΪ3��
%��4�� difficulty condition��1�ѣ�2�򵥣�
%��5�� ���þ�����������
sti(find(sti(:,2)==1),5)=[randperm(12)';randperm(12)';randperm(12)';randperm(12)';randperm(12)'];
sti(find(sti(:,2)==2),5)=[randperm(12)'+12;randperm(12)'+12;randperm(12)'+12;randperm(12)'+12;randperm(12)'+12];    
sti(find(sti(:,2)==3),5)=[randperm(12)'+24;randperm(12)'+24;randperm(12)'+24;randperm(12)'+24;randperm(12)'+24];
%sti(find(sti(:,2)==4),5)=[randperm(30)'+90;randperm(30)'+90];

%��6�� ���þ����ѶȲ���
sti(find(sti(:,4)==1),6)=[randperm(90)'];
sti(find(sti(:,4)==2),6)=[randperm(90)'+90];    

%��7�� N(78) or X(98)
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

%��8�� �������ʱ��time : 0/1/2
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
%��9�� ��������
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
%����ͼƬ
picpath='C:\Users\KunyuZou\Desktop\�Ӿ���������\pic2\';
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
%%���尴�����򿪽���

%��ȫ��
%win=Screen('OpenWindow',0,[0 0 0],[100,100,1200,800]);%��100��100λ�ô�һ��800*600�ĺ�ɫ���ڣ�׼�����ִ̼�

%ȫ��
win=Screen('OpenWindow',0,[0 0 0],[]);
KbName('UnifyKeyNames'); 
escapeKey=KbName('ESCAPE'); 
rest_continueKey=KbName('s');
nKey=KbName('a');
xKey=KbName('l');
startKey=('SPACE');

%����ָ����
inst_textureIndex=Screen('MakeTexture',win,instread); %������ͼƬ�ķ�ʽװ��
Screen('DrawTexture',win,inst_textureIndex);%��ͼƬ�̼��뻺����
Screen('Flip',win,0);
KbStrokeWait;%�ȴ�������Ӧ��

%%
audio_filepath='C:\Users\KunyuZou\Desktop\�Ӿ���������\wav�ļ���������';

for k=1:length(sti)
    %׼�������̼�
    [snd,fs]=audioread([audio_filepath,'\',num2str(sti(k,5)),'.wav']);
    last_time(k,1)=length(snd)/fs;
    
    %����ע�ӵ� + %���������̼�
%     WaitSecs(1);    
    cross_textureIndex=Screen('MakeTexture',win,cross_read); %������ͼƬ�ķ�ʽװ��
    Screen('DrawTexture',win,cross_textureIndex);%��ͼƬ�̼��뻺����
    Screen('Flip',win);  sound(snd,fs);
   
    %ע�ӵ���������̼���ʱ��
    WaitSecs(last_time(k,1));
%     pause(last_time(k,1));

    %���ݳ���ʱ��
    black_textureIndex=Screen('MakeTexture',win,blackread); %������ͼƬ�ķ�ʽװ��
    Screen('DrawTexture',win,black_textureIndex);%��ͼƬ�̼��뻺����
    Screen('Flip',win); 
    WaitSecs(sti(k,8));
    
    %ѡ����ĸ�̼� ������
    hard_textureIndex=Screen('MakeTexture',win,Picread{sti(k,6)}); %������ͼƬ�ķ�ʽװ��
    Screen('DrawTexture',win,hard_textureIndex);%��ͼƬ�̼��뻺����
    Screen('Flip',win,0)
    
    %������Ӧ
    % ��¼��Ӧ��Ϣ�������1s֮�ڷ�Ӧ�����¼�����ͷ�Ӧʱ
    t0 = GetSecs; %��ȡ�̼���ʼ���ֵ�ʱ��
    
    %����������¼
    subData(k,1)=str2num(subinfo{1,1});%���
    subData(k,2)=str2num(subinfo{1,2});%�Ա�
    subData(k,3)=str2num(subinfo{1,3});%����
    subData(k,4)=sti(k,2);             %��������
    subData(k,5)=sti(k,3);             %ISI
    subData(k,6)=sti(k,4);             %֪���Ѷ�
    subData(k,7)=sti(k,7);             %��׼������Ӧ N-1 / L-2��
    subData(k,11)=sti(k,9);             %12�������еľ�������
    % subData(k,8)                     %���Եķ�Ӧ
    % subData(k,9)                     %ACC
    % subData(k,10)                    %RT
    
    while GetSecs - t0 < 3 % ��3s�ڿ��Է�Ӧ
        [keyisdown, secs, keycode] = KbCheck;
        if keycode(escapeKey)
            sca;
            return
        elseif keycode(nKey)
            subData(k,8) = 1; %���Եİ���ΪN
            subData(k,10)= GetSecs - t0;  %���Եķ�Ӧʱ
            if sti(k,7)==1;    %���Եİ����Ƿ���ȷ
                subData(k,9)=1;
            else
                subData(k,9)=0;
            end
            break
        elseif keycode(xKey)
            subData(k,8) = 2; %���Եİ���ΪX
            subData(k,10)= GetSecs - t0;  %���Եķ�Ӧʱ
            if sti(k,7)==2;    %���Եİ����Ƿ���ȷ
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
    
    black_textureIndex=Screen('MakeTexture',win,blackread); %������ͼƬ�ķ�ʽװ��
    Screen('DrawTexture',win,black_textureIndex);%��ͼƬ�̼��뻺����
    Screen('Flip',win); 
    WaitSecs(0.5);
    
    %break1 ��Ϣʱ��
    if k==length(sti)/3
        rest_textureIndex=Screen('MakeTexture',win,restread);
        Screen('DrawTexture', win, rest_textureIndex);
        Screen('Flip',win);
        WaitSecs(10);
        
        continue_task_textureIndex=Screen('MakeTexture',win,continue_task_read);
        Screen('DrawTexture', win, continue_task_textureIndex);
        Screen('Flip',win);
        
        t1 = GetSecs; 

        while GetSecs - t1 < 10   %��10s��������Ӧ���������飻
            [keylsDown,t,keyCode]=KbCheck;
            if keyCode(rest_continueKey)
                break;
            end
        end
    end
    
    %break2 ��Ϣʱ��
    if k==(length(sti)/3)*2
        rest_textureIndex=Screen('MakeTexture',win,restread);
        Screen('DrawTexture', win, rest_textureIndex);
        Screen('Flip',win);
        WaitSecs(10);
        
        continue_task_textureIndex=Screen('MakeTexture',win,continue_task_read);
        Screen('DrawTexture', win, continue_task_textureIndex);
        Screen('Flip',win);
        
        t2 = GetSecs; 

        while GetSecs - t2 < 10   %��10s��������Ӧ���������飻
            [keylsDown,t,keyCode]=KbCheck;
            if keyCode(rest_continueKey)
                break;
            end
        end
    end
end

%������
end_textureIndex=Screen('MakeTexture',win,endread);
Screen('DrawTexture', win, end_textureIndex);
Screen('Flip',win,0);
WaitSecs(2);
sca;

%��������
% ������������һ�������
%cellData=mat2cell(subData,length(sti)/20,[1,1,1,1,1]);
% data_table = cell2table(cellData, 'VariableNames', header);
header = {'SubjectNumber','Gender','Age','Audio','ISI','Perceptual_Difficulty',...
    'standard_Resp', 'Real_Resp', 'ACC', 'RT','Cond'};
result_table=table(subData(:,1),subData(:,2),subData(:,3),subData(:,4),...
    subData(:,5),subData(:,6),subData(:,7),subData(:,8),...
    subData(:,9),subData(:,10),subData(:,11),'VariableNames',header);

% ���ݱ���������һ��csv�ļ������ڱ�������
exp_data = (['data_novelsound\', 'exp_example_', char(subinfo{1,1}), '_', date, '.csv']);
writetable(result_table, exp_data);

%save subdata_mat
mat_filepath='C:\Users\KunyuZou\Desktop\�Ӿ���������\data_novelsound\';
save([mat_filepath,['submat',char(subinfo{1,1})]], 'subData');

%ʵ�����
disp('Succeed!');