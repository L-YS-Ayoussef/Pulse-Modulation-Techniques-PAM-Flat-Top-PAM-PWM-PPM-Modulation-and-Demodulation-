# 📡 Pulse Modulation Techniques: PAM, Flat-Top PAM, PWM & PPM

## 🌍 Overview

This project implements and visualizes four fundamental pulse modulation techniques:

- Pulse Amplitude Modulation (PAM)
- Flat-Top Pulse Amplitude Modulation (Flat-Top PAM)
- Pulse Width Modulation (PWM)
- Pulse Position Modulation (PPM)

For each technique, both **modulation** and **demodulation** are demonstrated using simple mathematical models and signal plots.

## ✨ Features

- Implementation of:
  - **PAM** (pulse amplitude modulation & demodulation)
  - **Flat-Top PAM** (sample-and-hold modulation & demodulation)
  - **PWM** (duty-cycle based modulation & reconstruction)
  - **PPM** (pulse position based modulation & detection)
- Time-domain visualization of message, carrier/pulse train, and modulated waveforms.
- Simple mathematical expressions included for each technique.
- Waveform figures for documentation and reports.

## 🧩 Project Parts (Brief Explanation, Math & Figures)

---

### 1️⃣ PAM (Pulse Amplitude Modulation)

**Concept**

**Pulse Amplitude Modulation (PAM)** encodes the information in the **amplitude of periodic pulses**.

Let:

- \( m(t) \): message signal  
- \( p(t) \): pulse train  
- \( s(t) \): PAM modulated signal  

**Modulation (PAM)**

The PAM signal is obtained by multiplying the message signal by the pulse train:

\[
s(t) = m(t)\, p(t)
\]

**Demodulation (PAM)**

At the receiver, the PAM signal is sampled/multiplied again by a suitable pulse waveform \( p(t) \) and then passed through a low-pass filter (LPF) to recover the original message:

\[
\hat{m}(t) = s(t)\, p(t) \;\xrightarrow{\text{LPF}}\; m(t)
\]

**🖼️ Figures (PAM)**  

| PAM m1(t) | PAM m2(t) |
| ------------ | ------------ |
| ![Fig 1](WaveFigures/PAM1.png) | ![Fig 2](WaveFigures/PAM2.png) |

---

### 2️⃣ Flat-Top PAM

**Concept**

**Flat-Top PAM** is a variation of PAM where each pulse is **sampled and then held at a constant level** for the entire pulse duration. This produces “flat-top” pulses which make detection easier and reduce certain types of distortion.

Let:

- \( T_s \): sampling period  
- \( \tau \): pulse width (hold duration)  

**Modulation (Flat-Top PAM)**

The sampled-and-held signal can be expressed as:

\[
s(t) = \sum_{n=-\infty}^{\infty} m(nT_s)\, \text{rect}\!\left(\frac{t - nT_s}{\tau}\right)
\]

where \( \text{rect}(\cdot) \) represents a rectangular pulse of width \( \tau \).

**Demodulation (Flat-Top PAM)**

Similar to regular PAM, the received signal is sampled at the correct instants and then passed through a reconstruction/low-pass filter to approximate \( m(t) \):

\[
\hat{m}(t) \approx \text{LPF}\{s(t)\}
\]

**🖼️ Figures (Flat-Top PAM)**  

| Flat-Top PAM m1(t)| Flat-Top PAM m2(t) |
| --------------------- | --------------------- |
| ![Fig 1](WaveFigures/FlatTopPAM1.png) | ![Fig 2](WaveFigures/FlatTopPAM2.png) |

---

### 3️⃣ PWM (Pulse Width Modulation)

**Concept**

In **Pulse Width Modulation (PWM)**, the **width (duty cycle)** of each pulse is varied in proportion to the amplitude of the message signal, while the amplitude and position of the pulses remain fixed.

Let:

- \( T \): pulse period  
- \( D(t) \): duty cycle (between 0 and 1), controlled by \( m(t) \)  

**Modulation (PWM)**

Conceptually, the width of each pulse is:

\[
\text{Pulse width}(t) = D(t)\, T
\]

with \( D(t) \) chosen proportional to the normalized message \( m(t) \).

**Demodulation (PWM)**

To recover the message, the PWM signal is averaged over each period or passed through a low-pass filter, which converts the varying duty cycle back into an analog amplitude:

\[
\hat{m}(t) \approx \text{LPF}\{s(t)\}
\]

**🖼️ Figures (PWM)**  

| PWM m1(t) | PWM m2(t) |
| ------------ | ------------ |
| ![Fig 1](WaveFigures/PWM1.png) | ![Fig 2](WaveFigures/PWM2.png) |

---

### 4️⃣ PPM (Pulse Position Modulation)

**Concept**

In **Pulse Position Modulation (PPM)**, the **position (timing)** of each pulse within a time slot encodes the information, while the amplitude and width of the pulses remain constant.

Let:

- \( T \): symbol duration  
- \( \tau(m(t)) \): time shift (position) determined by the message  
- \( p(t) \): base pulse waveform  

**Modulation (PPM)**

A simple representation of the PPM signal is:

\[
s(t) = p\big(t - \tau(m(t))\big)
\]

For discrete symbols, the position can also be written as:

\[
s(t) = \sum_{k} p\big(t - kT - \tau_k\big)
\]

where \( \tau_k \) encodes the symbol sent in the \(k\)-th time slot.

**Demodulation (PPM)**

Demodulation is performed by accurately measuring the **arrival time** (position) of each pulse within its slot and mapping it back to the corresponding data value or symbol.

**🖼️ Figures (PPM)**  

| PPM m1(t) | PPM m2(t) |
| ------------ | ------------ |
| ![Fig 1](WaveFigures/PPM1.png) | ![Fig 2](WaveFigures/PPM2.png) |

---

## 📄 License

⚠️ **Important Notice:** This repository is publicly available for viewing only. Forking, cloning, or redistributing this project is **NOT** permitted without explicit permission.

Copyright (c) 2024 Chameleon Tech
