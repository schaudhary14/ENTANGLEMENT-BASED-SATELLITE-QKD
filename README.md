# SATELLITE-QKD
### **Project**
Entanglement-based satellite quantum key distribution (QKD).
### **Description**
In this project, the BBM92 satellite QKD protocol is modeled. A satellite with an entangled photon source based on spontaneous parametric down-conversion (SPDC) is in a low earth orbit. Alice and Bob want to generate a secret key using a satellite link and their optical ground stations (OGS) have some generalized coordinates on the earth. Depending upon the coordinates of Alice and Bob OGSs this program will estimate the sifted key rate and QBER for the protocol.
This program works for generalized dual-downlink configuration and helps in analyzing QKD performance for distances larger than fiber-based QKD. The program utilizes the Monte Carlo method to generate an ensemble of entangled states on a satellite and process each photon pair for losses in free space to reach Alice and Bob OGS. This simulation scheme is comprehensive as it incorporates the effects of aperture size, stray photons, and losses in the earth’s atmosphere in different weather conditions. This program contains various modules as described below: \
**Source module**: This module generates timestamps from the SPDC process of an entangled photon pair. Use this module to set the single photon-pair generation rate on the satellite. The photon from this module is input to the State Preparation module.\
**State Preparation module**: This module generates the timestamp of entangled photon pairs and marks each photon with polarization. The photon from this module is input to the Dual downlink module.\
**Dual downlink configuration module**: This module locates the coordinates of the satellite and calculates the distance between OGS and the satellite as a function of time along with the information of the elevation angle and zenith trajectory offset angle. This module generates all the necessary information for the link to be set between the satellite and OGS. The output of this module is used by the Channel module.\
**Channel module**: The channel module imports the link efficiency file depending on weather and atmospheric conditions. Various models are separately used to calculate losses in the atmosphere and the effect of turbulence. The output of this module is input to the detection module.\
**Detection module**: This module collects photons from the satellite along with stray thermal photons.\
**Single Photon Detector module**: This module simulates the realistic single photon detector with parameters four parameters: quantum efficiency, timing jitter, deadtime and dark counts.\
**Coincidence counting module**: Timestamps at the output of single photon detectors are post-processed to calculate the coincidence events when an entangled photon pair is detected by both Alice and Bob. These coincidence events will be used for the secret key generation process and the accidental counts generated from stray light, dark counts and alignment errors will contribute to the quantum bit error rate (QBER).
### **Installation**
This project will run on Matlab. Download all the files in one folder, open Matlab in that directory and run the script Simulation_Module.m.
All global parameters are to be input in Simulation_Module.m and individual changes in parameters can be modified in a particular module file.
### **Support**
In case of any issue or suggestion please email schaudhay@ce.iitr.ac.in. 
###  **Authors and acknowledgment**
I would like to thank Professor Daniel Oi for giving me an idea to model entanglement satellite QKD. I also like to thank Dr. Thomas Brougham for mentoring me while working on this project. Special thanks to QWorld organizing members for providing the platform to work in collaboration.
