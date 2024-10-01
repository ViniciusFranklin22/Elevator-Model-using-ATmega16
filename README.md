# Elevator Model with ATmega16

## Introduction
This project was developed as part of the Electrical Engineering course at UFJF, in the Microprocessors discipline. It consists of a three-story elevator model (ground floor, first floor, and second floor), implemented using the "AVR EVAL BOARD, Model AVR-E RvA" development board and the ATMEGA16X/32X microcontroller. The peripherals used in the project include:

- 16x2 Alphanumeric LCD Display
- 4x4 Button Matrix
- TCRT5000 Reflective Optical Sensor
- LEDs
- L298N H-Bridge Driver
- DC Motor

The software was developed using the CodeWizard IDE in C language. The button matrix was used to simulate elevator calls, with two columns representing internal (inside the elevator) and external (outside the elevator) calls. The LCD display shows the selected floor, which is added to a queue of requests managed by an optimized algorithm to minimize elevator travel.

The elevator's position is monitored by reflective optical sensors, with one sensor per floor, due to material limitations. The DC motor controls the elevator movement in three states: up, down, and stop. Since the motor does not have braking torque, an LED was used to represent the brake, which is sufficient for the model due to the low load of the elevator.

To operate the motor, an H-Bridge was used, powered by a 6V supply, allowing the motor to operate at maximum capacity. The door opening was simulated by another LED, as there was no material available for a physical implementation of this function.

## Future Improvements
To enhance the project, it would be interesting to implement a more stable braking system, utilizing additional sensors and digital controllers to adjust the speed via PWM. Adding a real braking system, as well as a door opening mechanism with presence or distance sensors for safety, would also be valuable improvements. An emergency button could be implemented to increase system safety.

Despite the limitations, the project was successfully completed, meeting the proposed demands.

## Files in the Repository
In this repository, you will find scripts demonstrating the use of peripherals, as well as the CodeVision IDE project files, containing the source code (.c) and project file (.prj). A demonstration video of the project is also available: **"Vídeo Demonstração Projeto.mp4."**
