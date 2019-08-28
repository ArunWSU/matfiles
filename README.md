# Anomaly detection and mitigation using Principal Component Analysis
## Data generation
The data is generated in excel file for different event scenarios within 123 node test system using matlab (*.m*) file. There are options for 
visualization and storing of voltage measurement set.

## Principal Component Analysis
The correlated dataset(Voltage measurements) is reduced into it's top *k* components. The values need to be set in python (*.py*) program are
* file path and name
* 'i' representing initial number of components
* 'train_percent' representing fraction of training set data
*  Duration of anomalies
