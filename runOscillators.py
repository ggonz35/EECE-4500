import random

# Define the nominal transistor dimensions and oxide layer thickness
width = 130  # in nm
length = 100  # in nm (for example)
oxide_thickness = 15  # in nm (for example)

# Define process variation parameters
width_sigma = 0.065  # 6.5% standard deviation
length_sigma = 0.065  # 6.5% standard deviation
oxide_sigma = 0.05  # 5% standard deviation

# Define the number of ring oscillators to create
num_oscillators = 8


# Define a clamping function to ensure values are within the accepted range
def clamp(value, nominal, min_tolerance, max_tolerance):
    clamped_value = value * nominal
    clamped_value = max(min_tolerance * nominal, clamped_value)
    clamped_value = min(max_tolerance * nominal, clamped_value)
    return clamped_value


# Loop to create and save ring oscillator subcircuits
for i in range(num_oscillators):
    oscillator_name = f"ringoscillator{i}.cir"

    # Generate random variations within the specified tolerances
    random_width = clamp(random.uniform(0.85, 1.15), nominal_width, 0.85, 1.15)
    random_length = clamp(random.uniform(0.85, 1.15), nominal_length, 0.85, 1.15)
    random_oxide_thickness = clamp(random.uniform(0.9, 1.1), nominal_oxide_thickness, 0.9, 1.1)

    # Create and save the subcircuit for the ring oscillator
    with open(oscillator_name, 'w') as subcircuit_file:
        subcircuit_file.write(f".subckt ring_oscillator\n")
        subcircuit_file.write(f"// NMOS transistor parameters\n")
        subcircuit_file.write(f"M1 out1 net1 net2 NMOS L={random_length} W={random_width}\n")
        subcircuit_file.write(f"M2 out2 net2 net3 NMOS L={random_length} W={random_width}\n")
        # Add more transistors for the ring oscillator as needed
        subcircuit_file.write(f"// PMOS transistor parameters\n")
        # Add PMOS transistor definitions
        subcircuit_file.write(f".ends\n")

print(f"Created {num_oscillators} ring oscillator subcircuits.")
