<br />
<p align="center">
  <h3 align="center">LDPC decoder written in SystemVerilog (IEEE 1800-2012)</h3>
</p>

<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#structure">Structure</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
This is an implementation of a min-sum LDPC decoder in Verilog. The current implementation is a length-10 code with 5 low-density parity check equations. The design rate is hence 0.5 info bits per bits transmitted. The min-sum algorithm iteratively solves the linear parallel parity-check equations. 5-10 iterations should be enough for convergence.

The purpose of this project is to provide the basic software for a low-energy high-speed binary decoder on an FPGA.


### Structure

* `LDPC.v`: Includes Verilog modules `VarToCheck`, `CheckToVar`, `Belief` and `Decoder`.
  * `VarToCheck`: Takes as input 3 check-to-variable messages and a channel evidence message. It then calculates the variable-to-check message by summing the 4 input messages.
  * `CheckToVar`: Takes as input 4 variable-to-check messages and calculates the check-to-variable message by assigning its magnitude to the input message of minimum magnitude and its sign to the sign of the product of the 4 input messages.
  * `Belief`: Takes as input 3 check-to-variable messages and a channel evidence message. It then calculates variable belief by summing the 4 input messages.
  * `Decoder`: Instantiates 25 `VarToCheck`, 25 `CheckToVar` and 10 `Belief` modules. Updates message register array at every clock cycle
* `tb.v`: Tests modules `VarToCheck`, `CheckToVar`, `Belief` and `Decoder` using controlled inputs.
* `top.v`: FPGA toplevel module. **Requires synthesiser compatible with SystemVerilog 2012**.
* `top.pcf`: pinout for iCE40 MDP LED.
* `belief_generator.py`: Generates verilog code for `Belief` module instantiations.
* `message_generator.py`: Generates verilog code for `VarToCheck` and `CheckToVar` module instantiations.
* `simulate.sh`: Shell script to simulate `tb.v` using `iverilog`.





<!-- GETTING STARTED -->
## Getting Started

To get started, simply run `simulate.sh` to generate `tb.vcd`.`tb.vcd` can be opened using a wave viewer such as `gtkwave`.

### Prerequisites
A text editor (which can, preferably, recognise Verilog syntax), a Verilog simulator such as the open-source [iverilog](https://github.com/steveicarus/iverilog).

<!-- LICENSE -->
## License

Distributed under the GNU License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Dimitris Alexandridis - [https://github.com/adimitris/](https://github.com/adimitris/)

Project Link: [https://github.com/adimitris/verilog-LDPC-decoder](https://github.com/adimitris/verilog-LDPC-decoder)
