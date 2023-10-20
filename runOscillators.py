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

for i in range(num_oscillators):
    circuit_filename = f"ring_oscillator_{i}.cir"
    with open(circuit_filename, "w") as circuit_file:
        # Write the circuit description
        circuit_file.write(f"* Ring Oscillator Subcircuit {i}\n")

        # Randomly vary parameters within accepted ranges
        for param, (min_value, max_value) in parameter_variations.items():
            variation = random.uniform(min_value, max_value)
            parameter_value = clamp(param_nominal[param] * variation, min_value, max_value)
            circuit_file.write(f".param {param} = {parameter_value}\n")

        # Include the subcircuits for the inverter and NAND gate
        circuit_file.write(".include inverter.txt\n")
        circuit_file.write(".include nand.txt\n")

        # Define the ring oscillator with 12 inverters
        for j in range(12):
            in_pin = "in1" if j == 0 else f"out{j}"
            out_pin = f"out{j+1}" if j < 11 else "out1"
            circuit_file.write(f"X{j+1} {in_pin} {out_pin} inverter L=tplv*130n W=tpwv*130n\n")

        # Define the enable signal
        circuit_file.write("Venable enable 0 PULSE(0 1 0 1n 1n 0.01n 0.02n 100n) DC 0\n")

        # Connect the NAND gate to the ring oscillator with an enable signal
        circuit_file.write("X13 in1 enable out1_nand nand\n")
        circuit_file.write("X14 out1_nand in2 out1_nand nand\n")

print(f"{num_oscillators} ring oscillator subcircuits generated.")
