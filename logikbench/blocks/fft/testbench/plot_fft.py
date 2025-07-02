import numpy as np
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend for saving files
import matplotlib.pyplot as plt

#######################################################
# WARNING: !!!WIP!!!
#######################################################
def generate_sine_wave(freq, sample_rate, n_samples):
    t = np.arange(n_samples) / sample_rate
    sine_wave = np.sin(2 * np.pi * freq * t)
    return t, sine_wave

def save_input_data(time, signal, filename="input_signal.txt"):
    with open(filename, 'w') as f:
        f.write("Time(seconds),Amplitude\n")
        for t, s in zip(time, signal):
            f.write(f"{t:.9f},{s:.9f}\n")
    print(f"Input signal data saved as {filename}")

def plot_signal(time, signal, filename="input_signal.png"):
    plt.figure(figsize=(10, 4))
    plt.plot(time, signal, marker='o', linestyle='-', markersize=6, color='b')
    plt.title("Input Sine Wave Samples")
    plt.xlabel("Time (seconds)")
    plt.ylabel("Amplitude")
    plt.grid(True)
    plt.savefig(filename)
    plt.close()
    print(f"Input signal plot saved as {filename}")

def plot_and_save_fft(signal, sample_rate, fft_size=64,
                      plot_filename="fft_output.png",
                      data_filename="fft_output.txt"):
    n = fft_size
    fft_vals = np.fft.fft(signal, n=n)
    fft_freqs = np.fft.fftfreq(n, 1/sample_rate)

    magnitude = np.abs(fft_vals) * 2 / n
    phase = np.angle(fft_vals)

    # Plot single-sided magnitude spectrum
    pos_mask = fft_freqs >= 0
    freqs_pos = fft_freqs[pos_mask]
    mag_pos = magnitude[pos_mask]

    plt.figure(figsize=(10, 6))
    plt.plot(freqs_pos, mag_pos, marker='o')
    plt.title('FFT Magnitude Spectrum (Single-Sided)')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.grid(True)
    plt.savefig(plot_filename)
    plt.close()
    print(f"FFT magnitude plot saved as {plot_filename}")

    # Save all FFT data points to text file
    with open(data_filename, 'w') as f:
        f.write("Frequency(Hz),Magnitude,Phase(radians)\n")
        for freq, mag, ph in zip(fft_freqs, magnitude, phase):
            f.write(f"{freq:.6f},{mag:.6f},{ph:.6f}\n")
    print(f"Full FFT data saved as {data_filename}")

if __name__ == "__main__":
    fs = 1024  # Sample rate in Hz
    f = 60     # Sine wave frequency in Hz
    N = 64     # Number of samples / FFT size

    time, sine = generate_sine_wave(f, fs, N)
    save_input_data(time, sine, filename="input_signal.txt")
    plot_signal(time, sine, filename="input_signal.png")
    plot_and_save_fft(sine, fs, fft_size=N,
                      plot_filename="fft_output.png",
                      data_filename="fft_output.txt")
