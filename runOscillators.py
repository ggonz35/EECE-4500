import random

# Function to clamp a value within a specific range
def clamp(value, minimum, maximum):
    return max(minimum, min(value, maximum))

# Parameters for process variations and accepted ranges
tplv_nom = 1.0
tpwv_nom = 1.0
tnln_nom = 1.0
tnwn_nom = 1.0
tpotv_nom = 1.0
tnotv_nom = 1.0

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
        circuit_file.write("* Ring Oscillator Subcircuit\n")
        circuit_file.write(f".subckt ring_oscillator_{i} in out inverter\n")

        # Randomly vary parameters within accepted ranges
        for param, (min_value, max_value) in parameter_variations.items():
            variation = random.uniform(min_value, max_value)
            parameter_value = clamp(tplv_nom * variation, min_value, max_value)
            circuit_file.write(f".param {param} = {parameter_value}\n")

        # Include the inverter and define the ring oscillator
        circuit_file.write(".include inverter.txt\n")
        circuit_file.write(".include nand.txt\n")
        # Define the ring oscillator with inverters
        for j in range(12):
            in_pin = "in" if j == 0 else f"out{j-1}"
            out_pin = f"out{j}"
            circuit_file.write(f"X{j} {in_pin} {out_pin} inverter\n")

        # Connect the NAND gate to the ring oscillator with an enable signal
        circuit_file.write("X13 in inverter out nand\n")
        circuit_file.write("Venable in 0 PULSE(0 1 0 1n 1n 0.01n 0.02n 100n)\n")

        # Specify power supply and ground
        circuit_file.write("Vdd vdd 0 1.8V\n")
        circuit_file.write("Vss vss 0 0V\n")

        # Transient analysis with enable signal activation
        circuit_file.write(".tran 0.01n 100n 50n 0.01n UIC\n")

        # End of the subcircuit
        circuit_file.write(".ends\n")

print(f"{num_oscillators} ring oscillator subcircuits generated.")
