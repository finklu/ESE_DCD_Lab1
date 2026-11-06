import pandas as pd
import matplotlib.pyplot as plt

# 1. Load the CSV Data
# Analog Discovery exports usually have a 7-line header before the data.
csv_file = 'assets/data/cycle_EN_data.csv' 
df = pd.read_csv(csv_file, skiprows=7)

# Clean up column names (strips any accidental trailing spaces)
df.columns = df.columns.str.strip()

# 2. Extract Time and Signals
# Convert time from seconds to microseconds (µs) for a readable X-axis
time_us = df['Time (s)'] * 1e6

# Define the exact order of signals as they appear in your WaveForms GUI
signals = [
    'serial_out', 'parity_out', 'clk_out', 'load_strobe_out',
    'shift[8]', 'shift[7]', 'shift[6]', 'shift[5]', 
    'shift[4]', 'shift[3]', 'shift[2]', 'shift[1]', 'shift[0]'
]

# 3. Create the Logic Analyzer Plot
# Create subplots sharing the same X-axis, one for each signal
fig, axes = plt.subplots(nrows=len(signals), ncols=1, figsize=(10, 8), sharex=True)

# Remove vertical spacing between plots to mimic a logic analyzer
plt.subplots_adjust(hspace=0.0)

for i, signal in enumerate(signals):
    ax = axes[i]
    
    # Use 'step' plot for digital logic (where='post' ensures vertical edges at transitions)
    ax.step(time_us, df[signal], where='post', color='black', linewidth=1.2)
    
    # Format the Y-axis to give signals some breathing room
    ax.set_ylim(-0.2, 1.2)
    ax.set_yticks([])  # Hide the 0/1 numbers
    
    # Add the signal name to the left
    ax.set_ylabel(signal, rotation=0, ha='right', va='center', labelpad=15, fontsize=10)
    
    # Clean up the borders (spines) for a modern look
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    
    # Keep only the bottom timeline for the very last signal
    if i < len(signals) - 1:
        ax.spines['bottom'].set_visible(False)
        ax.tick_params(axis='x', length=0)

# Format the X-axis (Time)
axes[-1].set_xlabel('Time in µs ⟶', fontsize=12)
axes[-1].set_xlim(-2, 5)

# Add a title
fig.suptitle('9-bit PISO Shift Register - Hardware Measurement', fontsize=14, y=0.92)

# 4. Save the plot for Typst
# SVG is vector-based, so it stays infinitely sharp when zoomed in your PDF report
plt.savefig('analog_discovery_plot.svg', bbox_inches='tight')

print("Plot successfully saved as 'analog_discovery_plot.svg'")