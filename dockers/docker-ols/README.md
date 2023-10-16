# Open Line System (OLS) Application Container
This container includes applications that perform optical control logic. 
## Auto-Gain Process
Auto-Gain automatically configures Amplifiers in a PtoP DWDM Connection based on configuration in AUTO_GAIN table. It is integrated as a third party application (debs package) into sonic. The integration is shown in the following diagram.

<img src="./ols-app-container.png" alt="SONiC for optical transport white-box system" style="zoom: 40%;">

## New apps can be added
Other optical applications can be added into this container.