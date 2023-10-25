import random

# Function to clamp a value within a specific range
def clamp(value, minimum, maximum):
    return max(minimum, min(value, maximum))

# Parameters for process variations and accepted ranges
param_nominal = {
    "tplv": 1.0,
    "tpwv": 1.0,
    "tnln": 1.0,
    "tnwn": 1.0,
    "tpotv": 1.0,
    "tnotv": 1.0
}

# Set parameter variation ranges
parameter_variations = {
    "tplv": (0.85, 1.15),
    "tpwv": (0.85, 1.15),
    "tnln": (0.85, 1.15),
    "tnwn": (0.85, 1.15),
    "tpotv": (0.85, 1.15),
    "tnotv": (0.85, 1.15),
}

# Number of ring oscillators to generate
num_oscillators = 8

# Create the file
for i in range(num_oscillators):
    circuit_filename = f"ring_oscillator_{i}.cir"
    with open(circuit_filename, "w") as circuit_file:
        # Write the circuit description
        circuit_file.write(f"* Ring Oscillator Subcircuit {i}\n")

        # Randomly vary parameters within accepted ranges
        for param, (min_value, max_value) in parameter_variations.items():
            variation = random.uniform(min_value, max_value)
            parameter_value = clamp(round(param_nominal[param] * variation, 2), min_value, max_value)
            circuit_file.write(f".param {param} = {parameter_value}\n")

        # Include the subcircuits for the inverter and NAND gate
        circuit_file.write(".include inverter.txt\n")
        circuit_file.write(".include nand.txt\n")

        # Write the basic connections to the circuit
        circuit_file.write("X1 in1 out1 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X2 out1 in2 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X3 in2 out2 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X4 out2 in3 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X5 in3 out3 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X6 out3 in4 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X7 in4 out4 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X8 out4 in5 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X9 in5 out5 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X10 out5 in6 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X11 in6 out6 inverter L=tplv*130n W=tpwv*130n\n")
        circuit_file.write("X12 out6 in1 inverter L=tplv*130n W=tpwv*130n\n")

        # Define the enable signal
        circuit_file.write("Venable enable 0 PULSE(0 1 0 1n 1n 0.01n 0.02n 100n) DC 0\n")

        # Connect the NAND gate to the ring oscillator with an enable signal
        circuit_file.write("X13 in1 enable out1_nand nand\n")
        circuit_file.write("X14 out1_nand in2 out1_nand nand\n")

print(f"{num_oscillators} ring oscillator subcircuits generated.")
