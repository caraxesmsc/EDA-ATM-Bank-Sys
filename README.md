# ASIC ATM Core Design and Verification Project

## Overview

Welcome to the ASIC ATM Core Design and Verification project! This repository contains the implementation of the core of a bank ATM design, along with a comprehensive verification environment. The project aims to provide hands-on experience with the complete ASIC flow, covering both design and verification aspects.

## Project Structure

The project is organized into two main teams: the **Design Team** and the **Verification Team**.

### Design Team

- **System Architect/Design**: Describes the overall architecture and design of the ATM system.
- **High-Level Model**: Provides a high-level model of the system functionality.
- **Reference Model**: Offers a reference model for comparison and verification purposes.
- **Verilog Code**: Implementation of the ATM core using Verilog.

### Verification Team

- **Testbench**: Includes test stimuli generation, covering both directed and constraint-random testing.
- **Self-Checking Testbench**: Utilizes the reference model to create a self-checking testbench.
- **PSL Assertions**: Defines design properties and assertions using Property Specification Language (PSL).
- **Code Coverage**: Enables code coverage and generates reports for Statement, Branch, and FSM coverage.

## Auxiliary Devices

The ATM system assumes the existence of auxiliary devices such as card handling, language support, card passwords, timers, and other essential components. Account information, including passwords, account numbers, and balances, is assumed to be local with no external database connection.

### ATM System Features

- **Card Handling**: Simulates the functionality related to card insertion and handling.
- **Language Support**: Incorporates language-specific features and user prompts.
- **Card Password**: Manages the security aspect of card access using passwords.
- **Timers**: Implements time-related functionalities within the ATM system.
- **Operations**: Covers essential operations like Deposit, Withdraw, and Balance inquiry.
- **Balance Management**: Manages account balances, deposits, and withdrawals.

## Team Collaboration

Collaboration within the project is structured into two teams: Design Team and Verification Team.

### Design Team Responsibilities

- System architecture and design.
- High-level model creation.
- Reference model development.
- Verilog code implementation.

### Verification Team Responsibilities

- Testbench creation (directed and constraint-random).
- Self-checking testbench using the reference model.
- PSL assertion definition.
- Code coverage setup and reporting.

## Getting Started

To get started with the project, follow these steps:

1. Clone the repository to your local machine.
2. Review the documentation in each team's directory for detailed information.
3. Explore the Verilog code for the ATM core implementation.
4. Run the provided testbenches to verify the functionality.
5. Experiment with variations of directed and constraint-random testing.
