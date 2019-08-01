%% Initialize OpenDSS
DSSObj = actxserver('OpenDSSEngine.DSS'); % Instantiate the OpenDSSEnigne
DSSStart=DSSObj.Start(0); % start Open DSS by zero

% Start up the Solver
if DSSStart
    disp('Connection Established');
else
    disp('Unable to start the OpenDSS Engine')
end

% Set up the Text, Circuit, and Solution   Interfaces
DSSText = DSSObj.Text;
DSSCircuit = DSSObj.ActiveCircuit; 
DSSSolution = DSSCircuit.Solution;
DSSCtrlQueue=DSSCircuit.CtrlQueue;
DSSText.Command='Clear';

% For Daily Simulation
DSSText.Command='Compile D:\OpenDSS\OpenDSS\IEEETestCases\123Bus\IEEE123Master1.dss';
DSSText.Command='Set Mode=Daily stepsize=1h number=1';
DSSText.Command='Redirect D:\OpenDSS\OpenDSS\IEEETestCases\123Bus\SetDailyLoadShape.DSS';
Meter_values_index=0;
% DSSSolution.InitSnap; % To initialize rhe monitors if it exists
%% Case 0 - No regulator controls Default_123, 1: Reg controls time, 2:Reconfigutaions
DSSSolution.dblHour=0.0;
use_case=3;
Noofhours=5;
switch use_case
    case 0
        DSSText.Command='Set Controlmode=OFF';
    case 1
        DSSText.Command='Set Controlmode=Time';
    case 21    
        DSSText.Command='Set Controlmode=Time';
        DSSText.Command='SwtControl.Switch5.Action=Open';
        DSSText.Command='SwtControl.Switch7.Action=Close';
    case 22 
        DSSText.Command='Set Controlmode=Time';
        DSSText.Command='SwtControl.Switch3.Action=Open';
        DSSText.Command='SwtControl.Switch7.Action=Close';
    case 23 
        DSSText.Command='Set Controlmode=Time';
        DSSText.Command='SwtControl.Switch4.Action=Open';
        DSSText.Command='SwtControl.Switch7.Action=Close';
    case 3
        DSSText.Command='Set Controlmode=OFF';
        DSSText.Command='New Fault.F1 phases=3 Bus1=87 R=0.002 temporary=yes';
end
tic
[Bus,PDElement,PCElement,Transformertap,Switch] = Timestep(Noofhours,DSSText,DSSCircuit,DSSSolution,0,Meter_values_index);
toc 
if(use_case==3)
Noofhours=4;
DSSText.Command='Edit Fault.F1 Enable=no';
[Bus1,PDElement1,PCElement1,Transformertap1,Switch1] = Timestep(Noofhours,DSSText,DSSCircuit,DSSSolution,0,Meter_values_index);
end