
Demo/StateCapture/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* StateCapture.nc
* StateCaptureC.nc
* StateCaptureP.nc

Description
--------------------------------------------------------------------------------
This directory contains a component wired againt CC2420 driver in the order to
capture each radio state. It uses also a Counter to mesure the duration of a
state and stocks the total duration of each state into a array.
An interface called *StateCapture* is provided, when the command *getReport* is
called, a copy of the total duration of each state is returned and the array is
reset.

To enable the use of this component, the flag **CC2420_RADIO_STATE_CAPTURE**
must be defined in the Makefile of the caller component.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

