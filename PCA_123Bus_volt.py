# -*- coding: utf-8 -*-
"""
Created on Sun Jul 21 12:53:05 2019

@author: WSU-PNNL
"""
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import os
#%% Reading PCA input data
# Variables to set phase(0,1,2)
phase=1
visualize_fig=1
save_fig=1
model_name='Bus_123_case0'
file_path='D:\PCAdatasets'
file_name=model_name+'volt.xlsx'
file=os.path.join(file_path,file_name)
volt_phase=pd.read_excel(file,phase)
bus_names=list(volt_phase.columns)
#%% Determine No of principal components 
i=10
PCA_full=PCA(n_components=i)
subspace_full=PCA_full.fit_transform(volt_phase)
for n in range(0,1,i):
 if(abs(subspace_full[0,n]) < 0.01):
    break
n+=1
#%% Subspace projection of whole dataset
PCA_full=PCA(n_components=n)
subspace_full=PCA_full.fit_transform(volt_phase)
model_name=model_name+'components_'+str(n)
reconstructed_full=PCA_full.inverse_transform(subspace_full)
diff_full=reconstructed_full-volt_phase
select_bus=bus_names[1]
# Visualizing the projection of whole dataset
if(visualize_fig):
    plt.figure()
    plt.plot(volt_phase.index.values,subspace_full,label='Sub-space representation of whole dataset')
    plt.xlabel('Time step')
    plt.ylabel('Sub space values')
    plt.legend()
    plt.show()
    if(save_fig==1):
        plt.savefig(str(select_bus)+'Subspace projection full'+ model_name+'.png')
#%% Train PCA 70% split
end_index=int(volt_phase.shape[0]*0.7)
Feeder1_train=volt_phase[0:end_index].copy()
PCA_train=PCA(n_components=n)
subspace_train=PCA_train.fit_transform(Feeder1_train)
reconstructed_train=PCA_train.inverse_transform(subspace_train)
diff_train=reconstructed_train-Feeder1_train
#%% Inserting anomalies into PCA testing dataset
test_start=end_index-3
Feeder1_test=volt_phase[test_start:].copy()

# Case 2 : Missing measurements
Feeder1_test[select_bus].loc[end_index+1:end_index+3]=0
subspace_v2=PCA_train.transform(Feeder1_test)
reconstructed_v2=PCA_train.inverse_transform(subspace_v2)
subspace_diff2=subspace_v2-PCA_train.transform(volt_phase[test_start:])
reconstructed_diff2=reconstructed_v2-Feeder1_test

# Case 3 : Bad voltage measurements
Feeder1_test1=volt_phase[test_start:].copy()
Feeder1_test1[select_bus].loc[end_index+1:end_index+3]=0.95
subspace_v3=PCA_train.transform(Feeder1_test1)
subspace_diff3=subspace_v3-PCA_train.transform(volt_phase[test_start:])
reconstructed_v3=PCA_train.inverse_transform(subspace_v3)
reconstructed_diff3=reconstructed_v3-Feeder1_test1
#%% Visualzing the PCA anomlay test cases
if(visualize_fig):
    #Train and test data visualization
    plt.figure()
    plt.plot(Feeder1_train.index.values,subspace_full,label='Sub-space transformed original data ')
    plt.plot(Feeder1_test.index.values,subspace_v2,label='Missing data in timestep 1 and 2')
    plt.plot(Feeder1_test.index.values,subspace_v3,label='Low voltage limits in timestep 1 and 2')
    plt.xlabel('Time step')
    plt.ylabel('Sub space values')
    plt.legend()
    plt.show()
    if(save_fig==1):
        plt.savefig(str(select_bus)+'Subspace diff voltage dev'+ model_name+'.png')
    # Subspace difference 
    plt.figure()
    plt.plot(subspace_diff2,label='Missing data')
    plt.plot(subspace_diff3,label='Voltge data lower limits')
    plt.xlabel('Time step')
    plt.ylabel('Subspace Difference')
    plt.legend()
    plt.show()
    if(save_fig==1):
        plt.savefig(str(select_bus)+'Voltage dev'+ model_name+'.png')
    # Reconstructed voltage difference of node
    plt.figure()
    plt.plot(diff_full[bus_names[1]],label='Original data'+str(select_bus))
    plt.plot(reconstructed_diff2[bus_names[1]],label='Missing data')
    plt.plot(reconstructed_diff3[bus_names[1]],label='Voltge data lower limits')
    plt.xlabel('Time step')
    plt.ylabel('Reconstruction actual Difference')
    plt.legend()
    plt.show()
    if(save_fig==1):
        plt.savefig(str(select_bus)+'Voltage dev'+ model_name+'.png')
