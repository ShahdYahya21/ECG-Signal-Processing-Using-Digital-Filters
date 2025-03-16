## Digital Signal Processing (DSP) Project

### **Abstract**

This project focuses on processing raw ECG signals using digital filters to enhance signal quality and facilitate accurate diagnosis. High-pass and low-pass filters are applied to remove baseline wander and high-frequency noise. The results demonstrate improved signal clarity, making ECG signals more suitable for clinical analysis.

---

### **Methodology**

#### **Data Processing**

- Real-time column computed using sampling frequency (360 Hz).
- Signals visualized in time and frequency domains.

#### **Filtering Techniques**

- **High-pass filter**: Removes low-frequency noise (baseline wander).
- **Low-pass filter**: Attenuates high-frequency noise (muscle artifacts, electrical interference).
- **Combined filtering**: Applied in different orders (HP → LP, LP → HP) to compare effectiveness.

---

### **Conclusion**

Applying digital filters significantly improves ECG signal quality by eliminating noise while preserving key waveform components. The processed signals are clearer, aiding accurate diagnosis and automatic analysis.

For detailed methodology, equations, and MATLAB implementation, refer to the full project report.


