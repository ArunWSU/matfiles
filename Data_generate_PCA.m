%% PCA analysis on Real dist feeder
% Feeder voltage by phase
test_system='Bus_123_case21';
Node_names=Bus.Node_names;
Vpu_names=[Node_names'; num2cell(Bus.Vpu)];
% Determines wrting output into excel files
write=1;
filepath='D:/PCAdatasets/';
file_extension='.xlsx';
%% Generating primary voltages matrix by phase
% Setting secondary node and phase number of nodes
SecFlag=zeros(1,size(Node_names,1));
PhaseNum=zeros(1,size(Node_names,1));
for i=1:size(Node_names,1)
    % Hyphen for secondary nodes in Emad definition
    split_size=size(strsplit(Node_names{i,1},{'.','-'}),2);
    if(split_size > 2)
        SecFlag(1,i)=1;
    end
    % Underscore for open switches
    split_string=strsplit(Node_names{i,1},{'.','_'});
    if(~isnan(str2double(split_string{1,2})))
      PhaseNum(1,i)=str2num(split_string{1,2});
    end
end
parameter='volt';
% Segregating voltages by phase
sys=1;
if(sys==1)
    V1=[Node_names(PhaseNum==1)'; num2cell(Bus.Vpu(:,PhaseNum==1))];
    V2=[Node_names(PhaseNum==2)'; num2cell(Bus.Vpu(:,PhaseNum==2))];
    V3=[Node_names(PhaseNum==3)'; num2cell(Bus.Vpu(:,PhaseNum==3))];
else
    cond1=((PhaseNum==1)&(SecFlag==0));
    V1=[Node_names(cond1)'; num2cell(Bus.Vpu(:,(cond1)))];
    cond2=((PhaseNum==2)&(SecFlag==0)); 
    V2=[Node_names(cond2)'; num2cell(Bus.Vpu(:,(cond2)))];
    cond3=((PhaseNum==3)&(SecFlag==0));
    V3=[Node_names(cond3)'; num2cell(Bus.Vpu(:,(cond3)))];
end
 if(write==1)
        xlswrite(strcat(filepath,test_system,parameter,file_extension),V1,1);
        xlswrite(strcat(filepath,test_system,parameter,file_extension),V2,2);
        xlswrite(strcat(filepath,test_system,parameter,file_extension),V3,3);
%         warning('OFF','Added specified worksheet.')
 end
%% Visualizing Time series profile
modifier=1;
save=1;
filepath='C:\Users\WSU-PNNL\OneDrive - Washington State University (email.wsu.edu)\Real Dist test system data\Distribution test system\Visualization\PCA dataset\Results in slides\123 Node system load profile\';
f1=figure;
x=linspace(1,size(V1,2),size(V1,2));
dat1=cell2mat(V1(2:end,:));
plot(x,dat1,'-*');
file_extension='.png';
ylabel('Voltage(pu)');
xlabel('No of time steps(Line - voltage profile)');
if(save==1)
  saveas(f1,strcat(filepath,test_system,num2str(modifier),file_extension));
end
modifier=modifier+1;
f2=figure;
x=linspace(1,size(V1,1),size(V1,1)-1);
dat1=cell2mat(V1(2:end,:));
plot(x,dat1,'-*');
ylabel('Voltage(pu)');
xlabel('Node voltage plot(Line - time steps)');
if(save==1)
  saveas(f2,strcat(filepath,test_system,num2str(modifier),file_extension));
end
%% Load powers
pow=0;
parameter='Load_power';
if(pow==1)
    figure
    x=linspace(0,size(FeederA_P,2),size(FeederA_P,2));
    dat1=(FeederA_P(2:25,:));
    plot(x,dat1,'-*');
    if(write==1)
        xlswrite(strcat(filepath,test_system,parameter,file_extension),FeederA_P,1);
        xlswrite(strcat(filepath,test_system,parameter,file_extension),FeederB_P,2);
        xlswrite(strcat(filepath,test_system,parameter,file_extension),FeederC_P,3);
    end
end
%% Line power measurements by phase
parameter='Line_power';
line_pow=0;
if(line_pow==1)
    for i = 1:12
    find_line_name=line_names{i};
    split_val=strsplit(find_line_name,'_');
    line_index=find(strcmp(find_line_name,line_names));
    line_phase_index(i)=sum(line_I_points_nums(1:line_index-1))+1;
    Line_matrix(:,i)=powers_line(:,line_phase_index(i)); 
    end
    if(write==1)
    xlswrite(strcat(filepath,test_system,parameter,file_extension),Line_matrix);
    end
end